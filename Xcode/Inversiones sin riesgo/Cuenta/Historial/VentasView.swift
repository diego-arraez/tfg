//
//  VentasView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 12/11/24.
//

import SwiftUI

struct VentasView: View {
    
    let colors: [String: [Color]] = ["cobre": [Color("cobre1"), Color("cobre2"), Color("cobre1"), Color("cobre2"), Color("cobre1")], "plata": [.gray, Color("plata"), .gray, Color("plata"), .gray], "oro": [.yellow, .brown, .yellow, .brown, .yellow], "diamante": [Color("diamante"), .blue, Color("diamante"), .blue, Color("diamante")],"moneda": [.yellow, .brown, .yellow, .brown, .yellow]]
    
    @StateObject var viewModelV: VentasViewModel = VentasViewModel()
    
    let usuario = UserDefaults.standard.string(forKey: "usuario")
    
    @State private var textoSinVentas = "Sin ventas"
    
    @State private var mostrarLoading = true
    
    var body: some View {
        
        NavigationView {
            
            
            Form {
                    Section () {
                    HStack {
                        Text("Vendido")
                        Spacer()
                        Text("Ganancia")
                    }
                    .listRowBackground(Color("filasTransp"))
                    .font(.headline)
                    //.padding(.horizontal)
                    
                    if mostrarLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    
                    ForEach(viewModelV.ventas, id: \.idV) { ventas in
                        VStack {
                            HStack{
                                Text("")
                                //CREADO PARA AUMENTAR EL TAMAÑO DE LA FILA
                                    .frame(width: 0.0, height: ventas.idV == "0" ? 50.0 : 20.0)
                                
                                Text(ventas.ofreceUnidadV)
                                    .font(.caption)
                                    .fontWeight(.black)
                                    .frame(width: Int(ventas.ofreceUnidadV) ?? 0 > 99 ? 30.0 : 20.0, height: 20.0)
                                    .padding(2)
                                    .background(
                                        AngularGradient(
                                            colors: colors[ventas.ofreceTipoV, default: [Color("filas"), Color("filas"), Color("filas"), Color("filas"), Color("filas")]],
                                            center: .center,
                                            startAngle: .degrees(90),
                                            endAngle: .degrees(360)
                                        )
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                    .foregroundColor(Color.white)
                                    .opacity(ventas.ofreceUnidadV == "" ? 0.0 : 1.0)
                                
                                Spacer()
                                
                                VStack {
                                    Text(ventas.fechaCambioV)
                                        .foregroundColor(Color("grisClaro"))
                                    
                                    Text(ventas.idV == "0" ? textoSinVentas : "\(ventas.puntosV) coins")
                                        .foregroundColor(Color.black)
                                }
                                
                                Spacer()
                                
                                Text(ventas.pideUnidadV)
                                .font(.caption)
                                .fontWeight(.black)
                                .frame(width: Int(ventas.pideUnidadV) ?? 0 > 99 ? 30.0 : 20.0, height: 20.0)
                                .padding(2)
                                .background(ventas.idV == "0" ? nil : AnyView(
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
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .foregroundColor(Color("numeroMoneda"))
                                
                                Text("")
                                //CREADO PARA AUMENTAR EL TAMAÑO DE LA FILA
                                    .frame(width: 0.0, height: 20.0)
                            }
                        }
                    }.onAppear { mostrarLoading = false }
                    
                }
                        
                    }.onAppear {
                        viewModelV.getVentas(username: "\(usuario ?? "")")
                    }
                
            }
            
            
        }
    }

   
struct VentasView_Previews: PreviewProvider {
    static var previews: some View {
        VentasView()
    }
}

