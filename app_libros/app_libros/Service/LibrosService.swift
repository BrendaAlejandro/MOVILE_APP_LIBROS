//
//  ShoesService.swift
//  app_libros
//
//  Created by DAMII on 17/12/24.
//

import Foundation

class ShoesService {

    func getShoes(for gender: String, completion: @escaping ([GenderShoes]?, String?) -> Void) {
        let url = "https://sugary-wool-penguin.glitch.me/shoes?gender=\(gender.uppercased())"
        
        HttpRequestHelper().GET(url: url) { success, data, message in
            
            if success {
                guard let data = data else {
                    completion(nil, message ?? "Error: no data")
                    return
                }
                
                do {
                    let apiResponse = try JSONDecoder().decode([GenderShoes].self, from: data)
                    completion(apiResponse, nil)
                } catch let error {
                    completion(nil, "Error: \(error.localizedDescription)")
                }
            } else {
                completion(nil, message ?? "Error: no responde")
            }
        }
    }
}

