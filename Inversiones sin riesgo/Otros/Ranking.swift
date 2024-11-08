//
//  Ranking.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 21/10/24.
//

import SwiftUI

struct Ranking: View {
    var body: some View {
        VStack {
            Image(systemName: "list.star")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Ranking")
        }
        .padding()
    }
}

#Preview {
    Ranking()
}
