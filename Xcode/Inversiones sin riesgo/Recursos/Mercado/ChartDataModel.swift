//
//  ChartDataModel.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 12/11/24.
//

import Foundation
import SwiftUI

struct ChartDataModel: Decodable {
    var id: String
    var tipo: String
    var valor: String
    var coins: String
    var fecha: String
}

struct ChartResponseDataModel: Decodable {
    let chart: [ChartDataModel]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chart = try container.decode([ChartDataModel].self, forKey: .results)
    }
}

final class ChartViewModel: ObservableObject {
    
    @Published var chart: [ChartDataModel] = []
    
    func getChart() {
    
        let usuario = UserDefaults.standard.string(forKey: "usuario") ?? ""

        let url = URL(string: "https://39730946.servicio-online.net/tfg/json_recursos.php?u=\(usuario)")
                
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let _ = error {
                print("Error URL json_recursos.php")
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let chartDataModel = try! JSONDecoder().decode(ChartResponseDataModel.self, from: data)
                DispatchQueue.main.async {
                    self.chart = chartDataModel.chart
                }
            }
            
        }.resume()
    }
}
