//
//  ShoesService.swift
//  app_libros
//
//  Created by DAMII on 17/12/24.
//

import Foundation

class LibrosService {

    func getLibros(for libro: String, completion: @escaping ([Libros]?, String?) -> Void) {
        let url = "https://rest-ai-app-default-rtdb.firebaseio.com/libros"
        
        HttpRequestHelper().GET(url: url) { success, data, message in
            
            if success {
                guard let data = data else {
                    completion(nil, message ?? "Error: no data")
                    return
                }
                
                do {
                    let apiResponse = try JSONDecoder().decode([Libros].self, from: data)
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

