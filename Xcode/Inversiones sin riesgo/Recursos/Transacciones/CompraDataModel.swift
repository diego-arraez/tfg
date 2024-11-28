//
//  CompraDataModel.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 24/11/24.
//

import Foundation
import SwiftUI

struct CompraDataModel: Decodable {
    var respuesta: String
}

struct CompraResponseDataModel: Decodable {
    let compra: [CompraDataModel]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.compra = try container.decode([CompraDataModel].self, forKey: .results)
    }
}

final class CompraViewModel: ObservableObject {
    
    @Published var compra: [CompraDataModel] = []
    
    func getCompra(gasto: String, tipo: String, incremento: String, completion: @escaping (String) -> Void) {
    
        let usuario = UserDefaults.standard.string(forKey: "usuario") ?? ""

        let url = URL(string: "https://39730946.servicio-online.net/tfg/json_compras.php?u=\(usuario)&coins=\(gasto)&tipo=\(tipo)&cantidad=\(incremento)")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let _ = error {
                print("Error URL json_comras.php")
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let compraDataModel = try! JSONDecoder().decode(CompraResponseDataModel.self, from: data)
                DispatchQueue.main.async {
                    
                    for compraItem in compraDataModel.compra {
                            let respuesta = compraItem.respuesta
                            completion(respuesta)
                        }
                }
            }
            
        }.resume()
    }
}
