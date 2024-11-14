//
//  RankingDataModel.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 12/11/24.
//

import Foundation
import SwiftUI

struct RankingDataModel: Decodable {
    var position: String
    var name: String
    var cobre: String
    var plata: String
    var oro: String
    var diamante: String
    var points: String
    var userid: String
}

struct RankingResponseDataModel: Decodable {
    let ranking: [RankingDataModel]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ranking = try container.decode([RankingDataModel].self, forKey: .results)
    }
}

final class RankingViewModel: ObservableObject {
    
    @Published var ranking: [RankingDataModel] = []
    
    func getRanking() {
    
        let usuario = UserDefaults.standard.string(forKey: "usuario") ?? ""
        
        let url = URL(string: "https://39730946.servicio-online.net/tfg/json_ranking.php?u=\(usuario)")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let _ = error {
                print("Error URL json_ranking.php")
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let rankingDataModel = try! JSONDecoder().decode(RankingResponseDataModel.self, from: data)
                DispatchQueue.main.async {
                    self.ranking = rankingDataModel.ranking
                }
            }
            
        }.resume()
    }
}
