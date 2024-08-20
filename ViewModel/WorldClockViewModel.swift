//
//  WorldClockViewModel.swift
//  Alarm App
//
//  Created by t2023-m0102 on 8/20/24.
//

import Foundation

class WorldClockViewModel {
  private(set) var selectedClocks: [WorldClockModel] = []
  
  func addClock(cityName: String, timeZone: String) {
    let worldClockModel = WorldClockModel(cityName: cityName, timeZone: timeZone)
    selectedClocks.append(worldClockModel)
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
}
