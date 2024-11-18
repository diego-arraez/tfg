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
    @State private var showUser: Bool = UserDefaults.standard.bool(forKey: "showUser")

    
    @State private var showAlertLogout = false
 
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
                        //TOGGLE: Grafico de valores
						
						//TOGGLE: Notificaciones de mercado?
						
                        
                        
                    }
                            Spacer()
                        
                    }.listRowBackground(Color("fondoLista"))
                        .listRowSeparator(.hidden)
                    
                    Section() {
                        Button("Cerrar sesión") {
                            showAlertLogout = true
                            
                        }.foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                        
                    }
                    
                    
		}
                
                .alert("¿Estás seguro?", isPresented: $showAlertLogout) {
                    
                    Button("Cancelar", role: .cancel) { }
                    Button("Cerrar sesión") { autenticacion.logout() }
                } message: { Text("") }
                    
                
            }//Navigation
            
            
            
        }//VIEW
        
    
        
func updateShowUser(_ value: Bool) {
    UserDefaults.standard.set(value, forKey: "showUser")
}
}
