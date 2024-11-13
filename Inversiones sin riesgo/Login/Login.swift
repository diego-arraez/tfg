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
    
    @StateObject var logInViewModel: LogInViewModel = LogInViewModel()
        
    @State private var mostrarLoading = false
    @State private var showAlert = false
    @State private var mensajeAlert: String = ""
    

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
                                                        
                            Button() {
                                if (username == "" || password == ""){
                                    showAlert = true
                                    mensajeAlert = "🚫 No puedes dejar un campo vacío"
                                } else if (username.count < 4) {
                                    showAlert = true
                                    mensajeAlert = "🚫 El nombre de usuario debe tener más de 4 carácteres"
                                } else if (password.count < 4) {
                                    showAlert = true
                                    mensajeAlert = "🚫 La contraseña debe tener más de 4 carácteres"
                                }
                                else {
                                    
                                    mostrarLoading = true
                                    
                                    logInViewModel.getLogIn(username: username, password: password) { respuesta in
                                        if respuesta == "LoginOK" {
                                            autenticacion.login(username: username)
                                        } else if respuesta == "LoginOK-A" {
                                            autenticacion.loginSinBienvenida(username: username)
                                        } else if respuesta == "LoginNOOK" {
                                            showAlert = true
                                            mensajeAlert = "⚠️ Contraseña incorrecta"
                                        } else {
                                            showAlert = true
                                            mensajeAlert = "⚠️ Usuario/contraseña incorrecta"
                                        }
                                    mostrarLoading = false
                                    }
                                    
                                }
                                
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
                            } label: {
                                
                                mostrarLoading ? Label("Comprobando...", systemImage: "gear") : Label("Entrar", systemImage: "touchid")
                                
                            } .foregroundStyle(Color.white)
                                .font(.system(size: 22))
                                .font(.headline)
                                .background(mostrarLoading ? Color.gray : Color.black)
                                .buttonStyle(.bordered)
                                .cornerRadius(6)
                                .buttonStyle(BorderlessButtonStyle())
                            
                            
                            
                        }.listRowBackground(Color.clear)
                            
                        
                        Section(footer: Text("Hecho por Diego Arráez - TFG (UOC)")){
                        }
                        
                        
                        
                        
                    }.onAppear { showAlert = false }
                        
                    
                    
                    
                }.navigationTitle("Inversiones sin riesgo")
                    .alert(mensajeAlert, isPresented: $showAlert) {
                        Button("OK", action: { mostrarLoading = false })}
                        message: {Text("") }
                
                
                
                
            }
            
            
    
            
            
            
            
            
            
        
    
        
    }
}


