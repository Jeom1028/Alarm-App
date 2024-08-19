//
//  CountriesViewModel.swift
//  Alarm App
//
//  Created by t2023-m0102 on 8/14/24.
//

import Foundation

class CountriesListViewModel {
  var countriesList: [CountriesListModel] = []
  
  init() {
    setupCountriesList()
  }
  
  private func setupCountriesList() {
    let timeZones = TimeZone.knownTimeZoneIdentifiers
    
    for timeZone in timeZones {
      if timeZone.contains("/") {
        let components = timeZone.split(separator: "/")
        if components.count == 2 {
          let city = String(components[1])
          
          let countriesInfo = CountriesListModel(timeZone: timeZone)
          countriesList.append(countriesInfo)
        }
      }
    }
  }
}
