//
//  Login.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 10/11/24.

import SwiftUI

struct Login: View {
    
    @EnvironmentObject var autenticacion: Autenticacion
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @StateObject var loginURLsession: LoginURLSession = LoginURLSession()
        
    @State private var showAlert = false
    @State private var mensajeAlert: String = ""
    
    @State private var usuario = UserDefaults.standard.object(forKey: "usuario")

    var body: some View {
    
            NavigationView {
                VStack {
                    Form {
                        
                        Spacer().listRowBackground(Color.clear)
                        
                         
                        
                        Section("Datos de acceso:"){
                            TextField("Usuario", text: $username)
                                .keyboardType(.default)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                            
                            SecureField("Contraseña", text: $password)
                                .keyboardType(.default)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                            
                        }
                        
                        Section(){
                            
                            Button("Entrar") {
                                if (username == "" || password == ""){
                                    showAlert = true
                                    mensajeAlert = "🚫 No puedes dejar un campo vacío"
                                } else if (username.count < 4) {
                                    showAlert = true
                                    mensajeAlert = "🚫 El nombre de usuario debe tener entre 3 y 16 caracteres"
                                } else if (password.count < 8) {
                                    showAlert = true
                                    mensajeAlert = "🚫 La contraseña debe tener entre 7 y 20 caracteres"
                                }
                                else {
                                    
                                    
                                    loginURLsession.getLogin(username: username, password: password) { respuesta in
                                        if respuesta == "UserOK" {
                                            autenticacion.login(username: username)
                                        } else {
                                            showAlert = true
                                            mensajeAlert = "⚠️ Usuario/contraseña incorrecta"
                                        }
                                    }
                                    
                                }
                                
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
                            }   .foregroundStyle(Color.white)
                                .font(.system(size: 22))
                                .font(.headline)
                                .background(Color.black)
                                .buttonStyle(.bordered)
                                .cornerRadius(6)
                                .buttonStyle(BorderlessButtonStyle())
                            
                        }.listRowBackground(Color.clear)
                            
                        
                        Section(footer: Text("Hecho por Diego Arráez - TFG (UOC)")){
                        }
                        
                        
                        
                        
                    }.onAppear { showAlert = false }
                        
                    
                    
                    
                }.navigationTitle("Inversiones sin riesgo")
                    .alert(mensajeAlert, isPresented: $showAlert) {} message: {Text("") }
                
                
                
                
            }
            
            
    
            
            
            
            
            
            
        
    
        
    }
}


