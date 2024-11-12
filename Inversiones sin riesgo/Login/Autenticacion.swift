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
        estaLogueado = true
        UserDefaults.standard.set(username, forKey: "usuario")
        UserDefaults.standard.synchronize()
    }
    
    func logout() {
        estaLogueado = false
        UserDefaults.standard.removeObject(forKey: "usuario")
        UserDefaults.standard.synchronize()
    }
}
