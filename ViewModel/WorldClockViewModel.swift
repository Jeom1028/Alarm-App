//
//  WorldClockViewModel.swift
//  Alarm App
//
//  Created by t2023-m0102 on 8/20/24.
//

import Foundation
import UIKit
import CoreData

class WorldClockViewModel {
  private(set) var selectedClocks: [WorldClockModel] = []
  
  init() {
    loadClocksFromCoreData()
  }
  
  func addClock(cityName: String, timeZone: String) {
    let worldClockModel = WorldClockModel(cityName: cityName, timeZone: timeZone)
    selectedClocks.append(worldClockModel)
    saveClockToCoreData(cityName: cityName, timeZone: timeZone)
  }
  
  func numberOfItems() -> Int {
    return selectedClocks.count
  }
  
  func clock(at index: Int) -> WorldClockModel {
    return selectedClocks[index]
  }
  
  func calculateCurrentTime(for model: WorldClockModel) -> String {
    let timeZone = TimeZone(identifier: model.timeZone) ?? TimeZone.current
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm"
    dateFormatter.timeZone = timeZone
    return dateFormatter.string(from: Date())
  }
  
  func calculateAMPM(for model: WorldClockModel) -> String {
    let timeZone = TimeZone(identifier: model.timeZone) ?? TimeZone.current
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "a"
    dateFormatter.timeZone = timeZone
    let ampm = dateFormatter.string(from: Date())
    return ampm == "AM" ? "오전" : "오후"
  }
  
  func calculateTimeDifference(for model: WorldClockModel) -> String {
    let timeZone = TimeZone(identifier: model.timeZone) ?? TimeZone.current
    let offset = timeZone.secondsFromGMT() / 3600
    let currentOffset = TimeZone.current.secondsFromGMT() / 3600
    let difference = offset - currentOffset
    return "\(difference >= 0 ? "+" : "")\(difference)시간"
  }
  
  private func saveClockToCoreData(cityName: String, timeZone: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: "WorldClock", in: managedContext)!
    let worldClock = NSManagedObject(entity: entity, insertInto: managedContext)
    
    worldClock.setValue(cityName, forKey: WorldClock.Key.cityName)
    worldClock.setValue(timeZone, forKey: WorldClock.Key.timeZone)
    
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
  
  private func loadClocksFromCoreData() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WorldClock")
    
    do {
      let worldClocks = try managedContext.fetch(fetchRequest)
      for worldClock in worldClocks {
        let cityName = worldClock.value(forKey: WorldClock.Key.cityName) as? String ?? ""
        let timeZone = worldClock.value(forKey: WorldClock.Key.timeZone) as? String ?? ""
        let worldClockModel = WorldClockModel(cityName: cityName, timeZone: timeZone)
        selectedClocks.append(worldClockModel)
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }
  func removeClock(at index: Int) {
    let clock = selectedClocks[index]
    selectedClocks.remove(at: index)
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WorldClock")
    fetchRequest.predicate = NSPredicate(format: "cityName == %@ AND timeZone == %@", clock.cityName, clock.timeZone)
    
    do {
      let results = try context.fetch(fetchRequest)
      for result in results {
        context.delete(result)
      }
      try context.save()
    } catch {
      print("Could not delete. \(error)")
    }
  }
}
