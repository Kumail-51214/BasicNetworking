//
//  coreDataViewModel.swift
//  BasicNetworking
//
//  Created by Muhammad Kumail on 8/9/24.
//

import Foundation
import CoreData

class CoreDataViewModel {
    
    var products: [DataModel] = []
    
    func fetchProductData(sucess: @escaping() -> Void) {
        let context = PersistentStorage.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductsArray")
        products.removeAll()
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            
            for result in fetchedResults {
                let id = result.value(forKey: "id") as? Int ?? 0
                let name = result.value(forKey: "title") as? String ?? ""
                
                let product = DataModel(id: id, title: name, discountPercentage: 0.0, rating: 0.0, brand: "", category: "", thumbnail: "", images: [""])
                products.append(product)
            }
            print("model from Coredata: \(products)")
            sucess()
//            return products
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
//            return nil
        }
    }
    
    func deleteReportFromCoreData(id: Int64) {
        let context = PersistentStorage.shared.context
        
        // Create a fetch request for the Report entity with a specific ID
        let fetchRequest: NSFetchRequest<ProductsArray> = ProductsArray.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            // Fetch the object you want to delete
            if let objectToDelete = try context.fetch(fetchRequest).first {
                context.delete(objectToDelete) // Delete the object from Core Data
                try context.save() // Save the context to persist the deletion
                print("Successfully deleted report with ID: \(id) from Core Data.")
            } else {
                print("No report found with ID: \(id) in Core Data.")
            }
        } catch let error as NSError {
            print("Could not delete the entry. \(error), \(error.userInfo)")
        }
    }
    
    func updateDataInCoreData( id: Int64, with newValues: [String: Any]) {
        let context = PersistentStorage.shared.context
        
        // Create a fetch request for the Report entity with a specific ID
        let fetchRequest: NSFetchRequest<ProductsArray> = ProductsArray.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            // Fetch the object you want to update
            if let objectToUpdate = try context.fetch(fetchRequest).first {
                // Update the object's properties with the new values
                for (key, value) in newValues {
                    objectToUpdate.setValue(value, forKey: key)
                }
                try context.save()
                print("Successfully updated report with ID: \(id) in Core Data.")
            } else {
                print("No report found with ID: \(id) in Core Data.")
            }
        } catch let error as NSError {
            print("Could not update the entry. \(error), \(error.userInfo)")
        }
    }
    
    func saveToCoreData(data: DataModel) {
        let context = PersistentStorage.shared.context
        
        let entity = NSEntityDescription.entity(forEntityName: "ProductsArray", in: context)!
        let productObject = NSManagedObject(entity: entity, insertInto: context)
        
        productObject.setValue(data.id, forKey: "id")
        productObject.setValue(data.title, forKey: "title")
        productObject.setValue(data.description, forKey: "productDescription")
        productObject.setValue(data.stock, forKey: "stock")
        productObject.setValue(data.price, forKey: "price")
        productObject.setValue("images", forKey: "images")
        productObject.setValue(data.brand, forKey: "brand")
        productObject.setValue(data.category, forKey: "category")
        productObject.setValue(data.rating, forKey: "rating")
        productObject.setValue(data.discountPercentage, forKey: "discountPercentage")
        productObject.setValue(data.thumbnail, forKey: "thumbnail")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func deleteAllProductsData() {
        let context = PersistentStorage.shared.context
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ProductsArray")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Successfully deleted all data from ProductsArray.")
        } catch let error as NSError {
            print("Could not delete data. \(error), \(error.userInfo)")
        }
    }

}

