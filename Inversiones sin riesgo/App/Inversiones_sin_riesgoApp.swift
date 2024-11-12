//
//  Inversiones_sin_riesgoApp.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 21/10/24.
//

import SwiftUI

@main
struct Inversiones_sin_riesgoApp: App {
    
    @StateObject private var autenticacion = Autenticacion()
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(autenticacion)
        }
    }
}
