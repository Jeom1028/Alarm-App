//
//  CountriesViewModel.swift
//  Alarm App
//
//  Created by t2023-m0102 on 8/14/24.
//

import Foundation

class CountriesListViewModel {
<<<<<<< Updated upstream
  private var countriesList: [CountriesListModel] = []
  
=======
  var countriesList: [CountriesListModel] = []
  let locale = Locale(identifier: "ko-KR")
>>>>>>> Stashed changes
  init() {
    setupCountriesList()
  }
  
  private func setupCountriesList() {
    let timeZones = TimeZone.knownTimeZoneIdentifiers
<<<<<<< Updated upstream
    
    for timeZone in timeZones {
      let components = timeZone.split(separator: "/")
      if components.count == 2 {
        let countryName = Locale.current.localizedString(forRegionCode: String(components[0])) ?? "Unknown"
        let cityName = String(components[1])
        let countriesInfo = CountriesListModel(countryName: countryName, cityName: cityName)
=======
    for timeZone in timeZones {
      let timeZoneKr = TimeZone(identifier: timeZone)
      if timeZone.contains("/") {
        let countriesInfo = CountriesListModel(timeZone: timeZone)
>>>>>>> Stashed changes
        countriesList.append(countriesInfo)
      }
    }
  }
}
