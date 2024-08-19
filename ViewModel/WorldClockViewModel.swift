//
//  WorldClockViewModel.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import Foundation

class WorldClockModalViewModel {
  private(set) var allCountriesList: [CountriesListModel] = []
  private(set) var filteredCountriesList: [CountriesListModel] = []
  
  init(countriesListViewModel: CountriesListViewModel) {
    self.allCountriesList = countriesListViewModel.countriesList
    self.filteredCountriesList = allCountriesList
  }
  
  func search(for text: String) {
    if text.isEmpty {
      filteredCountriesList = allCountriesList
    } else {
      filteredCountriesList = allCountriesList.filter { $0.timeZone.lowercased().contains(text.lowercased()) }
    }
  }
  
  func numberOfItems() -> Int {
    return filteredCountriesList.count
  }
  
  func item(at index: Int) -> CountriesListModel {
    return filteredCountriesList[index]
  }
}
