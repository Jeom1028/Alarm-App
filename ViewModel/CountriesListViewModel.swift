//
//  CountriesViewModel.swift
//  Alarm App
//
//  Created by t2023-m0102 on 8/14/24.
//

import Foundation

class CountriesListViewModel {
  private var countriesList: [CountriesListModel] = []
  
  init() {
    setupCountriesList()
  }
  
  private func setupCountriesList() {
    let timeZones = TimeZone.knownTimeZoneIdentifiers
    
    for timeZone in timeZones {
      let components = timeZone.split(separator: "/")
      if components.count == 2 {
        let countryName = Locale.current.localizedString(forRegionCode: String(components[0])) ?? "Unknown"
        let cityName = String(components[1])
        let countriesInfo = CountriesListModel(countryName: countryName, cityName: cityName)
        countriesList.append(countriesInfo)
      }
    }
  }
}
