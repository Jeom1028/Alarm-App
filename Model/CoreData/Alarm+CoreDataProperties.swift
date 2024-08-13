//
//  Alarm+CoreDataProperties.swift
//  Alarm App
//
//  Created by 강유정 on 8/13/24.
//
//

import Foundation
import CoreData


extension Alarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarm> {
        return NSFetchRequest<Alarm>(entityName: "Alarm")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var time: Date?
    @NSManaged public var sound: String?

}

extension Alarm : Identifiable {

}
