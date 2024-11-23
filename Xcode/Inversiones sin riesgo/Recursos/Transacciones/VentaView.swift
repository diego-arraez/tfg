//
//  VentaView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 23/11/24.
//

import SwiftUI

struct VentaView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AlmacenViewModel
    @State var selectedRecurso: String
    @State var precioPorUnidad: Int
    @State var recursosUser: Int
    @State var coinsUser: String
    @State var inputRecurso: String = "0"
    @State var inputCoins: String = ""
    @State var puntosTotales: Int
    
    var body: some View {
        VStack {
            Image(systemName: "cart.badge.minus")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Venta")
        }
        .navigationTitle("Vender \(selectedRecurso)")
        .padding()
    }
}

