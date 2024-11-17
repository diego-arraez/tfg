//
//  RankingView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 21/10/24.
//

import SwiftUI

struct RankingView: View {
    
    let colors: [String: Color] = ["1": .yellow, "2": .gray, "3": Color("cobre")]
    let colors2: [String: [Color]] = ["cobre": [Color("cobre1"), Color("cobre2"), Color("cobre1"), Color("cobre2"), Color("cobre1")], "plata": [.gray, Color("plata"), .gray, Color("plata"), .gray], "oro": [.yellow, .brown, .yellow, .brown, .yellow], "diamante": [Color("diamante"), .blue, Color("diamante"), .blue, Color("diamante")]]
        
    @State var usuario = UserDefaults.standard.string(forKey: "usuario")
    
    @StateObject var viewModel: RankingViewModel = RankingViewModel()
    @StateObject var viewChartModel: ChartViewModel = ChartViewModel()
    
    @State private var mostrarLoading = true
    @State private var mostrarBienvenida = UserDefaults.standard.bool(forKey: "bienvenida")
    
    @State private var tiempoRestante = ""
    @State private var timer: Timer? = nil
    
    @State private var showUser: Bool = UserDefaults.standard.bool(forKey: "showUser")
    
    var body: some View {
  
        ZStack {
            NavigationView {
                    HStack {
                        Form {
                            
                            if !mostrarLoading {
                                    Section (footer:
                                                Text("Próxima actualización en \(tiempoRestante)")
                                        .onAppear {
                                            actualizarTiempoRestante()
                                            iniciarTimer()
                                        }
                                        .onDisappear {
                                            detenerTimer()
                                        }
                                    ) {
                                        
                                        VStack {
                                            Text("Valores actuales:")
                                                .font(.footnote)
                                            
                                            HStack {
                                                
                                                Spacer()
                                                VStack {
                                                    Text(compararUltimosValores(tipo: "cobre"))
                                                        .font(.caption)
                                                        .fontWeight(.black)
                                                        .frame(width: 20.0, height: 20.0)
                                                        .padding(2)
                                                        .background(
                                                            AngularGradient(
                                                                colors: colors2["cobre", default: [Color("filas"), Color("filas"), Color("filas"), Color("filas"), Color("filas")]],
                                                                center: .center,
                                                                startAngle: .degrees(90),
                                                                endAngle: .degrees(360)
                                                            )
                                                        )
                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                        .foregroundColor(Color.white)
                                                    
                                                    Text("x\(getUltimoValor(tipo: "cobre"))")
                                                        .font(.caption)
                                                }
                                                Spacer()
                                                VStack {
                                                    Text(compararUltimosValores(tipo: "plata"))
                                                        .font(.caption)
                                                        .fontWeight(.black)
                                                        .frame(width: 20.0, height: 20.0)
                                                        .padding(2)
                                                        .background(
                                                            AngularGradient(
                                                                colors: colors2["plata", default: [Color("filas"), Color("filas"), Color("filas"), Color("filas"), Color("filas")]],
                                                                center: .center,
                                                                startAngle: .degrees(90),
                                                                endAngle: .degrees(360)
                                                            )
                                                        )
                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                        .foregroundColor(Color.white)
                                                    
                                                    Text("x\(getUltimoValor(tipo: "plata"))")
                                                        .font(.caption)
                                                }
                                                Spacer()
                                                VStack {
                                                    Text(compararUltimosValores(tipo: "oro"))
                                                        .font(.caption)
                                                        .fontWeight(.black)
                                                        .frame(width: 20.0, height: 20.0)
                                                        .padding(2)
                                                        .background(
                                                            AngularGradient(
                                                                colors: colors2["oro", default: [Color("filas"), Color("filas"), Color("filas"), Color("filas"), Color("filas")]],
                                                                center: .center,
                                                                startAngle: .degrees(90),
                                                                endAngle: .degrees(360)
                                                            )
                                                        )
                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                        .foregroundColor(Color.white)
                                                    
                                                    Text("x\(getUltimoValor(tipo: "oro"))")
                                                        .font(.caption)
                                                }
                                                Spacer()
                                                VStack {
                                                    Text(compararUltimosValores(tipo: "diamante"))
                                                        .font(.caption)
                                                        .fontWeight(.black)
                                                        .frame(width: 20.0, height: 20.0)
                                                        .padding(2)
                                                        .background(
                                                            AngularGradient(
                                                                colors: colors2["diamante", default: [Color("filas"), Color("filas"), Color("filas"), Color("filas"), Color("filas")]],
                                                                center: .center,
                                                                startAngle: .degrees(90),
                                                                endAngle: .degrees(360)
                                                            )
                                                        )
                                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                                        .foregroundColor(Color.white)
                                                    
                                                    Text("x\(getUltimoValor(tipo: "diamante"))")
                                                        .font(.caption)
                                                }
                                                Spacer()
                                            }
                                        }.padding(.vertical, 2)
                                        
                                        
                                    }
                                    
                                
                            }
                            
                            Section() {
                                
                                if mostrarLoading {
                                    ProgressView("Obteniendo los últimos datos de la clasificación...")
                                        .progressViewStyle(.circular)
                                }
                                
                                if !mostrarLoading {
                                    if showUser {
                                        HStack {
                                            Spacer()
                                            Toggle("", isOn: $showUser)
                                                .tint(Color.yellow)
                                            Text("😎")
                                            
                                        }.listRowBackground(Color("yellowLight"))
                                            .listRowSeparator(.hidden)
                                    } else {
                                        HStack {
                                            Spacer()
                                            Toggle("", isOn: $showUser)
                                                .tint(Color.yellow)
                                            Text("😶‍🌫️")
                                            
                                        }.listRowBackground(Color("filas"))
                                            .listRowSeparator(.hidden)
                                    }
                                }
                                
                                
                                ForEach(filteredRanking(), id: \.name) { ranking in
                                                                        
                                    HStack(spacing: 10) {
                                        
                                        VStack(alignment: .leading) {
                                            
                                            Text("\(ranking.position)")
                                                .fontWeight(.black)
                                                .font(.system(size: 18))
                                                .frame(width: 42.0, height: 10.0)
                                                .padding(10)
                                                .foregroundColor(Color.black)
                                            
                                            
                                            
                                            
                                            Text("\(ranking.points) puntos")
                                                .font(.system(size: 13))
                                                .foregroundColor(Color.black)
                                            
                                        }
                                        
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing) {
                                            Text(ranking.position == "1" ? "👑 \(ranking.name)" : ranking.name)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                            
                                            
                                            HStack{
                                                
                                                Text("\(ranking.cobre)")
                                                    .font(.caption)
                                                    .fontWeight(.black)
                                                    .frame(width: Int(ranking.cobre) ?? 0 > 99 ? 30.0 : 20.0, height: 20.0)
                                                    .padding(2)
                                                    .background(
                                                        AngularGradient(
                                                            colors: [Color("cobre1"), Color("cobre2"), Color("cobre1"), Color("cobre2"), Color("cobre1")], // Color marrón-naranja
                                                            center: .center,
                                                            startAngle: .degrees(90),
                                                            endAngle: .degrees(360)
                                                        )
                                                    )
                                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                                    .foregroundColor(Color.white)
                                                
                                                Text("\(ranking.plata)")
                                                    .font(.caption)
                                                    .fontWeight(.black)
                                                    .frame(width: Int(ranking.plata) ?? 0 > 99 ? 30.0 : 20.0, height: 20.0)
                                                    .padding(2)
                                                    .background(AngularGradient(colors: [.gray, Color("plata"), .gray, Color("plata"), .gray],
                                                                                center: .center,
                                                                                startAngle: .degrees(90),
                                                                                endAngle: .degrees(360)))
                                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                                    .foregroundColor(Color.white)
                                                
                                                Text("\(ranking.oro)")
                                                    .font(.caption)
                                                    .fontWeight(.black)
                                                    .frame(width: Int(ranking.oro) ?? 0 > 99 ? 30.0 : 20.0, height: 20.0)
                                                    .padding(2)
                                                    .background(AngularGradient(colors: [.yellow, .brown, .yellow, .brown, .yellow],
                                                                                center: .center,
                                                                                startAngle: .degrees(90),
                                                                                endAngle: .degrees(360)))
                                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                                    .foregroundColor(Color.white)
                                                
                                                Text("\(ranking.diamante)")
                                                    .font(.caption)
                                                    .fontWeight(.black)
                                                    .frame(width: Int(ranking.diamante) ?? 0 > 99 ? 30.0 : 20.0, height: 20.0)
                                                    .padding(1)
                                                    .background(AngularGradient(colors: [Color("diamante"), .blue, Color("diamante"), .blue, Color("diamante")],
                                                                                center: .center,
                                                                                startAngle: .degrees(90),
                                                                                endAngle: .degrees(360)))
                                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                                    .foregroundColor(Color.white)
                                                
                                                
                                                
                                            }
                                            
                                        }
                                        
                                    }.listRowBackground(usuario == ranking.name ? Color("yellowLight") : Color("filas"))
     
                                }.onAppear {
                                    mostrarLoading = false
                                }
                            }
                            
                            
                            
                        
                            
                        }.onAppear {
                            mostrarBienvenida = UserDefaults.standard.bool(forKey: "bienvenida")
                            viewModel.getRanking()
                            viewChartModel.getChart()
                            showUser = UserDefaults.standard.bool(forKey: "showUser")
                            if mostrarBienvenida {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                    mostrarBienvenida = false
                                }
                            }
                        }
                    }.navigationTitle("Ranking 🚀")
                    
                
                
            }.refreshable { //gesto de "pull to refresh"
                viewModel.getRanking()
            }
            
            
            
            if mostrarBienvenida {
                GeometryReader { geometry in
                    Text("🎁 ¡Regalo de bienvenida!\nVisita la sección de 'Premios' para reclamar tu regalo.")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: geometry.size.width)
                        .background(Color("verdepastel"))
                        .offset(y: -geometry.safeAreaInsets.top + 40) // Posición en la parte superior
                    
                }
                
            }
            
            
        }
        
        
    }
    

    
    private func filteredRanking() -> [RankingDataModel] {
            if showUser {
                // Filtra el ranking solo para mostrar el usuario específico
                return viewModel.ranking.filter { $0.name == UserDefaults.standard.string(forKey: "usuario") }
            } else {
                // Muestra todos los elementos
                return viewModel.ranking
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

    
    func getUltimoValor(tipo: String) -> Int {
        guard let ultimoValor = viewChartModel.chart.last(where: { $0.tipo == tipo }) else {
            return 0 // Valor por defecto si no se encuentra el tipo
        }
        return Int(ultimoValor.valor) ?? 0
    }
    
    func compararUltimosValores(tipo: String) -> String {
        // Filtra los elementos por tipo y obtiene todos los que coinciden
        let valoresFiltrados = viewChartModel.chart.filter { $0.tipo == tipo }
        
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
    
    func getUpdate() -> String {
        guard let ultimaFecha = viewChartModel.chart.last(where: { $0.tipo == "diamante" }) else {
            return "" // Valor por defecto si no se encuentra el tipo
        }
        return formatTimestamp(ultimaFecha.fecha)
    }

    func formatTimestamp(_ timestampString: String) -> String {

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
            return "Hoy"
        } else if calendar.isDateInYesterday(date) {
            return "Ayer"
        } else {
            return ""
        }
    }
    
    func actualizarTiempoRestante() {
            tiempoRestante = tiempoRestanteHastaActualizacion()
        }
    
    func iniciarTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                actualizarTiempoRestante()
            }
        }
        
        func detenerTimer() {
            timer?.invalidate()
            timer = nil
        }
    
    func tiempoRestanteHastaActualizacion() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        // Crear los componentes de la fecha actual en GMT
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 14
        components.minute = 30
        components.second = 0
        
        // Establecer la zona horaria GMT para los componentes
        let gmtTimeZone = TimeZone(abbreviation: "GMT")
        components.timeZone = gmtTimeZone
        
        // Crear la fecha de la próxima actualización en GMT
        guard let nextUpdateDateGMT = calendar.date(from: components) else {
            return ""
        }
        
        // Si la hora de actualización ya pasó hoy, programar para mañana
        if now > nextUpdateDateGMT {
            if let nextDayGMT = calendar.date(byAdding: .day, value: 1, to: nextUpdateDateGMT) {
                return formatIntervaloHastaFecha(nextDayGMT, desde: now)
            }
        } else {
            return formatIntervaloHastaFecha(nextUpdateDateGMT, desde: now)
        }
        
        return ""
    }

    func formatIntervaloHastaFecha(_ fechaObjetivo: Date, desde fechaInicio: Date) -> String {
        let interval = Int(fechaObjetivo.timeIntervalSince(fechaInicio))
        
        let hours = interval / 3600
        let minutes = (interval % 3600) / 60
        let seconds = interval % 60
        
        return String(format: "%02dh %02dm %02ds", hours, minutes, seconds)
    }

}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView()
    }
}
