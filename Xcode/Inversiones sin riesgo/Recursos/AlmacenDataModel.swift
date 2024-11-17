//
//  AlmacenDataModel.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 12/11/24.
//

import Foundation
import SwiftUI

struct AlmacenDataModel: Decodable {
    var cobre: String
    var plata: String
    var oro: String
    var diamante: String
    var points: String
    
}

struct AlmacenResponseDataModel: Decodable {
    let account: [AlmacenDataModel]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.account = try container.decode([AlmacenDataModel].self, forKey: .results)
    }
}

final class AlmacenViewModel: ObservableObject {
    
    
    
    @Published var account: [AlmacenDataModel] = []
    
    func getAlmacen(completion: @escaping (String) -> Void) {

        let usuario = UserDefaults.standard.string(forKey: "usuario") ?? ""

        let url = URL(string: "https://39730946.servicio-online.net/tfg/json_almacen.php?u=\(usuario)")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let _ = error {
                print("Error URL json_almacen.php")
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let accountDataModel = try! JSONDecoder().decode(AlmacenResponseDataModel.self, from: data)
                DispatchQueue.main.async {
                    self.account = accountDataModel.account
                    
                    for accountItem in self.account {
                        let respuesta = "\(accountItem.points)"
                            completion(respuesta)
                        }
                    
                }
                
            }
            
        }.resume()
    }
}
