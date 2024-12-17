//
//  app_librosApp.swift
//  app_libros
//
//  Created by DAMII on 17/12/24.
//

import SwiftUI
import CoreData

@main
struct app_librosApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var viewModel = ShoesListViewModel() // Usar @StateObject

    var body: some Scene {
        WindowGroup {
            ShoeListView()
                .environmentObject(viewModel) // Pasar el viewModel
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

