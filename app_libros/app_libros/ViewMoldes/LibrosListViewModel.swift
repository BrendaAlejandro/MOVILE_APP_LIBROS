import Foundation
import CoreData

class LibrosListViewModel: ObservableObject {
    @Published var libros: [Libros] = [] // Lista de libros
    @Published var favorites: [Libros] = [] // Lista de favoritos
    
    private var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    init() {
        loadFavorites() // Cargar favoritos al iniciar
    }
    
    // Función para obtener libros desde un servicio
    func getLibros(for genero: String) {
        DispatchQueue.main.async {
            LibrosService().getLibros(for: genero) { libros, message in
                if let libros = libros {
                    self.libros = libros
                } else if let message = message {
                    print("Error: \(message)")
                }
            }
        }
    }
    
    // Alternar el estado de favorito de un libro
    func toggleFavorite(libro: Libros) {
        if let index = libros.firstIndex(where: { $0.id == libro.id }) {
            libros[index].isFavorite.toggle()
            
            if libros[index].isFavorite {
                addFavorite(libro: libros[index])
            } else {
                removeFavorite(libro: libros[index])
            }
        }
    }
    
    // Agregar un libro a favoritos en Core Data
    func addFavorite(libro: Libros) {
        let newFavorite = Item(context: context)
        newFavorite.id = Int64(libro.id)
        newFavorite.autor = libro.autor
        newFavorite.title = libro.title
        newFavorite.descripcion = libro.descripcion
        newFavorite.ano = libro.ano
        newFavorite.genero = libro.genero
        newFavorite.imageUrl = libro.imageUrl
        
        favorites.append(libro)
        saveContext()
    }
    
    // Eliminar un libro de favoritos en Core Data
    func removeFavorite(libro: Libros) {
        if let index = favorites.firstIndex(where: { $0.id == libro.id }) {
            favorites.remove(at: index)
        }
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", libro.id)
        
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
    func loadFavorites() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            let savedItems = try context.fetch(fetchRequest)
            favorites = savedItems.map { item in
                Libros(
                    id: Int(item.id),
                    autor: item.autor ?? "",
                    title: item.title ?? "",
                    descripcion: item.descripcion ?? "",
                    ano: item.ano,
                    genero: item.genero ?? "",
                    imageUrl: item.imageUrl ?? "",
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
