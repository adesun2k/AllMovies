//
//  CoreDataManager.swift
//  AllMovies
//
//  Created by Seun Adeyemi on 16/12/2021.
//

import Foundation
import CoreData
import UIKit
class CoreDataManager {
  

  static let sharedManager = CoreDataManager()
  private init() {} // Prevent clients from creating another instance.

  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "AllMovies")
    
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  

  func saveContext () {
    let context = CoreDataManager.sharedManager.persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
    func insertMovie(_ title:String, _ year:String, _ imdbid:String, _ type_:String, _ poster:String)->Movies? {
        
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchUser: NSFetchRequest<Movies> = Movies.fetchRequest()
            fetchUser.predicate = NSPredicate(format: "imdbid = %@", imdbid)
       
         let results = try? managedContext.fetch(fetchUser)
        //ensure data is does not already exist to avoid duplicates.
         if results?.count == 0 {
             
        let entity = NSEntityDescription.entity(forEntityName: "Movies",in: managedContext)!
        
        
        /*
         Initializes a managed object and inserts it into the specified managed object context.
         */
        let movie = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        /*
         With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
         */
        movie.setValue(year, forKeyPath: "year")
        movie.setValue(type_, forKeyPath: "type")
        movie.setValue(title, forKeyPath: "title")
        movie.setValue(poster, forKeyPath: "poster")
        movie.setValue(imdbid, forKeyPath: "imdbid")
        movie.setValue(false, forKeyPath: "favourite")
        
    
        do {
          try managedContext.save()
          print("Could save \(imdbid)")
          return movie as? Movies
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
          return nil
        }
    }else{
        //already exist so ignore
        return nil
    }
      }
}
