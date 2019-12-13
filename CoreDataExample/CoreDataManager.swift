//
//  CoreDataManager.swift
//  CoreDataExample
//
//  Created by Ravi Tripathi on 13/12/19.
//  Copyright © 2019 Ravi Tripathi. All rights reserved.
//

import UIKit
import CoreData



class CoreDataManager {
    
    static func save(data: DataModel) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let expense =
            NSEntityDescription.entity(forEntityName: "Expense",
                                       in: managedContext)!
        let dataUnit = NSManagedObject(entity: expense,
                                       insertInto: managedContext)
        dataUnit.setValue(data.amount, forKeyPath: "amount")
        dataUnit.setValue(data.billNumber, forKey: "billNumber")
        dataUnit.setValue(data.title, forKey: "title")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func getAllData() -> [DataModel]? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Expense")
        do {
            let items = try managedContext.fetch(fetchRequest)
            guard let jsonAnyObject = CoreDataManager.convertToJSONArray(moArray: items) else {
                return nil
            }
            let decoder = JSONDecoder()
            do {
                let people = try decoder.decode([DataModel].self, from: jsonAnyObject)
                return people
            } catch {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    static func convertToJSONArray(moArray: [NSManagedObject]) -> Data? {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return (try? JSONSerialization.data(withJSONObject: jsonArray))
    }
    
    
    func createExportString() -> String? {
        guard let data: [DataModel] = CoreDataManager.getAllData() else {
            return nil
        }
        var export: String = NSLocalizedString("Bill Number, Title, Amount \n", comment: "")
        for (index, item) in data.enumerated() {
            export += "\(index),\(item.title),\(item.amount) \n"
        }
        return export
    }
    
    func saveAndExport(exportString: String) {
        let exportFilePath = NSTemporaryDirectory() + "itemlist.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data, attributes: nil)
        //var fileHandleError: NSError? = nil
        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
        } catch {
            print("Error with fileHandle")
        }

        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)

            fileHandle!.closeFile()

            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)

            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo
            ]
        }
    }
}
