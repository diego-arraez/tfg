//
//  Premios.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 21/10/24.
//

import SwiftUI

struct Premios: View {
    var body: some View {
        VStack {
            Image(systemName: "trophy")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Premios")
        }
        .padding()
    }
}

#Preview {
    Premios()
}
