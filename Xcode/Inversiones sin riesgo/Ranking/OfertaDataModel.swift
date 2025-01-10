//
//  OfertaDataModel.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 02/12/24.
//

import Foundation
import SwiftUI

struct OfertaDataModel: Decodable {
    var recurso: String
    var valor: String
    var puntos: String
    var puntosUser: String
}

struct OfertaResponseDataModel: Decodable {
    let oferta: [OfertaDataModel]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.oferta = try container.decode([OfertaDataModel].self, forKey: .results)
    }
}

final class OfertaViewModel: ObservableObject {
    
    @Published var oferta: [OfertaDataModel] = []
    
    func getOferta(completion: @escaping (String, String, String, String) -> Void) {
    
        let usuario = (UserDefaults.standard.string(forKey: "usuario") ?? "").replacingOccurrences(of: " ", with: "%%%")
        
        let url = URL(string: "https://39730946.servicio-online.net/tfg/json_oferta.php?u=\(usuario)")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let _ = error {
                print("Error URL json_oferta.php")
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let ofertaDataModel = try! JSONDecoder().decode(OfertaResponseDataModel.self, from: data)
                DispatchQueue.main.async {

                    self.oferta = ofertaDataModel.oferta
                    
                    for ofertaItem in self.oferta {
                        let valor = ofertaItem.valor
                        let recurso = ofertaItem.recurso
                        let puntos = ofertaItem.puntos
                        let puntosUser = ofertaItem.puntosUser
                        print(puntosUser)
                            completion(valor, recurso, puntos, puntosUser)
                        }
                }
            }
            
        }.resume()
    }
}

