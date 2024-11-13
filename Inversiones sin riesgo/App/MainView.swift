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
    
    var body: some View {
         
        if autenticacion.estaLogueado { 
            TabView {
                
                RankingView()
                    .tabItem {
                        Label("Ranking", systemImage: "list.star")
                    }
                                
                ChartView()
                    .tabItem {
                        Label("Mercado", systemImage: "chart.xyaxis.line")
                    }
                
                PremiosView()
                    .tabItem {
                        Label("Premios", systemImage: "trophy")
                    }.badge(bienvenida ? "1" : nil)
                    
                CuentaView()
                    .tabItem {
                        Label("Cuenta", systemImage: "person.crop.circle.badge.checkmark")
                    }
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
