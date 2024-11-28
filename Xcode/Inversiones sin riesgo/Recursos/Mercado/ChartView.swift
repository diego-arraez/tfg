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

    @State private var showCopper = true
    @State private var showSilver = true
    @State private var showGold = true
    @State private var showDiamond = true

    @State private var showChart: Bool = UserDefaults.standard.bool(forKey: "showChart")
    
    @State private var showAlertCompra = false
    @State private var showAlertVenta = false
    @State private var transaccionBloqueada = false
    
    @State private var selectedRecurso: String = ""
    @State private var tipoTransaccion: String = ""
    
    @State private var shouldNavigateToCompra = false
    @State private var shouldNavigateToVenta = false

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
                                resourceRow(tipo: "cobre", cantidad: account.cobre, showToggle: $showCopper)
                                Divider()
                                resourceRow(tipo: "plata", cantidad: account.plata, showToggle: $showSilver)
                                Divider()
                                resourceRow(tipo: "oro", cantidad: account.oro, showToggle: $showGold)
                                Divider()
                                resourceRow(tipo: "diamante", cantidad: account.diamante, showToggle: $showDiamond)
                            }
                            .onAppear {
                                mostrarLoading = false
                                showChart = UserDefaults.standard.bool(forKey: "showChart")
                            }
                            .padding(.vertical, 2) // Reduce el padding vertical
                            
                        }.onAppear { almacenViewModel.getAlmacen() { respuesta in puntosTotales = respuesta } }
                        
                        if !showChart {
                            VStack {
                                if viewModel.chart.isEmpty {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                } else {
                                    
                                    Chart {
                                        if showCopper {
                                            plotData(for: "cobre", data: viewModel.chart)
                                        }
                                        if showSilver {
                                            plotData(for: "plata", data: viewModel.chart)
                                        }
                                        if showGold {
                                            plotData(for: "oro", data: viewModel.chart)
                                        }
                                        if showDiamond {
                                            plotData(for: "diamante", data: viewModel.chart)
                                        }
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
                    }
                    if !showChart {
                        Section (){
                            Text("")
                            Text("")
                        }.listRowBackground(Color("fondoLista"))
                        .listRowSeparator(.hidden)
                    }
                }.navigationTitle("Mercado 💰")
                .onAppear {
                    viewModel.getChart()
                    almacenViewModel.getAlmacen { _ in }
                }
                
                if !mercadoCerrado() {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                self.showAlertCompra = true
                                
                            } label: {
                                Label("Comprar", systemImage: "square.and.arrow.down")
                                    .foregroundStyle(Color.white)
                                    .padding()
                                    .background(Color.yellow)
                                    .cornerRadius(25)
                                    .shadow(radius: 5)
                            }
                            
                            .buttonStyle(BorderlessButtonStyle())
                            .actionSheet(isPresented: $showAlertCompra) {
                                actionSheet_Compra()
                            }
                            
                            
                            Spacer()
                            Button {
                                self.showAlertVenta = true
                            } label: {
                                Label("Vender", systemImage: "square.and.arrow.up")
                                    .foregroundStyle(Color.white)
                                    .padding()
                                    .background(Color.yellow)
                                    .cornerRadius(25)
                                    .shadow(radius: 5)
                            }
                            
                            .buttonStyle(BorderlessButtonStyle())
                            .actionSheet(isPresented: $showAlertVenta) {
                                actionSheet_Venta()
                            }
                            Spacer()
                        }
                        
                    }
                    .padding(.bottom)
                    .background(Color.clear)
                }
                
                NavigationLink(
                    destination: CompraView(
                        viewModel: almacenViewModel,
                        selectedRecurso: selectedRecurso,
                        precioPorUnidad: getPriceForRecurso(recurso: selectedRecurso),
                        recursosUser: getCantidadForRecurso(recurso: selectedRecurso),
                        coinsUser: String(lastCoins()),
                        puntosTotales: getPuntosTotales()
                    ),
                    isActive: $shouldNavigateToCompra
                ) {
                    EmptyView()
                }
                
                NavigationLink(
                    destination: VentaView(
                        viewModel: almacenViewModel,
                        selectedRecurso: selectedRecurso,
                        precioPorUnidad: getPriceForRecurso(recurso: selectedRecurso),
                        recursosUser: getCantidadForRecurso(recurso: selectedRecurso),
                        coinsUser: String(lastCoins()),
                        puntosTotales: getPuntosTotales()
                    ),
                    isActive: $shouldNavigateToVenta
                ) {
                    EmptyView()
                }
                
                
            }.onAppear {
                viewModel.getChart()
            }
            
            .alert("\(selectedRecurso.capitalized):\n🚫 Tienes que esperar al siguiente cierre de mercado\n", isPresented: $transaccionBloqueada) {
                Button("OK", role: .cancel) {}
            } message: { Text("Para cada recurso sólo puedes realizar una transacción en el Mercado desde la última actualización de valores.\n\nPuedes esperar a la siguiente actualización o probar con otro recurso.") }
            
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
        
    func transaccion(tipo: String, transaccion: String) {
        selectedRecurso = tipo
        if puedeTransaccion(recurso: selectedRecurso) {
            if transaccion == "compra" {
                self.shouldNavigateToCompra = true
            } else {
                self.shouldNavigateToVenta = true
            }
        } else {
                transaccionBloqueada = true
        }
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

    func getPriceForRecurso(recurso: String) -> Int {
        if let data = viewModel.chart.last(where: { $0.tipo == recurso }) {
            return Int(data.valor) ?? 0
        }
        return 0
    }

    func getCantidadForRecurso(recurso: String) -> Int {
        guard let almacen = almacenViewModel.account.first else { return 0 }
        switch recurso {
        case "cobre": return Int(almacen.cobre) ?? 0
        case "plata": return Int(almacen.plata) ?? 0
        case "oro": return Int(almacen.oro) ?? 0
        case "diamante": return Int(almacen.diamante) ?? 0
        default: return 0
        }
    }
    
    func getPuntosTotales() -> Int {
        
            let puntosCobre = getCantidadForRecurso(recurso: "cobre") * getUltimoValor(tipo: "cobre")
            let puntosPlata = getCantidadForRecurso(recurso: "plata") * getUltimoValor(tipo: "plata")
            let puntosOro = getCantidadForRecurso(recurso: "oro") * getUltimoValor(tipo: "oro")
            let puntosDiamante = getCantidadForRecurso(recurso: "diamante") * getUltimoValor(tipo: "diamante")
        
        return puntosCobre + puntosPlata + puntosOro + puntosDiamante
    }
    
    func actionSheet_Compra() -> ActionSheet {
            if lastCoins() == 0 {
                return ActionSheet(
                    title: Text("COMPRAR\n"),
                    message: Text("🚫 No dispones de coins para realizar ninguna compra. Vende algún recurso para obtener coins."),
                    buttons: [
                        .cancel(Text("Cancelar"))
                    ]
                )
            } else {
                return ActionSheet(
                    title: Text("COMPRAR\n"),
                    message: Text("Sólo podrás realizar una transacción en el Mercado por cada recurso hasta la siguiente actualización de valores."),
                    buttons: [
                        .default(Text("🟤 Cobre \(recomendaciones(tipo: "cobre", transaccion: "compra"))")) {
                            transaccion(tipo: "cobre", transaccion: "compra")
                        },
                        .default(Text("⚪️ Plata \(recomendaciones(tipo: "plata", transaccion: "compra"))")) {
                            transaccion(tipo: "plata", transaccion: "compra")
                        },
                        .default(Text("🟡 Oro \(recomendaciones(tipo: "oro", transaccion: "compra"))")) {
                            transaccion(tipo: "oro", transaccion: "compra")
                        },
                        .default(Text("💎 Diamante \(recomendaciones(tipo: "diamante", transaccion: "compra"))")) {
                            transaccion(tipo: "diamante", transaccion: "compra")
                        },
                        .cancel(Text("Cancelar"))
                    ]
                )
            }
        }
    
    func actionSheet_Venta() -> ActionSheet {
            if getPuntosTotales() == 0 {
                return ActionSheet(
                    title: Text("VENDER\n"),
                    message: Text("🚫 No dispones de recursos para realizar una venta."),
                    buttons: [
                        .cancel(Text("Cancelar"))
                    ]
                )
            } else {
                let botonesRecursos: [ActionSheet.Button] = {
                    var botonesRecursos: [ActionSheet.Button] = []
                    
                    if getCantidadForRecurso(recurso: "cobre") != 0 {
                        botonesRecursos.append(
                            .default(Text("🟤 Cobre \(recomendaciones(tipo: "cobre", transaccion: "venta"))")) {
                                transaccion(tipo: "cobre", transaccion: "venta")
                            }
                        )
                    }
                    
                    if getCantidadForRecurso(recurso: "plata") != 0 {
                        botonesRecursos.append(
                            .default(Text("⚪️ Plata \(recomendaciones(tipo: "plata", transaccion: "venta"))")) {
                                transaccion(tipo: "plata", transaccion: "venta")
                            }
                        )
                    }
                    
                    if getCantidadForRecurso(recurso: "oro") != 0 {
                        botonesRecursos.append(
                            .default(Text("🟡 Oro \(recomendaciones(tipo: "oro", transaccion: "venta"))")) {
                                transaccion(tipo: "oro", transaccion: "venta")
                            }
                        )
                    }
                    
                    if getCantidadForRecurso(recurso: "diamante") != 0 {
                        botonesRecursos.append(
                            .default(Text("💎 Diamante \(recomendaciones(tipo: "diamante", transaccion: "venta"))")) {
                                transaccion(tipo: "diamante", transaccion: "venta")
                            }
                        )
                    }
                    
                    // Botón "Cancelar"
                    botonesRecursos.append(.cancel(Text("Cancelar")))
                    
                    return botonesRecursos
                }()
                
                return ActionSheet(
                    title: Text("VENDER\n"),
                    message: Text("Sólo podrás realizar una transacción en el Mercado por cada recurso hasta la siguiente actualización de valores."),
                    buttons: botonesRecursos
                )
            }
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
    
    func puedeTransaccion(recurso: String) -> Bool {
        if let ultimaVenta = UserDefaults.standard.object(forKey: "ultimaTransaccion_\(recurso)") as? Date {
            if let lastUpdateDate = obtenerUltimaFechaHoraActualizacion() {
                
                // Si la última venta es después de la última actualización, no se permite la transacción
                if ultimaVenta > lastUpdateDate {
                    return false
                }
            }
        }
        return true
    }
    
    func obtenerUltimaFechaHoraActualizacion() -> Date? {
        let calendar = Calendar.current
        let now = Date()
        
        // Obtener la fecha de hoy a las 13:30 GMT
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 13
        components.minute = 30
        components.second = 0

        let gmtTimeZone = TimeZone(abbreviation: "GMT")
        components.timeZone = gmtTimeZone

        guard let todayUpdateDate = calendar.date(from: components) else {
            return nil
        }

        // Si la fecha actual es antes de la actualización de hoy, usar la actualización de ayer
        if now < todayUpdateDate {
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: todayUpdateDate) {
                return yesterday
            }
        }

        // De lo contrario, usar la actualización de hoy
        return todayUpdateDate
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
    
    func recomendaciones(tipo: String, transaccion: String) -> String {
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
        if transaccion == "venta" {
            if penultimo < ultimo {
                return "🔝"
            } else {
                return ""
            }
        } else { //compra
            if penultimo > ultimo {
                return "🔝"
            } else {
                return ""
            }
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
            return "(Mañana)"
        } else if calendar.isDateInYesterday(date) {
            return "" //HOY
        } else {
            return ""
        }
    }
    
    
    
    

    private func resourceRow(tipo: String, cantidad: String, showToggle: Binding<Bool>) -> some View {
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
            
            Spacer()
            
            if !showChart {
                Toggle("", isOn: showToggle)
                    .tint(Color.yellow)
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


