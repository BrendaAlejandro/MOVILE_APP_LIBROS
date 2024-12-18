//
//  Libros.swift
//  app_libros
//
//  Created by DAMII on 17/12/24.
//

import Foundation

struct Libros: Identifiable, Decodable {
    let id: Int
    let autor: String
    let title: String
    let descripcion: String
    let ano: Double
    let genero: String
    let imageUrl: String
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case autor = "autor"
        case title = "title"
        case descripcion = "descripcion"
        case ano = "ano"
        case genero = "genero"
        case imageUrl = "imageUrl"
    }
}
