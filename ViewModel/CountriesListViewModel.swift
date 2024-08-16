//
//  CountriesViewModel.swift
//  Alarm App
//
//  Created by t2023-m0102 on 8/14/24.
//

import Foundation

class CountriesListViewModel {
  var countriesList: [CountriesListModel] = []
  let locale = Locale(identifier: "ko-KR")
  init() {
    setupCountriesList()
  }
  
  private func setupCountriesList() {
    let timeZones = TimeZone.knownTimeZoneIdentifiers
    for timeZone in timeZones {
      let timeZoneKr = TimeZone(identifier: timeZone)
      if timeZone.contains("/") {
        let countriesInfo = CountriesListModel(timeZone: timeZone)
        countriesList.append(countriesInfo)
      }
    }
  }
}
