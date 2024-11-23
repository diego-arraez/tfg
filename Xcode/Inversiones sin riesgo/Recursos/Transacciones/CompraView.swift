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
    
    var body: some View {
        VStack {
            Image(systemName: "cart.badge.plus")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Compra")
        }
        .navigationTitle("Comprar \(selectedRecurso)")
        .padding()
    }
}

