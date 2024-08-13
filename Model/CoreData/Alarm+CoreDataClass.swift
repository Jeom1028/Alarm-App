//
//  Alarm+CoreDataClass.swift
//  Alarm App
//
//  Created by 강유정 on 8/13/24.
//
//

import Foundation
import CoreData

@objc(Alarm)
public class Alarm: NSManagedObject {
    public static let className = "Alarm"
    public enum Key {
        static let id = "id"
        static let time = "time"
        static let sound = "sound"
    }
}
