//
//  ArticleManager.swift
//  Pods
//
//  Created by Jimmy CHEN-MA on 10/11/18.
//

import Foundation
import CoreData

@available(iOS 10.0, *)
public class ArticleManager
{
    let context:NSManagedObjectContext
    
    public func newArticle(title:String, content:String, language:String, image:NSData?) -> Article
    {
        //Create a new article
//        guard let entity = NSEntityDescription.entity(forEntityName: "article", in: context)
//        else
//        {
//            fatalError("Could not find entity description")
//        }

        let doc = Date()
        let dom = Date()
        let art = Article(context: context)
        art.setValue(title, forKey: "title")
        art.setValue(content, forKey: "content")
        art.setValue(language, forKey: "language")
        art.setValue(doc, forKey: "dateOfCreation")
        art.setValue(dom, forKey: "dateOfModification")
        art.setValue(image, forKey: "image")
        return art
    }
    
    public func getAllArticles() -> [Article]
    {
        //return all the articles
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            if let results = try context.fetch(fetchRequest) as? [Article]
            {
                return results
            }
        }
        catch
        {
            print ("There was a fetch error!")
        }
        return []
    }
    
    public func getArticles(withLang lang : String)
    {
        //return all the articles with the language selected
    }
    
    public func getArticles(containString str : String)
    {
        //return all the articles with the string selected
    }
    
    public func removeArticle(article : Article)
    {
        //remove article selected
        context.delete(article)
    }
    
    public func save()
    {
        //save all modifications
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
    
    public init()
    {
        let myBundle = Bundle(for:Article.self)
        
        // Initialize NSManagedObjectModel
        let modelURL = myBundle.url(forResource: "article", withExtension: "momd")
        guard let model = NSManagedObjectModel(contentsOf: modelURL!) else { fatalError("model not found") }
        
        // Configure NSPersistentStoreCoordinator with an NSPersistentStore
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        let storeURL = try! FileManager
            .default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("article.sqlite")
        
        try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        
        // Create and return NSManagedObjectContext
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
    }
}
