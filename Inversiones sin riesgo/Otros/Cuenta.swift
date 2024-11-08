//
//  Cuenta.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 21/10/24.
//

import SwiftUI

struct Cuenta: View {
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.badge.checkmark")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Cuenta")
        }
        .padding()
    }
}

#Preview {
    Cuenta()
}
