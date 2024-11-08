//
//  Recursos.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 21/10/24.
//

import SwiftUI

struct Recursos: View {
    var body: some View {
        VStack {
            Image(systemName: "chart.xyaxis.line")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Recursos")
        }
        .padding()
    }
}

#Preview {
    Recursos()
}
