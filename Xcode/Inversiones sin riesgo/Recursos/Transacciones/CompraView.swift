//
//  CompraView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 23/11/24.
//

import SwiftUI

struct CompraView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AlmacenViewModel
    @State var selectedRecurso: String
    @State var precioPorUnidad: Int
    @State var recursosUser: Int
    @State var coinsUser: String
    @State var inputRecurso: String = "0"
    @State var inputCoins: String = ""
    @State var puntosTotales: Int
    
    @FocusState private var nameInFocus: Bool
    
    @State private var mostrarMensajeOK = false
    @State private var mostrarMensajeNOK = false
    
    @StateObject var compraViewModel: CompraViewModel = CompraViewModel()
    
    let colors: [String: [Color]] = [
        "cobre": [Color("cobre1"), Color("cobre2"), Color("cobre1"), Color("cobre2"), Color("cobre1")],
        "plata": [.gray, Color("plata"), .gray, Color("plata"), .gray],
        "oro": [.yellow, .brown, .yellow, .brown, .yellow],
        "diamante": [Color("diamante"), .blue, Color("diamante"), .blue, Color("diamante")],
        "moneda": [.yellow, .brown, .yellow, .brown, .yellow]
    ]

    @State private var hasExceededBalance = false
    @State private var botonDisabled = true
    @State private var botonLoading = false
    @State private var valorVacio = true

    var body: some View {
        VStack {
                ZStack {
                    Form {
                        // Sección de recursos y cantidad
                        Section("\(precioPorUnidad) coins = 1 \(selectedRecurso)") {
                            
                            // Sección de coins
                            HStack {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(spacing: 8) {
                                        Text("")
                                            .font(.caption)
                                            .fontWeight(.black)
                                            .frame(width: 20.0, height: 20.0)
                                            .padding(2)
                                            .background(
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
                                            .clipShape(RoundedRectangle(cornerRadius: 25))
                                            .foregroundColor(Color("numeroMoneda"))
                                        
                                        VStack(alignment: .leading) {
                                            Text("Coins")
                                            
                                            if Int(inputCoins) ?? 0 > 0 && !hasExceededBalance {
                                                Text("Tienes \(coinsUser) \(getCoinsInfo())")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            } else {
                                                Text("Tienes \(coinsUser)")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        Spacer()
                                        TextField("0", text: $inputCoins)
                                            .background(Color.clear)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: max(CGFloat(inputCoins.count * 15), 40)) // Ajuste de ancho dinámico
                                            .disabled(true)
                                            .font(.headline)
                                            .overlay(
                                                Text("-")
                                                    .foregroundColor(.gray)
                                                    .padding(.leading, 0),
                                                alignment: .leading
                                            )
                                        
                                            
                                        
                                    }
                                    .padding(.vertical, 0) // Reduced vertical padding
                                    
                                    HStack {
                                        Spacer()
                                        if hasExceededBalance {
                                            Text("⚠ excede el saldo")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(.top, 0) // Reduced top padding
                                }
                            }.listRowSeparator(.hidden)
                            .listRowBackground(hasExceededBalance ? Color.red.opacity(0.2) : Color("filas"))
                            
                            
                            HStack {
                                Spacer()
                                Image(systemName: "arrow.down.circle")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                    
                                Spacer()
                            }.padding(-10)
                                .listRowSeparator(.hidden)
                                .listRowBackground(hasExceededBalance ? Color.red.opacity(0.2) : Color("filas"))
                            
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(spacing: 8) {
                                    Text("")
                                        .font(.caption)
                                        .fontWeight(.black)
                                        .frame(width: 20.0, height: 20.0)
                                        .padding(2)
                                        .background(
                                            AngularGradient(
                                                colors: colors[selectedRecurso, default: [Color("filas"), Color("filas"), Color("filas"), Color("filas"), Color("filas")]],
                                                center: .center,
                                                startAngle: .degrees(90),
                                                endAngle: .degrees(360)
                                            )
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                        .foregroundColor(Color.white)
                                    
                                    VStack(alignment: .leading) {
                                        Text(selectedRecurso.capitalized)
                                        
                                        if Int(inputRecurso) ?? 0 > 0 && !hasExceededBalance {
                                            Text("Tienes \(recursosUser) \(getRecursoInfo())")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        } else {
                                            Text("Tienes \(recursosUser)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()
                                    TextField("0", text: $inputRecurso)
                                        .keyboardType(.numberPad)
                                        .font(.headline)
                                        .focused($nameInFocus)
                                        .background(Color.clear) // Removed border
                                        .multilineTextAlignment(.trailing)
                                        .textFieldStyle(PlainTextFieldStyle()) // Removed border style
                                        .frame(width: max(CGFloat(inputRecurso.count * 15), 40)) // Ajuste de ancho dinámico
                                        .onAppear {
                                            // Automatically focus the TextField
                                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                self.nameInFocus = true
                                            }
                                        }
                                        .onChange(of: inputRecurso) { newValue in
                                            // Remove leading zeroes and calculate coins
                                            let trimmedValue = newValue.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "^0+(?!$)", with: "", options: .regularExpression)
                                            let cantidad = Int(trimmedValue) ?? 0 // valor introducido
                                            inputRecurso = trimmedValue          // valor introducido
                                            let coins = cantidad * precioPorUnidad  // numero de recursos para comprar
                                            inputCoins = "\(coins)"          // coste total
                                            
                                            
                                            valorVacio = inputRecurso == "" || inputRecurso == "0"
                                            // Check if balance is exceeded
                                            botonDisabled = coins > (Int(coinsUser) ?? 0) || cantidad == 0 || coins == 0
                                            hasExceededBalance = coins > (Int(coinsUser) ?? 0)
                                        }
                                        .overlay(
                                            Text("+")
                                                .foregroundColor(.gray)
                                                .padding(.leading, 0),
                                            alignment: .leading
                                        )
                                    
                                    
                                    
                                    
                                    
                                        
                                    
                                }
                                .padding(.vertical, 0) // Reduced vertical padding
                                
                                HStack {
                                    Spacer()
                                    if Int(inputRecurso) ?? 0 > 0 {
                                        Text(getPointsInfo())
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text("-")
                                            .font(.caption)
                                            .foregroundColor(.clear)
                                    }
                                }
                                .padding(.top, 0) // Reduced top padding
                                
                               
                            }.listRowSeparator(.hidden)
                            .padding(.bottom, 0) // Reduced bottom padding to decrease space between sections
                            .listRowBackground(hasExceededBalance ? Color.red.opacity(0.2) : Color("filas"))
                            
                        }
                        
                    }
                    // Botón de confirmación
                    VStack{
                        Spacer()
                        HStack {
                            
                            if hasExceededBalance {
                                
                                //FUTURA IMPLEMENTACION POR SI SE QUIERE AÑADIR ALGUN BOTON PARA ALGUNA ACCION
                                //Button() {} label: {}
                                
                                
                            } else if !valorVacio && !botonLoading {
                                Button() {
                                    botonLoading = true
                                    compraViewModel.getCompra(gasto: inputCoins, tipo: selectedRecurso, incremento: inputRecurso)  { respuesta in
                                        
                                        if (respuesta == "OK") {
                                            realizarCompra(recurso: selectedRecurso)
                                            mostrarMensajeOK = true
                                            self.presentationMode.wrappedValue.dismiss()
                                        } else {
                                            mostrarMensajeNOK = true
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                
                                } label: {
                                    Label("Confirmar compra", systemImage: "hand.tap.fill")
                                        .foregroundStyle(Color.white)
                                        .padding()
                                        .background(Color.yellow)
                                        .cornerRadius(20)
                                        .shadow(radius: 3)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                
                            }
                            
                            if botonLoading {
                                Button() {
                                    
                                } label: {
                                    Label("Cargando...", systemImage: "gear")
                                        .foregroundStyle(Color(.gray))
                                        .padding()
                                        .background(Color(.clear))
                                        .cornerRadius(20)
                                        .shadow(radius: 0)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .disabled(true) // Disable button if balance is exceeded
                            }
                        }
                        
                    }.padding(.bottom)
                        .background(Color.clear)
                }
            }.navigationTitle("Comprar \(selectedRecurso)")
            .alert("👍 Compra realizada con éxito", isPresented: $mostrarMensajeOK) {
                Button("OK", action: {})
            } message: { Text("") }
            .alert("❌ Tu saldo es inferior al necesario", isPresented: $mostrarMensajeNOK) {
                Button("OK", action: {})
            } message: { Text("") }
        
    
        }
    
    func getPointsInfo () -> String {
        return "\(puntosTotales) → \(puntosTotales + (precioPorUnidad * (Int(inputRecurso) ?? 0))) puntos"
    }
    
    func getRecursoInfo () -> String {
        return " → \(recursosUser + (Int(inputRecurso) ?? 0))"
    }
    
    func getCoinsInfo () -> String {
        return " → \((Int(coinsUser) ?? 0) - (Int(inputCoins) ?? 0))"
    }
    
    func realizarCompra(recurso: String) {
        let ahora = Date()
        UserDefaults.standard.set(ahora, forKey: "ultimaTransaccion_\(recurso)")
    }
    
    
}
