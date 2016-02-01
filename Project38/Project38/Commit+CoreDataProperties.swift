//
//  Commit+CoreDataProperties.swift
//  Project38
//
//  Created by Hudzilla on 27/01/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Commit {
    @NSManaged var date: NSDate
    @NSManaged var message: String
    @NSManaged var sha: String
    @NSManaged var url: String
    @NSManaged var author: Author
}
