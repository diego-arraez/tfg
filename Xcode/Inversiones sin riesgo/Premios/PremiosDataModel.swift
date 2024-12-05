//
//  PremiosDataModel.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 12/11/24.
//

import Foundation
import SwiftUI
import UIKit

//JSON LOCAL
struct PremiosMenuSection: Codable, Identifiable {
    var id: String
    var name: String
    var premios: [PremiosMenuItem]
}
struct PremiosMenuItem: Codable, Hashable, Identifiable {
    var id: String
    var descripcion: String
    var premioCobre: Int
    var premioPlata: Int
    var premioOro: Int
    var premioDiamante: Int
}

//JSON REMOTO
struct PremiosDataModel: Decodable {
    var premiosDisponibles: String
    var premiosCanjeados: String
}

struct PremiosResponseDataModel: Decodable {
    let premios: [PremiosDataModel]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.premios = try container.decode([PremiosDataModel].self, forKey: .results)
    }
}

final class PremiosViewModel: ObservableObject {
    
    @Published var premios: [PremiosDataModel] = []
    
    func getPremios(username: String, tipoPremio: String, premioCanjeado: String, completion: @escaping (String, String) -> Void) {
        
        let url = URL(string: "https://39730946.servicio-online.net/tfg/json_premios.php?u=\(username)&tp=\(tipoPremio)&pc=\(premioCanjeado)")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let _ = error {
                print("Error URL json_premios.php")
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let premiosDataModel = try! JSONDecoder().decode(PremiosResponseDataModel.self, from: data)
                DispatchQueue.main.async {
                    
                    self.premios = premiosDataModel.premios
                    
                    for premiosItem in self.premios {
                            let premiosDisp = premiosItem.premiosDisponibles
                            let premiosCanj = premiosItem.premiosCanjeados
                            completion(premiosDisp, premiosCanj)
                        }
                    
                    
                }
            }
            
        }.resume()
    }
}

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("No encuentor el fichero \(file)")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("No puedo cargar el contenido del fichero \(file)")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("No puedo hacer decode del fichero \(file)")
        }

        return loaded
    }
}
