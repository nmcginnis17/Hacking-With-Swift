//
//  Commit+CoreDataClass.swift
//  GitHub Commits App
//
//  Created by Nicholas McGinnis on 1/22/23.
//
//

import Foundation
import CoreData

public class Commit: NSManagedObject {
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        print("Init called!")
    }
}
