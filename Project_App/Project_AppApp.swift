//
//  Project_AppApp.swift
//  Project_App
//
//  Created by DDDD on 09/02/2021.
//

import SwiftUI

@main
struct Project_AppApp: App {
    //making aaaa available everywhere
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController) //read coreData values
        }
    }
}
