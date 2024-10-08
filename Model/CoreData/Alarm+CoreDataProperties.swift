//
//  Alarm+CoreDataProperties.swift
//  Alarm App
//
//  Created by 강유정 on 8/14/24.
//
//

import Foundation
import CoreData


extension Alarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarm> {
        return NSFetchRequest<Alarm>(entityName: "Alarm")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var minute: Int16
    @NSManaged public var sound: String?
    @NSManaged public var hour: Int16
    @NSManaged public var ampm: String?
    @NSManaged public var isActive: Bool

}
extension WorldClock {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<WorldClock> {
    return NSFetchRequest<WorldClock>(entityName: "WorldClock")
  }
  
  @NSManaged public var cityName: String?
  @NSManaged public var timeZone: String?
}

extension Alarm : Identifiable {

}

extension WorldClock : Identifiable {
  
}
