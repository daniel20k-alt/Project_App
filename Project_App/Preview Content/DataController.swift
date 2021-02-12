//
//  DataController.swift
//  Project_App
//
//  Created by DDDD on 11/02/2021.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer //loading and managing local core data instances
    
    init(inMemory: Bool = false) { //writing to RAM not disk
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "dev/null") //gets destroyed when app exists since its written nowhere
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal erro creating preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    
    func createSampleData() throws {
        let viewContext = container.viewContext //data loaded from disk
        
        for i in 1...5 {
            let project = Project(context: viewContext) //the viewContext in which project and item exists in
            project.title = "Project \(i)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()
            
            for j in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(j)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.project = project
                item.priority = Int16.random(in: 1...3)
                
            }
        }
        
        try viewContext.save()
    }
    
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save() //only save if changes occur
        }
    }
    
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
        
    }
}
