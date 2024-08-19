//
//  Alarm+CoreDataClass.swift
//  Alarm App
//
//  Created by 강유정 on 8/14/24.
//
//

import Foundation
import CoreData

@objc(Alarm)
public class Alarm: NSManagedObject {
    public static let className = "Alarm"
    public enum Key {
        static let id = "id"
        static let hour = "hour"
        static let minute = "minute"
        static let ampm = "ampm"
        static let sound = "sound"
    }
}
