//
//  VentaDataModel.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 24/11/24.
//

import Foundation
import SwiftUI

struct VentaDataModel: Decodable {
    var respuesta: String
}

struct VentaResponseDataModel: Decodable {
    let venta: [VentaDataModel]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.venta = try container.decode([VentaDataModel].self, forKey: .results)
    }
}

final class VentaViewModel: ObservableObject {
    
    @Published var venta: [VentaDataModel] = []
    
    func getVenta(gasto: String, tipo: String, incremento: String, completion: @escaping (String) -> Void) {
    
        let usuario = UserDefaults.standard.string(forKey: "usuario") ?? ""

        let url = URL(string: "https://39730946.servicio-online.net/tfg/json_ventas.php?u=\(usuario)&gasto=\(gasto)&tipo=\(tipo)&cantidad=\(incremento)")
                
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let _ = error {
                print("Error URL json_ventas.php")
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let ventaDataModel = try! JSONDecoder().decode(VentaResponseDataModel.self, from: data)
                DispatchQueue.main.async {
                    
                    for ventaItem in ventaDataModel.venta {
                            let respuesta = ventaItem.respuesta
                            completion(respuesta)
                        }
                }
            }
            
        }.resume()
    }
}
