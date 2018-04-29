//
//  CoreDataStack.swift
//  biquotes
//
//  Created by 1 on 13/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import CoreData

class CoreDataStack {
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "biquotes")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
