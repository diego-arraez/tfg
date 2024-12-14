//
//  MainView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 21/10/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var autenticacion: Autenticacion
    let bienvenida = UserDefaults.standard.bool(forKey: "bienvenida")
    @State private var selectedTab: Int = 0 //por defecto, Ranking
    
    var body: some View {
         
        if autenticacion.estaLogueado {
            TabView(selection: $selectedTab) {
                
                RankingView()
                    .tabItem {
                        Label("Ranking", systemImage: "list.star")
                    }.tag(0)
                                
                ChartView()
                    .tabItem {
                        Label("Mercado", systemImage: "chart.xyaxis.line")
                    }.tag(1)
                
                PremiosView()
                    .tabItem {
                        Label("Premios", systemImage: "trophy")
                    }.badge(bienvenida ? "1" : nil)
                    .tag(2)
                    
                CuentaView()
                    .tabItem {
                        Label("Cuenta", systemImage: "person.crop.circle.badge.checkmark")
                    }.tag(3)
            }.onAppear {
                selectedTab = bienvenida ? 2 : 0 //si bienvenida es true, se abre Premios
            }
        } else {
            Login()
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
