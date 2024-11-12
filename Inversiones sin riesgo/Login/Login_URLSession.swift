//
//  Login_URLSession.swift
//  Inversiones sin riesgo
//
//  Created by Diego on 11/11/24.
//
import Foundation
import SwiftUI

struct LoginDataModel: Decodable {
    var respuesta: String
}

struct LoginResponseDataModel: Decodable {
    let logIn: [LoginDataModel]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.logIn = try container.decode([LoginDataModel].self, forKey: .results)
    }
}

final class LoginURLSession: ObservableObject {
    
    @Published var logIn: [LoginDataModel] = []
    
    func getLogin(username: String, password: String, completion: @escaping (String) -> Void) {
        
        let url = URL(string: "https://39730946.servicio-online.net/tfg/json_login.php?u=\(username)&p=\(password)")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let _ = error {
                print("Error URL json_login.php")
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let logInDataModel = try! JSONDecoder().decode(LoginResponseDataModel.self, from: data)
                DispatchQueue.main.async {
                    
                    self.logIn = logInDataModel.logIn
                    
                    for logInItem in self.logIn {
                            let respuesta = logInItem.respuesta
                            completion(respuesta)
                        }
                    
                    
                }
            }
            
        }.resume()
    }
}
