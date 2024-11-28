//
//  VentasDataModel.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 22/11/24.
//

import Foundation
import SwiftUI

struct VentasDataModel: Decodable {
    var idV: String
    var fechaCambioV: String
    var ofreceTipoV: String
    var ofreceUnidadV: String
    var pideTipoV: String
    var pideUnidadV: String
    var puntosV: String
    var usernameV: String
}

struct VentasResponseDataModel: Decodable {
    let ventas: [VentasDataModel]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ventas = try container.decode([VentasDataModel].self, forKey: .results)
    }
}

final class VentasViewModel: ObservableObject {
    
    @Published var ventas: [VentasDataModel] = []

    func getVentas(username: String) {
        

        let url = URL(string: "https://39730946.servicio-online.net/tfg/json_historial.php?u=\(username)&type=ventas")
        
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let _ = error {
                print("Error URL json_historial.php (ventas)")
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let ventasDataModel = try! JSONDecoder().decode(VentasResponseDataModel.self, from: data)
                DispatchQueue.main.async {
                    self.ventas = ventasDataModel.ventas
                    //print(self.ventas)
                }
            }
            
        }.resume()
    }
}

