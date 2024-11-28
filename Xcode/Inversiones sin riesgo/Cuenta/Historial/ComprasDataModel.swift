//
//  ComprasDataModel.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 22/11/24.
//

import Foundation
import SwiftUI

struct ComprasDataModel: Decodable {
    var idC: String
    var fechaCambioC: String
    var ofreceTipoC: String
    var ofreceUnidadC: String
    var pideTipoC: String
    var pideUnidadC: String
    var puntosC: String
    var usernameC: String
}

struct ComprasResponseDataModel: Decodable {
    let compras: [ComprasDataModel]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.compras = try container.decode([ComprasDataModel].self, forKey: .results)
    }
}

final class ComprasViewModel: ObservableObject {
    
    @Published var compras: [ComprasDataModel] = []

    func getCompras(username: String) {
        

        let url = URL(string: "https://39730946.servicio-online.net/tfg/json_historial.php?u=\(username)&type=compras")
        
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let _ = error {
                print("Error URL json_historial.php (compras)")
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let comprasDataModel = try! JSONDecoder().decode(ComprasResponseDataModel.self, from: data)
                DispatchQueue.main.async {
                    self.compras = comprasDataModel.compras
                    //print(self.compras)
                }
            }
            
        }.resume()
    }
}

