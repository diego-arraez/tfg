//
//  ChartView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 21/10/24.
//

import SwiftUI
import Charts

struct ChartView: View {
   
    @State var usuario = UserDefaults.standard.string(forKey: "usuario")
    @StateObject var viewModel: ChartViewModel = ChartViewModel()
    @StateObject var almacenViewModel: AlmacenViewModel = AlmacenViewModel()
    
    
    let colors: [String: [Color]] = [
        "cobre": [Color("cobre1"), Color("cobre2"), Color("cobre1"), Color("cobre2"), Color("cobre1")],
        "plata": [.gray, Color("plata"), .gray, Color("plata"), .gray],
        "oro": [.yellow, .brown, .yellow, .brown, .yellow],
        "diamante": [Color("diamante"), .blue, Color("diamante"), .blue, Color("diamante")],
        "moneda": [.yellow, .brown, .yellow, .brown, .yellow]
    ]
    
    @State private var mostrarLoading = true
    @State private var puntosTotales = "0"

    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                                        
                    Section(header: Text(mercadoCerrado() ? "🚫 Mercado cerrado hasta las \(String(convertToLocalTime(hour: 14, minute: 30, fromTimeZoneAbbreviation: "GMT") ?? ""))" : "🎉 Abierto hasta las \(String(convertToLocalTime(hour: 14, minute: 00, fromTimeZoneAbbreviation: "GMT") ?? "")) \(getNextUpdate())"),
                            footer: Text("Puedes mostrar u ocultar el gráfico de valores en 'Ajustes', desde el botón inferior 'Cuenta'")) {
                        
                        if mostrarLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        
                        ForEach(almacenViewModel.account, id: \.points) { account in
                            
                            VStack {
                                HStack {
                                    Text("\(lastCoins())")
                                    .font(.caption)
                                    .fontWeight(.black)
                                    .frame(width: lastCoins() > 99 ? 30.0 : 20.0, height: 20.0)
                                    .padding(2)
                                    .background(
                                        ZStack {
                                            
                                            AngularGradient(
                                                gradient: Gradient(colors: colors["moneda", default: [Color.yellow, Color.orange]]),
                                                center: .center,
                                                startAngle: .degrees(0),
                                                endAngle: .degrees(360)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 25))
                                            
                                            
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(
                                                    AngularGradient(
                                                        gradient: Gradient(colors: [Color.white, Color.gray, Color.white]),
                                                        center: .center,
                                                        startAngle: .degrees(0),
                                                        endAngle: .degrees(360)
                                                    )
                                                )
                                                .padding(3) // Padding para simular un borde
                                        }
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                    .foregroundColor(Color("numeroMoneda"))
                                    
                                    VStack(alignment: .leading) {
                                        Text("Coins")
                                        Text("Tienes \(lastCoins())")
                                            .font(.system(size: 10))
                                            .foregroundColor(lastCoins() == 0 ? Color(.red) : Color("grisOscuro"))
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 2)
                                Divider()
                                resourceRow(tipo: "cobre", cantidad: account.cobre)
                                Divider()
                                resourceRow(tipo: "plata", cantidad: account.plata)
                                Divider()
                                resourceRow(tipo: "oro", cantidad: account.oro)
                                Divider()
                                resourceRow(tipo: "diamante", cantidad: account.diamante)
                            }
                            .onAppear {
                                mostrarLoading = false
                                
                            }
                            .padding(.vertical, 2) // Reduce el padding vertical
                            
                        }.onAppear { almacenViewModel.getAlmacen() { respuesta in puntosTotales = respuesta } }
                        
			VStack {
                                if viewModel.chart.isEmpty {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                } else {
                                    
                                    Chart {
                                        
                                            plotData(for: "cobre", data: viewModel.chart)
                                        
                                        
                                            plotData(for: "plata", data: viewModel.chart)
                                        
                                        
                                            plotData(for: "oro", data: viewModel.chart)
                                        
                                        
                                            plotData(for: "diamante", data: viewModel.chart)
                                        
                                    }
                                    .frame(height: 250)
                                    .padding(.horizontal)
                                    .chartXScale(domain: 0...5)
                                    .chartYScale(domain: 0...getMaxYValue())
                                    .chartYAxis(.hidden)
                                    .chartXAxis {
                                        AxisMarks { value in
                                            
                                            AxisValueLabel {
                                                Text("")
                                            }
                                            
                                            AxisTick(centered: true)
                                            AxisGridLine(centered: true)
                                        }
                                    }
                                    
                                    
                                    
                                    HStack {
                                        Text("Hace 5 días")
                                            .foregroundColor(Color("grisOscuro"))
                                            .font(.system(size: 10))
                                        Spacer()
                                        Text("Ahora")
                                            .foregroundColor(Color("grisOscuro"))
                                            .font(.system(size: 10))
                                    }
                                }
                                
                            }.padding(.vertical, 2)
                    }
			Section (){
                            Text("")
                            Text("")
                        }.listRowBackground(Color("fondoLista"))
                        .listRowSeparator(.hidden)
                }.navigationTitle("Mercado 💰")
                .onAppear {
                    viewModel.getChart()
                    almacenViewModel.getAlmacen { _ in }
                }
                
            }.onAppear {
                viewModel.getChart()
            }
                
        }
        
    }
    

    
    func convertToLocalTime(hour: Int, minute: Int, fromTimeZoneAbbreviation: String) -> String? {
        // Crear el calendario y la fecha actual
        let calendar = Calendar.current
        let now = Date()
        
        // Crear los componentes de la fecha objetivo
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: now)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // Obtener la zona horaria de origen (GMT+2)
        guard let sourceTimeZone = TimeZone(abbreviation: fromTimeZoneAbbreviation) else {
            return nil
        }
        
        // Crear la fecha objetivo en la zona horaria de origen
        guard let sourceDate = calendar.date(from: dateComponents) else {
            return nil
        }
        
        // Calcular el intervalo de tiempo entre la zona horaria de origen y la zona horaria local
        let targetSeconds = sourceTimeZone.secondsFromGMT(for: sourceDate)
        let localSeconds = TimeZone.current.secondsFromGMT(for: sourceDate)
        let timeInterval = TimeInterval(localSeconds - targetSeconds)
        
        // Ajustar la fecha a la hora local
        let localDate = sourceDate.addingTimeInterval(timeInterval)
        
        // Crear el date formatter para mostrar la fecha en el formato deseado
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: localDate)
    }
     
    
    func lastCoins() -> Int {
        return Int(viewModel.chart.last?.coins ?? "0") ?? 0
    }
    
    func getUltimoValor(tipo: String) -> Int {
        guard let ultimoValor = viewModel.chart.last(where: { $0.tipo == tipo }) else {
            return 0 // Valor por defecto si no se encuentra el tipo
        }
        return Int(ultimoValor.valor) ?? 0
    }


    @ChartContentBuilder
    private func plotData(for tipo: String, data: [ChartDataModel]) -> some ChartContent {
        let filteredData = data.filter { $0.tipo == tipo }
        let color = colorForTipo(tipo: tipo)

        ForEach(filteredData.indices, id: \.self) { index in
            let currentData = filteredData[index]

            LineMark(
                x: .value("Index", index),
                y: .value("Value", Int(currentData.valor) ?? 0),
                series: .value("Type", tipo)
            )
            .foregroundStyle(color.lineColor)
            .lineStyle(StrokeStyle(lineWidth: 4))
            .interpolationMethod(.catmullRom)

            PointMark(
                x: .value("Index", index),
                y: .value("Value", Int(currentData.valor) ?? 0)
            )
            .foregroundStyle(color.pointColor)
            .annotation(position: .top, alignment: .center) {
                Text("\(Int(currentData.valor) ?? 0)")
                    .font(.caption)
                    .foregroundColor(Color("grisOscuro"))
            }
        }
    }
    
    func mercadoCerrado() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        // Obtener la hora actual en GMT
        let timeZone = TimeZone(abbreviation: "GMT")
        let gmtNow = now.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: timeZone!)

        let components = calendar.dateComponents([.hour, .minute], from: gmtNow)
        
        guard let gmtHour = components.hour, let gmtMinute = components.minute else {
            return false
        }
        
        // Verificar si la hora actual está entre las 13:00 y las 13:30 GMT
        if (gmtHour == 14 && gmtMinute >= 0 && gmtMinute < 30) {
            return true // Mercado cerrado
        } else {
            return false // Mercado abierto
        }
    }
    
    func getMaxYValue() -> Double {
        let maxCopper = viewModel.chart.filter { $0.tipo == "cobre" }.compactMap { Double($0.valor) }.max() ?? 0
        let maxSilver = viewModel.chart.filter { $0.tipo == "plata" }.compactMap { Double($0.valor) }.max() ?? 0
        let maxGold = viewModel.chart.filter { $0.tipo == "oro" }.compactMap { Double($0.valor) }.max() ?? 0
        let maxDiamond = viewModel.chart.filter { $0.tipo == "diamante" }.compactMap { Double($0.valor) }.max() ?? 0
        
        return max(maxCopper, maxSilver, maxGold, maxDiamond) + 1
    }

    func colorForTipo(tipo: String) -> (lineColor: Color, pointColor: Color) {
        switch tipo {
        case "cobre":
            return (Color("cobre1"), Color("cobre2"))
        case "plata":
            return (.gray, Color("grisOscuro"))
        case "oro":
            return (.yellow, .brown)
        case "diamante":
            return (Color("diamante"), .blue)
        default:
            return (.primary, .primary)
        }
    }
    func compararUltimosValores(tipo: String) -> String {
        // Filtra los elementos por tipo y obtiene todos los que coinciden
        let valoresFiltrados = viewModel.chart.filter { $0.tipo == tipo }
        
        // Verifica si hay al menos dos elementos en el resultado filtrado
        guard valoresFiltrados.count > 1 else {
            return "" // Valor por defecto si no hay suficientes elementos
        }
        
        // Obtiene el último y el penúltimo valor en la lista filtrada
        let ultimoValor = valoresFiltrados.last!
        let penultimoValor = valoresFiltrados[valoresFiltrados.count - 2]
        
        // Convierte los valores a enteros, si es posible
        let ultimo = Int(ultimoValor.valor) ?? 0
        let penultimo = Int(penultimoValor.valor) ?? 0
        
        // Compara los valores y devuelve el resultado correspondiente
        if penultimo > ultimo {
            return "↓"
        } else if penultimo < ultimo {
            return "↑"
        } else {
            return "="
        }
    }
    

    func getNextUpdate() -> String {
        guard let ultimaFecha = viewModel.chart.last(where: { $0.tipo == "diamante" }) else {
            return "" // Valor por defecto si no se encuentra el tipo
        }
        return formatNextTimestamp(ultimaFecha.fecha)
    }

    func formatNextTimestamp(_ timestampString: String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: timestampString) else {
            print("Failed to convert timestampString to Date")
            return timestampString // Si la conversión falla, devolver la cadena original
        }

        let calendar = Calendar.current

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        if calendar.isDateInToday(date) {
            return ""
        } else if calendar.isDateInYesterday(date) {
            return "(Ayer)"
        } else {
            return ""
        }
    }
    
    
    
    

    private func resourceRow(tipo: String, cantidad: String) -> some View {
        HStack {
            Text("\((Int(cantidad) ?? 0))")
                .font(.caption)
                .fontWeight(.black)
                .frame(width: Int(cantidad) ?? 0 > 99 ? 30.0 : 20.0, height: 20.0)
                .padding(2)
                .background(
                    AngularGradient(
                        colors: colors[tipo, default: [Color("filas"), Color("filas"), Color("filas"), Color("filas"), Color("filas")]],
                        center: .center,
                        startAngle: .degrees(90),
                        endAngle: .degrees(360)
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .foregroundColor(Color.white)
            
            VStack (alignment: .leading) {
                Text(tipo.capitalized)
                    .foregroundColor(Color.black)
                
                Text("Mi cartera: \((Int(cantidad) ?? 0) * getUltimoValor(tipo: tipo)) puntos")
                    .foregroundColor(Color("grisOscuro"))
                    .font(.system(size: 10))
                
                Text("Valor actual: \(getUltimoValor(tipo: tipo)) puntos \(compararUltimosValores(tipo: tipo))")
                    .foregroundColor(Color.black)
                    .font(.system(size: 10))
            }
            
        }
        .padding(.vertical, 2) // Reduce el padding vertical
    }
}


extension Array where Element == ChartDataModel {
    var groupedByTipo: [String: [ChartDataModel]] {
        Dictionary(grouping: self, by: { $0.tipo })
    }
}
// Extensión para convertir la hora de una zona horaria a otra
extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
}


