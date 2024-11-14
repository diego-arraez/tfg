//
//  IsR.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 21/10/24.
//

import SwiftUI

@main
struct IsR: App {
    
    @StateObject private var autenticacion = Autenticacion()
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                if isLoading {
                    VStack(spacing: 20) {
                        Text("Invierte sin riesgo")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 40, design: .default))
                            .foregroundColor(Color("textoInicial"))
                            .shadow(color: Color.gray.opacity(90), radius: 4, x: 2, y: 6)
                        
                        Image("IsR")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                        
                        Text("© Diego Arráez\nTFG 2024-25 (UOC)")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 12, design: .default))
                            .foregroundColor(Color("grisOscuro"))
                            
                    }
                } else {
                    MainView()
                        .environmentObject(autenticacion)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
            }
        }
    }
}
