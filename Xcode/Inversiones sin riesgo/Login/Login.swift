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
                        
                        HStack{
                            Spacer()
                            Image("IsR")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 115)
                                .background(.clear)
                            Spacer()
                        } .listRowBackground(Color.clear)
                            .padding(.top, -18)
                        
                        Section("Datos de acceso:"){
                            TextField("Nombre de tu empresa ficticia", text: $username)
                                .keyboardType(.default)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                            
                            SecureField("Contraseña", text: $password)
                                .keyboardType(.default)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                            
                        }
                        
                        
                        Section(footer: Text("\(Image(systemName: "gamecontroller.fill")) Recuerda, esto es solo un juego diseñado para aprender y divertirte. No utilizarás dinero real ni asumirás riesgos financieros. Disfruta la experiencia sin preocupaciones y aprovecha para explorar estrategias de inversión en un entorno completamente seguro.")){
                            
                        }.listRowBackground(Color.clear)
                        
                        
                        
                        
                        Section(){
                                                        
                            Button() {
                                if (username == "" || password == ""){
                                    showAlert = true
                                    mensajeAlert = "🚫 No puedes dejar un campo vacío"
                                } else if (username.count < 4) {
                                    showAlert = true
                                    mensajeAlert = "🚫 El nombre de empresa debe tener más de 4 carácteres"
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
                                            mensajeAlert = "⚠️ Empresa/contraseña incorrecta"
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
                            
                        
                        Section(footer: Text("© Diego Arráez\nTFG 2024-25 (UOC)")){
                        }
                        
                        
                        
                        
                    }.onAppear { showAlert = false }
                        
                    
                    
                    
                }.navigationTitle("Invierte sin riesgo 🤑")
                    .alert(mensajeAlert, isPresented: $showAlert) {
                        Button("OK", action: { mostrarLoading = false })}
                        message: {Text("") }
                
                
                
                
            }
            
            
    
            
            
            
            
            
            
        
    
        
    }
}


