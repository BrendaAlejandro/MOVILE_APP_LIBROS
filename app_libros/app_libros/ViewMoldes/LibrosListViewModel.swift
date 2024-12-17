//
//  ShoesListViewModel.swift
//  app_libros
//
//  Created by DAMII on 17/12/24.
//

import Foundation
import CoreData

class ShoesListViewModel: ObservableObject {
    @Published var shoes: [GenderShoes] = [] // Lista de zapatos
    @Published var favorites: [GenderShoes] = [] // Lista de favoritos
    
    private var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    init() {
        loadFavorites() // Cargar favoritos al iniciar
    }
    
    func getShoes(for gender: String) {
        DispatchQueue.main.async {
            ShoesService().getShoes(for: gender) { shoes, message in
                if let shoes = shoes {
                    self.shoes = shoes
                } else if let message = message {
                    print("Error: \(message)")
                }
            }
        }
    }
    
    func toggleFavorite(shoe: GenderShoes) {
        if let index = shoes.firstIndex(where: { $0.id == shoe.id }) {
            shoes[index].isFavorite.toggle()
            
            if shoes[index].isFavorite {
                addFavorite(shoe: shoes[index])
            } else {
                removeFavorite(shoe: shoes[index])
            }
        }
    }
    
    // Agregar un zapato a favoritos en Core Data
    private func addFavorite(shoe: GenderShoes) {
        let newFavorite = Item(context: context)
        newFavorite.id = Int64(shoe.id)
        newFavorite.name = shoe.name
        newFavorite.brand = shoe.brand
        newFavorite.gender = shoe.gender
        newFavorite.category = shoe.category
        newFavorite.price = Int64(shoe.price)
        newFavorite.image = shoe.image
        
        favorites.append(shoe)
        saveContext()
    }
    
    // Eliminar un zapato de favoritos en Core Data
    func removeFavorite(shoe: GenderShoes) {
        if let index = favorites.firstIndex(where: { $0.id == shoe.id }) {
            favorites.remove(at: index)
        }
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", shoe.id)
        
        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                context.delete(item)
            }
            saveContext()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
    
    // Cargar los favoritos desde Core Data
    private func loadFavorites() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            let savedItems = try context.fetch(fetchRequest)
            favorites = savedItems.map { item in
                GenderShoes(
                    id: Int(item.id),
                    name: item.name ?? "",
                    brand: item.brand ?? "",
                    gender: item.gender ?? "",
                    category: item.category ?? "",
                    price: Int32(item.price),
                    image: item.image ?? "",
                    isFavorite: true
                )
            }
        } catch {
            print("Error loading favorites: \(error)")
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print("Error saving context: \(error)")
            }
        }
    }
}

