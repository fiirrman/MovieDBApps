//
//  CoreDataModel.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/18/21.
//

import Foundation
import CoreData
import UIKit

class CoreDataModel {
    
    static var vcError = UIViewController()
    static var object : [NSManagedObject] = []
    static var objectSingle : NSManagedObject?
    static var context : NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DBRepo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: CORE DATA OPERATION
    static func saveContext (vc : UIViewController){
        if context.hasChanges {
            do {
                try context.save()
                print("save sukses")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                callError(error: nserror, vc: vc)
            }
        }
    }
    
    static func loadContext(vc : UIViewController, entityName : String) -> Bool{
        // load data
        let fetchData = NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            object = try context.fetch(fetchData)
        } catch {
            let nserror = error as NSError
            callError(error: nserror, vc: vc)
            return false
        }
        return true
    }
    
    // MARK: CORE DATA CUSTOM
    static func saveEntityGenre(entityName : String, arrGenre : [ListMovieModel]){
        let entityInit = NSEntityDescription.entity(forEntityName: entityName, in: CoreDataModel.context)
        
        for i in 0 ..< arrGenre.count{
            let entityObject = NSManagedObject(entity: entityInit!, insertInto: CoreDataModel.context)
            entityObject.setValue(arrGenre[i].text, forKey: "name") //name
            entityObject.setValue(arrGenre[i].id, forKey: "id") //name
        }
        
        CoreDataModel.saveContext(vc: CoreDataModel.vcError)
    }
    
    static func saveMovieListByGenre(entityName : String, arrGenre : [MovieByGenreModel]){
        let entityInit = NSEntityDescription.entity(forEntityName: entityName, in: CoreDataModel.context)
        
        for i in 0 ..< arrGenre.count{
            let entityObject = NSManagedObject(entity: entityInit!, insertInto: CoreDataModel.context)
            entityObject.setValue(arrGenre[i].movieTitle, forKey: "movieTitle") //name
            entityObject.setValue(arrGenre[i].movieReleaseDate, forKey: "movieReleaseDate") //name
            entityObject.setValue(arrGenre[i].imageURL, forKey: "imageURL") //name
            entityObject.setValue(arrGenre[i].id, forKey: "id") //name
        }
        
        CoreDataModel.saveContext(vc: CoreDataModel.vcError)
    }
    
    static func saveMovieDetail(entityName : String, detailModel : DetailMovieModel, id : Int){
        let entityInit = NSEntityDescription.entity(forEntityName: entityName, in: CoreDataModel.context)
        
        let entityObject = NSManagedObject(entity: entityInit!, insertInto: CoreDataModel.context)
       
        var stringJoinGenre = ""
        if detailModel.arrGenre.count > 0{
            for i in 0 ..< detailModel.arrGenre.count{
                if(i + 1 == detailModel.arrGenre.count){
                    stringJoinGenre = stringJoinGenre + (detailModel.arrGenre[i].name)
                }else{
                    stringJoinGenre = stringJoinGenre + (detailModel.arrGenre[i].name) + ", "
                }
            }
        }
        entityObject.setValue(stringJoinGenre, forKey: "genres") //name
        entityObject.setValue(detailModel.original_title, forKey: "original_title") //name
        entityObject.setValue(detailModel.overview, forKey: "overview") //name
        entityObject.setValue(detailModel.poster_path, forKey: "poster_path") //name
        entityObject.setValue(id, forKey: "id") //name
        
        CoreDataModel.saveContext(vc: CoreDataModel.vcError)
    }
    
    static func loadDataWithEntityName(vc : UIViewController, entityName : String) -> Bool{
        if(CoreDataModel.loadContext(vc: vc, entityName: entityName)){
            if CoreDataModel.object.count == 0 {
                print("first loaded \(entityName)")
                return false
            }else{
                print("data \(entityName) exist, not load")
                return true
            }
        }
            
        return false
    }
    
    static func loadDataWithQueryAndEntityName(vc : UIViewController, entityName : String, predicate : NSPredicate) -> Bool{
        // load data
        let fetchData = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchData.predicate = predicate

        do {
            object = try context.fetch(fetchData)
            return true
        } catch {
            let nserror = error as NSError
            callError(error: nserror, vc: vc)
            return false
        }
    }
    
    static func deleteEntries(nameEntity : String) {
        do {
            let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: nameEntity)
            let request: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchData)
            try context.execute(request)
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func callError(error : NSError, vc : UIViewController){
        vc.showErrorAlert(errorMsg: "Unresolved error \(error), \(error.userInfo)", isAction: false, title: "", typeAlert: "")
    }
}
