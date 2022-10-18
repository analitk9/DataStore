//
//  CoreDataService.swift
//  Navigation
//
//  Created by Denis Evdokimov on 5/16/22.
//

import Foundation
import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "FavouritesDataModel", withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let storeName = "FavoutitesDataModel.sqlite"
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private let persistentContainer: NSPersistentContainer
    
    init() {
        
        let container = NSPersistentContainer(name: "FavouritesDatabaseModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        self.persistentContainer = container
    }
    
    func getFavouritesPosts()-> [Post] {
        var resultPost = [Post]()
        let fetchRequest = EntitiesPost.fetchRequest()
        do {
            let posts = try managedObjectContext.fetch(fetchRequest)
            for post in posts {
                if let title = post.title,
                   let author = post.author,
                   let description = post.descriptionPost,
                   let image = post.image{
                    
                    let newPost = Post(title: title,
                                       author: author,
                                       description: description,
                                       imageString: image,
                                       likes: Int(post.likes),
                                       views: Int(post.views))
                    resultPost.append(newPost)
                }
            }
        }catch let error {
            print(error)
        }
        return resultPost
    }
    
    func saveFavouritePost(_ post: Post){
       
        let favourites = getFavouritesPosts()
        guard  !favourites.contains(where: { fav in
            fav == post
        }) else {return}
        
        do {

            if let newFavourite = NSEntityDescription.insertNewObject(forEntityName: "EntitiesPost", into: managedObjectContext) as? EntitiesPost {
                newFavourite.views = Int16(post.views)
                newFavourite.likes = Int16(post.likes)
                newFavourite.author = post.author
                newFavourite.descriptionPost = post.description
                newFavourite.image = post.imageString
                newFavourite.title = post.title
                try managedObjectContext.save()
            } else {
                fatalError("Unable to insert LaunchStatus entity")
            }
        } catch let error {
            print(error)
        }
    }
}
