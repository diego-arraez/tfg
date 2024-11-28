//
//  ComprasView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 12/11/24.
//

import SwiftUI

struct ComprasView: View {
    
    let colors: [String: [Color]] = ["cobre": [Color("cobre1"), Color("cobre2"), Color("cobre1"), Color("cobre2"), Color("cobre1")], "plata": [.gray, Color("plata"), .gray, Color("plata"), .gray], "oro": [.yellow, .brown, .yellow, .brown, .yellow], "diamante": [Color("diamante"), .blue, Color("diamante"), .blue, Color("diamante")],"moneda": [.yellow, .brown, .yellow, .brown, .yellow]]
    
    @StateObject var viewModelC: ComprasViewModel = ComprasViewModel()
    
    let usuario = UserDefaults.standard.string(forKey: "usuario")
    
    @State private var textoSinCompras = "Sin compras"

    @State private var mostrarLoading = true
    
    var body: some View {
        
        NavigationView {
            
            
                Form {
                    
                        
                    Section () {
                        
                        HStack {
                            Text("Comprado")
                            Spacer()
                            Text("Coste")
                        }
                        .listRowBackground(Color("filasTransp"))
                        .font(.headline)
                        //.padding(.horizontal)
                        
                        if mostrarLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        
                        ForEach(viewModelC.compras, id: \.idC) { compras in
                            VStack {
                                HStack{
                                    Text("")
                                    //CREADO PARA AUMENTAR EL TAMAÑO DE LA FILA
                                        .frame(width: 0.0, height: compras.idC == "0" ? 50.0 : 20.0)
                                    
                                    Text(Int(compras.pideUnidadC) ?? 0 == 0 ? "" : compras.pideUnidadC)
                                        .font(Int(compras.pideUnidadC) ?? 0 == 0 ? .system(size: 23) : .caption)
                                        .fontWeight(.black)
                                        .frame(width: Int(compras.pideUnidadC) ?? 0 == 0 ? 30.0 : 20.0, height: Int(compras.pideUnidadC) ?? 0 == 0 ? 30.0 : 20.0)
                                        .padding(Int(compras.pideUnidadC) ?? 0 == 0 ? 0 : 2)
                                        .background(compras.pideTipoC != "coins" ? AnyView (
                                            ZStack {
                                                AngularGradient(
                                                    colors: colors[compras.usernameC == "bank" && compras.pideUnidadC == "0" ? "-" : compras.pideTipoC, default: [Color("filas"), Color("filas"), Color("filas"), Color("filas"), Color("filas")]],
                                                    center: .center,
                                                    startAngle: .degrees(90),
                                                    endAngle: .degrees(360)
                                                )
                                                
                                            }) : AnyView (
                                                ZStack {
                                                    
                                                            AngularGradient(
                                                                gradient: Gradient(colors: colors["moneda", default: [Color.yellow, Color.orange]]),
                                                                center: .center,
                                                                startAngle: .degrees(0),
                                                                endAngle: .degrees(360)
                                                            )
                                                            .clipShape(RoundedRectangle(cornerRadius: 25))
                                                            
                                                            
                                                            RoundedRectangle(cornerRadius: 25)
                                                                .fill(
                                                                    AngularGradient(
                                                                        gradient: Gradient(colors: [Color.white, Color.gray, Color.white]),
                                                                        center: .center,
                                                                        startAngle: .degrees(0),
                                                                        endAngle: .degrees(360)
                                                                    )
                                                                )
                                                                .padding(3) // Padding para simular un borde
                                                    
                                            })
                                            
                                        )
                                        .clipShape(Int(compras.pideUnidadC) ?? 0 == 0 ? RoundedRectangle(cornerRadius: 0) : RoundedRectangle(cornerRadius: 25))
                                        .foregroundColor(compras.pideTipoC == "coins" ? Color("numeroMoneda") : Color.white)
                                    
                                Spacer()
                                    VStack {
                                        Text(compras.fechaCambioC)
                                            .foregroundColor(Color("grisClaro"))
                                        
                                        Text(compras.idC == "0" ? textoSinCompras : compras.pideTipoC == "coins" ? "-" : "\(compras.puntosC) puntos")
                                            .foregroundColor(compras.pideTipoC == "coins" ? Color(.clear) : Color.black)
                                    }
                                Spacer()
                                    Text(compras.ofreceTipoC == "inapp" ? "💵" : compras.ofreceUnidadC)
                                        .font(compras.ofreceTipoC == "inapp" ? .system(size: 27) : .caption)
                                        .fontWeight(.black)
                                        .frame(width: compras.ofreceTipoC == "inapp" ? 30.0 : 20.0, height: compras.ofreceTipoC == "inapp" ? 30.0 : 20.0)
                                        .padding(compras.ofreceTipoC == "inapp" ? 0 : 2)
                                        .background(compras.ofreceTipoC == "inapp" || compras.idC == "0" ? nil : AnyView(
                                            ZStack {
                                                
                                                AngularGradient(
                                                    gradient: Gradient(colors: colors["moneda", default: [Color.yellow, Color.orange]]),
                                                    center: .center,
                                                    startAngle: .degrees(0),
                                                    endAngle: .degrees(360)
                                                )
                                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                                
                                                
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(
                                                        AngularGradient(
                                                            gradient: Gradient(colors: [Color.white, Color.gray, Color.white]),
                                                            center: .center,
                                                            startAngle: .degrees(0),
                                                            endAngle: .degrees(360)
                                                        )
                                                    )
                                                    .padding(3) // Padding para simular un borde
                                            }
                                            )
                                        )
                                        .clipShape(compras.ofreceTipoC == "inapp" ? RoundedRectangle(cornerRadius: 0) : RoundedRectangle(cornerRadius: 25))
                                        .foregroundColor(Color("numeroMoneda"))
                                    
                                    Text("")
                                    //CREADO PARA AUMENTAR EL TAMAÑO DE LA FILA
                                        .frame(width: 0.0, height: 20.0)
                                }
                            }
                        }.onAppear { mostrarLoading = false }
                        
                        
                        
                    }
                        
                    }.onAppear {
                        viewModelC.getCompras(username: "\(usuario ?? "")")
                    }
                
            }
            
            
        }
    }

   
struct ComprasView_Previews: PreviewProvider {
    static var previews: some View {
        ComprasView()
    }
}

