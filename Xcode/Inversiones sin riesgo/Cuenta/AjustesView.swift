//
//  AjustesView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 13/11/24.
//

import SwiftUI
import AuthenticationServices

struct AjustesView: View {
        
    @State var usuario = UserDefaults.standard.string(forKey: "usuario")
    
    var body: some View {
        
        NavigationView {
            
            Form {
                List {
                    Section ("Ranking") {
                        //TOGGLE: Filtro de usuario en ranking
                        
                    }
                    
                    Section ("Mercado") {
                        //TOGGLE: Grafico de valores
						
						//TOGGLE: Notificaciones de mercado?
						
                        
                        
                    }
                    
                    Section() {
                        Button("Cerrar sesión") {
                            
                            
                        }.foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                        
                    }
                    
                    
                }
                    
                    
                
            }//Navigation
            
            
            
        }//VIEW
        
    }
        
}
