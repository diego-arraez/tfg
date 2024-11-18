//
//  ComprasView.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 12/11/24.
//

import SwiftUI

struct ComprasView: View {
    var body: some View {
        VStack {
            Image(systemName: "cart.badge.plus")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Compras")
        }
        .padding()
    }
}

#Preview {
    ComprasView()
}
