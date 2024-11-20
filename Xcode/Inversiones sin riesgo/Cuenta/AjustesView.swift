//
//  AjustesView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 13/11/24.
//

import SwiftUI
import AuthenticationServices

struct AjustesView: View {
    
    @EnvironmentObject var autenticacion: Autenticacion
    
    @State var usuario = UserDefaults.standard.string(forKey: "usuario")
    
    @State private var showAlertLogout = false
    @State private var showAlertNotify = false
    
    
    @State private var notifyReminder: Bool = UserDefaults.standard.bool(forKey: "notifyReminder")
    @State private var showUser: Bool = UserDefaults.standard.bool(forKey: "showUser")
    @State private var showChart: Bool = UserDefaults.standard.bool(forKey: "showChart")
    
    var body: some View {
        
        NavigationView {
            
            Form {
                List {
                    Section ("Ranking") {
                        Toggle("Mostrar por defecto únicamente tu usuario", isOn: $showUser)
                            .tint(Color.yellow)
                            .onChange(of: showUser) { newValue in
                                updateShowUser(newValue)
                            }
                        
                    }
                    
                    Section ("Mercado") {
                        Toggle("Ocultar gráfico de valores", isOn: $showChart)
                            .tint(Color.yellow)
                            .onChange(of: showChart) { newValue in
                                updateShowChart(newValue)
                            }
                        Toggle("Notifícame 15 minutos antes del cierre de mercado", isOn: $notifyReminder)
                            .tint(Color.yellow)
                            .onChange(of: notifyReminder) { newValue in
                                updateNotification(newValue)
                            }
                        
                        
                    }.alert("⚠️ Notificaciones desactivadas\n", isPresented: $showAlertNotify) {
                        
                        Button("OK", role: .cancel) { }
                    } message: { Text("Habilita las notificaciones para poder recibir el aviso de de cierre de mercado:\n\n\n1️⃣ Abre ⚙ Ajustes\n2️⃣ Ve a Notificaciones\n3️⃣ Selecciona IsR\n4️⃣ Selecciona 'Permitir notificaciones'") }
                    
                    Section () {
                        Text("")
                    }.background(Color(.clear))
                        .listRowBackground(Color(.clear))
                    
                    Section() {
                        HStack{
                            Spacer()
                            VStack {
                                Text(String("Release: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"))
                                    .font(.caption)
                                    .foregroundColor(Color.gray)
                                Text("")
                                    .font(.caption)
                                    .foregroundColor(Color.gray)
                                Text("© Diego Arráez\nTFG 2024-25 (UOC)")
                                    .font(.caption)
                                    .foregroundColor(Color.gray)
                                
                            }
                            
                            
                            Spacer()
                        }
                    }.listRowBackground(Color("fondoLista"))
                        .listRowSeparator(.hidden)
                    
                    Section() {
                        Button("Cerrar sesión") {
                            showAlertLogout = true
                            
                        }.foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                        
                    }
                    
                    
                }.onAppear {
                    showChart = UserDefaults.standard.bool(forKey: "showChart")
                    showUser = UserDefaults.standard.bool(forKey: "showUser")
                }
                .alert("¿Estás seguro?", isPresented: $showAlertLogout) {
                    
                    Button("Cancelar", role: .cancel) { }
                    Button("Cerrar sesión") { autenticacion.logout() }
                } message: { Text("") }
                    
                    
                
            }//Navigation
            
            
            
        }//VIEW
        
    }
    
    func updateShowChart(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "showChart")
    }
    func updateNotification(_ value: Bool) {
        if !value {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UserDefaults.standard.set(false, forKey: "notificacionActiva")
        } else {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus != .authorized {
                    // Solicitar permiso de notificación
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        if granted {
                            if !UserDefaults.standard.bool(forKey: "notificacionActiva") {
                                programarNotificacionDiaria(horaGMT: 13, minutoGMT: 45)
                                UserDefaults.standard.set(true, forKey: "notificacionActiva")
                            }
                            
                        } else {
                            showAlertNotify = true
                            notifyReminder.toggle()
                        }
                    }
                } else {
                    if !UserDefaults.standard.bool(forKey: "notificacionActiva") {
                        programarNotificacionDiaria(horaGMT: 13, minutoGMT: 45)
                        UserDefaults.standard.set(true, forKey: "notificacionActiva")
                    }
                }
            }
            
        }
        UserDefaults.standard.set(value, forKey: "notifyReminder")
    }
    func updateShowUser(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "showUser")
    }
    
    func updateShowValores(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "showValores")
    }
    
    func programarNotificacionDiaria(horaGMT: Int, minutoGMT: Int) {
        // Contenido de la notificación
        let contenido = UNMutableNotificationContent()
        contenido.title = "Invierte sin riesgo"
        contenido.body = "🔔 El mercado de recursos cierra en 15 minutos"
        contenido.sound = UNNotificationSound.default

        // Crear el calendario y la fecha actual
        let calendar = Calendar.current
        let now = Date()

        // Crear los componentes de la fecha objetivo en GMT
        var gmtComponents = calendar.dateComponents([.year, .month, .day], from: now)
        gmtComponents.hour = horaGMT
        gmtComponents.minute = minutoGMT

        // Obtener la zona horaria GMT
        guard let gmtTimeZone = TimeZone(abbreviation: "GMT"),
              let gmtDate = calendar.date(from: gmtComponents) else {
            print("Error al crear la fecha en GMT.")
            return
        }

        // Calcular la hora local desde GMT
        let localSeconds = TimeZone.current.secondsFromGMT(for: gmtDate)
        let gmtSeconds = gmtTimeZone.secondsFromGMT(for: gmtDate)
        let timeInterval = TimeInterval(localSeconds - gmtSeconds)
        let localDate = gmtDate.addingTimeInterval(timeInterval)

        // Extraer la hora y los minutos de la fecha local
        let localComponents = calendar.dateComponents([.hour, .minute], from: localDate)
        guard let localHour = localComponents.hour, let localMinute = localComponents.minute else {
            print("Error al convertir a la hora local.")
            return
        }

        // Configurar el trigger diario a la hora local
        var triggerComponents = DateComponents()
        triggerComponents.hour = localHour
        triggerComponents.minute = localMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)

        // Crear la solicitud de notificación
        let solicitud = UNNotificationRequest(identifier: "notificacionDiaria-\(horaGMT)-\(minutoGMT)", content: contenido, trigger: trigger)

        // Agregar la notificación al centro de notificaciones
        UNUserNotificationCenter.current().add(solicitud) { (error) in
            if let error = error {
                print("Error al programar la notificación: \(error.localizedDescription)")
            } else {
                print("Notificación programada para las \(horaGMT):\(minutoGMT) GMT (Hora local: \(localHour):\(localMinute)).")
            }
        }
    }
    
}
