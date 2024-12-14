//
//  Autenticacion.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 08/11/24.
//
import Foundation
import Combine

class Autenticacion: ObservableObject {
    @Published var estaLogueado = false //por defecto, el usuario no esta logueado
    
    init() {
        estaLogueado = UserDefaults.standard.object(forKey: "usuario") != nil
    }
    
    func login(username: String) {
            UserDefaults.standard.set(username, forKey: "usuario")
            UserDefaults.standard.set(true, forKey: "bienvenida")
            UserDefaults.standard.set(true, forKey: "mensajeChart")
        
            UserDefaults.standard.synchronize()
        
        estaLogueado = true
    }
    
    func loginSinBienvenida(username: String) { //cuando no es un usuario nuevo
            UserDefaults.standard.set(username, forKey: "usuario")
            UserDefaults.standard.set(false, forKey: "bienvenida")
            UserDefaults.standard.set(true, forKey: "mensajeChart")
            
            UserDefaults.standard.synchronize()
        
        estaLogueado = true
    }
    
    func logout() {
            //AJUSTES
            UserDefaults.standard.removeObject(forKey: "usuario")
            UserDefaults.standard.removeObject(forKey: "showChart")
            UserDefaults.standard.removeObject(forKey: "showUser")
            UserDefaults.standard.removeObject(forKey: "mensajeChart")
        
            //MERCADO
            UserDefaults.standard.removeObject(forKey: "ultimaTransaccion_cobre")
            UserDefaults.standard.removeObject(forKey: "ultimaTransaccion_plata")
            UserDefaults.standard.removeObject(forKey: "ultimaTransaccion_oro")
            UserDefaults.standard.removeObject(forKey: "ultimaTransaccion_diamante")
        
            UserDefaults.standard.synchronize()
        
        estaLogueado = false
    }
}
