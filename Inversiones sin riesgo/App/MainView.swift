//
//  MainView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 21/10/24.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
         
        //if login {  //PENDIENTE HACER LOGIN/REGISTRO
            TabView {
                
                Ranking()
                    .tabItem {
                        Label("Ranking", systemImage: "list.star")
                    }
                                
                Recursos()
                    .tabItem {
                        Label("Recursos", systemImage: "chart.xyaxis.line")
                    }
                
                Premios()
                    .tabItem {
                        Label("Premios", systemImage: "trophy")
                    }
                    
                Cuenta()
                    .tabItem {
                        Label("Cuenta", systemImage: "person.crop.circle.badge.checkmark")
                    }
            }
        //} else {
        //    Login()
        //}
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
