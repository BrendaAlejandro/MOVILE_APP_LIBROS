//
//  app_librosApp.swift
//  app_libros
//
//  Created by DAMII on 17/12/24.
//

import SwiftUI
import CoreData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct applibrosApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var viewModel = LibrosListViewModel() // Usar @StateObject

    var body: some Scene {
        WindowGroup {
            LibrosListView()
                .environmentObject(viewModel) // Pasar el viewModel
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

