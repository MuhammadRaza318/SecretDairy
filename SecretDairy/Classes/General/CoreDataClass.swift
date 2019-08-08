//
//  CoreDataClass.swift
//  FakeText
//
//  Created by Muhammad Luqman on 12/14/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataClass  {
    
    class func insertPageInDataBase(entityName:String, pageID:String, pageDate:String, pageTitle:String, pageText:String )-> Bool{
        
        let managedContext = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        object.setValue(pageID, forKeyPath: "pageID")
        object.setValue(pageDate, forKeyPath: "pageDate")
        object.setValue(pageTitle, forKeyPath: "pageTitle")
        object.setValue(pageText, forKeyPath: "pageText")
        
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    class func GetLengthOfRecord(entityName:String, pageDate: String) -> Int {
        
        var arrayForResult: [NSManagedObject] = []
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "pageDate == %@",pageDate)
        do {
            arrayForResult = try managedContext.fetch(fetchRequest)
            print(arrayForResult .count)
            if(arrayForResult.count>0){
                return arrayForResult.count
            }else{
                return 0
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return 0
        }
    }
    
    class func retriveDairyAllPage(entityName:String, pageDate: String) -> [NSManagedObject] {
        
        var arrayForResult: [NSManagedObject] = []
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "pageDate == %@",pageDate)
        do {
            arrayForResult = try managedContext.fetch(fetchRequest)
            print(arrayForResult .count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return arrayForResult
    }
    
    class func updateRecordFormDataBase(entityName:String , pageID:String, pageText:String)-> Bool {
        
        var arrayForResult: [NSManagedObject] = []
        let managedContext = getContext()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "pageID == %@",pageID)
        do {
            
            arrayForResult = try managedContext.fetch(fetchRequest)
            print(arrayForResult .count)
            
            if(arrayForResult.count>0){
                let object =  arrayForResult[0]
                object.setValue(pageText, forKeyPath: "pageText")
                try managedContext.save()
                print("Update")
                return true
            }else{
                
                print("Not Update")
                return false
            }
        } catch let error as NSError {
            print("Could not Delete. \(error), \(error.userInfo)")
            return false
        }
    }
    
    class func DeleteRecordFormDataBase(entityName:String, pageID:String ) -> Bool {
        
        var arrayForResult: [NSManagedObject] = []
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "pageID == %@",pageID)
        
        do {
            arrayForResult = try managedContext.fetch(fetchRequest)
            print(arrayForResult .count)
            if(arrayForResult.count>0){
                for object in arrayForResult {
                    managedContext.delete(object)
                    print("Delete Record")
                }
                return true
            }else{
                print(" Not Delete Record")
                return false
            }
        } catch let error as NSError {
            print("Could not Delete. \(error), \(error.userInfo)")
            return false
        }
    }
    
    
    class func searchDataFromDatabase(entityName:String , text:String) -> [NSManagedObject] {
        
        var arrayForResult: [NSManagedObject] = []
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "pageText CONTAINS[cd] %@",text)
        
        let sortDescriptor = NSSortDescriptor(key: "pageDate", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare))
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            arrayForResult = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return arrayForResult
    }
    
    
    
    class func insertSoundInDataBase(entityName:String, soundID:String, soundPath:URL, soundDate:String)-> Bool{
        
        let managedContext = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        object.setValue(soundID, forKeyPath: "soundID")
        object.setValue(soundPath, forKeyPath: "soundPath")
        object.setValue(soundDate, forKeyPath: "soundDate")
        
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    class func GetRecordOfSoundRecord(entityName:String, soundDate: String) ->  [NSManagedObject]  {
        
        var arrayForResult: [NSManagedObject] = []
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "soundDate == %@",soundDate)
        do {
            arrayForResult = try managedContext.fetch(fetchRequest)
            print(arrayForResult .count)
            if(arrayForResult.count>0){
                return arrayForResult
            }else{
                return arrayForResult
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return arrayForResult
        }
    }
    
    class func DeleteSoundFileRecordFormDataBase(entityName:String, soundDate:String ) -> Bool {
        
        var arrayForResult: [NSManagedObject] = []
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "soundDate == %@",soundDate)
        
        do {
            arrayForResult = try managedContext.fetch(fetchRequest)
            print(arrayForResult .count)
            if(arrayForResult.count>0){
                for object in arrayForResult {
                    managedContext.delete(object)
                    print("Delete Record")
                }
                return true
            }else{
                print(" Not Delete Record")
                return false
            }
        } catch let error as NSError {
            print("Could not Delete. \(error), \(error.userInfo)")
            return false
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    class func insertImageInDataBase(entityName:String, imageID:String, imagePath:URL, imageDate:String)-> Bool{
        
        let managedContext = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        object.setValue(imageID, forKeyPath: "imageID")
        object.setValue(imagePath, forKeyPath: "imagePath")
        object.setValue(imageDate, forKeyPath: "imageDate")
        
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    
    
    class func GetAllImageFromRecord(entityName:String, imageDate: String) ->  [NSManagedObject]  {
        
        var arrayForResult: [NSManagedObject] = []
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "imageDate == %@",imageDate)
        do {
            arrayForResult = try managedContext.fetch(fetchRequest)
            print(arrayForResult .count)
            if(arrayForResult.count>0){
                return arrayForResult
            }else{
                return arrayForResult
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return arrayForResult
        }
    }
    
    
    class func DeleteImageFileRecordFormDataBase(entityName:String, imagePath:URL ) -> Bool {
        
        var arrayForResult: [NSManagedObject] = []
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "imagePath == %@",imagePath as CVarArg)
        
        do {
            arrayForResult = try managedContext.fetch(fetchRequest)
            print(arrayForResult .count)
            if(arrayForResult.count>0){
                for object in arrayForResult {
                    managedContext.delete(object)
                    print("Delete Record")
                }
                return true
            }else{
                print(" Not Delete Record")
                return false
            }
        } catch let error as NSError {
            print("Could not Delete. \(error), \(error.userInfo)")
            return false
        }
    }
    
    
    
    
    class func insertAddCountDataBase(entityName:String, pageDate:String, addCounter:Int )-> Bool{
        
        let managedContext = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        object.setValue(pageDate, forKeyPath: "pageDate")
        object.setValue(addCounter, forKeyPath: "addCounter")
        
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    class func updateAddCounterInDataBase(entityName:String , pageDate:String, addCounter:Int)-> Bool {
        
        var arrayForResult: [NSManagedObject] = []
        let managedContext = getContext()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "pageDate == %@",pageDate)
        do {
            
            arrayForResult = try managedContext.fetch(fetchRequest)
            print(arrayForResult .count)
            
            if(arrayForResult.count>0){
                let object =  arrayForResult[0]
                object.setValue(addCounter, forKeyPath: "addCounter")
                try managedContext.save()
                print("Update")
                return true
            }else{
                
                print("Not Update")
                return false
            }
        } catch let error as NSError {
            print("Could not Delete. \(error), \(error.userInfo)")
            return false
        }
    }
    
    class func returnAddCounter(entityName:String, pageDate: String) -> Int {
        
        var arrayForResult: [NSManagedObject] = []
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "pageDate == %@",pageDate)
        do {
            arrayForResult = try managedContext.fetch(fetchRequest)
            print(arrayForResult .count)
            let  object = arrayForResult[0]
            let count = (object.value(forKeyPath: "addCounter") as? Int)
            return count!
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return 0
        }
    }
    
    
    
    /*
     -(void)eventRetriveAllRecordForDataBase{
     
     NSString *eventtitle = textForSearch;
     
     NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
     [fetchRequest setEntity:entity];
     
     fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(eventTitle CONTAINS[cd] %@)",eventtitle];
     NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"currentDate" ascending:YES];
     NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
     [fetchRequest setSortDescriptors:sortDescriptors];
     
     NSError *error = nil;
     NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
     
     if (![managedObjectContext save:&error]) {
     
     [self event:results];
     [self retriveAllRecord];
     
     NSLog(@" %@ %@", error, [error localizedDescription]);
     }else{
     
     [self event:results];
     [self retriveAllRecord];
     
     }
     }
     
     
     
     */
    
    
    
    //
    //    class func insertMessageInDataBase(entityName:String, groupID:String, messageID:String, messageTitle:String, messageText:String, messageTime:String, messageType:String )-> Bool{
    //
    //        let managedContext = getContext()
    //
    //        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
    //        let object = NSManagedObject(entity: entity, insertInto: managedContext)
    //        object.setValue(groupID, forKeyPath: "groupID")
    //        object.setValue(messageID, forKeyPath: "messageID")
    //        object.setValue(messageTitle, forKeyPath: "messageTitle")
    //        object.setValue(messageText, forKeyPath: "messageText")
    //        object.setValue(messageTime, forKeyPath: "messageTime")
    //        object.setValue(messageType, forKeyPath: "messageType")
    //
    //        do {
    //            try managedContext.save()
    //            return true
    //
    //        } catch let error as NSError {
    //
    //            print("Could not save. \(error), \(error.userInfo)")
    //            return false
    //        }
    //    }
    //
    //    class func retriveOneGroupMessage(entityName:String, groupID: String) -> [NSManagedObject] {
    //
    //        var arrayForResult: [NSManagedObject] = []
    //        let managedContext = getContext()
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    //        fetchRequest.predicate = NSPredicate(format: "groupID == %@",groupID)
    //
    //        do {
    //            arrayForResult = try managedContext.fetch(fetchRequest)
    //            print(arrayForResult .count)
    //        } catch let error as NSError {
    //            print("Could not fetch. \(error), \(error.userInfo)")
    //        }
    //        return arrayForResult
    //    }
    //
    //
    //    class func updateRecordFormDataBase(entityName:String , messageID:String, messageTitle:String, messageText:String, messageTime:String, messageType:String )-> Bool {
    //
    //        var arrayForResult: [NSManagedObject] = []
    //        let managedContext = getContext()
    //
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    //        fetchRequest.predicate = NSPredicate(format: "messageID == %@",messageID)
    //        do {
    //
    //            arrayForResult = try managedContext.fetch(fetchRequest)
    //            print(arrayForResult .count)
    //
    //            if(arrayForResult.count>0){
    //
    //                let object =  arrayForResult[0]
    //                object.setValue(messageTitle, forKeyPath: "messageTitle")
    //                object.setValue(messageText, forKeyPath: "messageText")
    //                object.setValue(messageTime, forKeyPath: "messageTime")
    //                object.setValue(messageType, forKeyPath: "messageType")
    //                try managedContext.save()
    //                print("Update")
    //                return true
    //
    //            }else{
    //
    //                print("Not Update")
    //                return false
    //            }
    //        } catch let error as NSError {
    //            print("Could not Delete. \(error), \(error.userInfo)")
    //            return false
    //        }
    //    }
    //
    //    class func DeleteRecordFormDataBase(entityName:String,ID:String , viewName:String) -> Bool {
    //
    //        var arrayForResult: [NSManagedObject] = []
    //        let managedContext = getContext()
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    //
    //        if viewName == "main" {
    //            fetchRequest.predicate = NSPredicate(format: "groupID == %@",ID)
    //        }else{
    //            fetchRequest.predicate = NSPredicate(format: "messageID == %@",ID)
    //        }
    //
    //        do {
    //            arrayForResult = try managedContext.fetch(fetchRequest)
    //            print(arrayForResult .count)
    //            if(arrayForResult.count>0){
    //                for object in arrayForResult {
    //                    managedContext.delete(object)
    //                    print("Delete Record")
    //                }
    //                return true
    //            }else{
    //                print(" NOt Delete Record")
    //                return false
    //            }
    //        } catch let error as NSError {
    //            print("Could not Delete. \(error), \(error.userInfo)")
    //            return false
    //        }
    //    }
    //
    //
    
    
    // MARK: Get Context
    class func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}
