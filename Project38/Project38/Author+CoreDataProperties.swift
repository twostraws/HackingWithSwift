//
//  Author+CoreDataProperties.swift
//  Project38
//
//  Created by Hudzilla on 28/01/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Author {
    @NSManaged var email: String
    @NSManaged var name: String
    @NSManaged var commits: NSSet
}
