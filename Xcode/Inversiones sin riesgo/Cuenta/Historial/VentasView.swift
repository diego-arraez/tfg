//
//  VentasView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 12/11/24.
//

import SwiftUI

struct VentasView: View {
    var body: some View {
        VStack {
            Image(systemName: "cart.badge.minus")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Ventas")
        }
        .padding()
    }
}

#Preview {
    VentasView()
}
