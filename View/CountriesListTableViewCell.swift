//
//  CountriesListCell.swift
//  Alarm App
//
//  Created by t2023-m0102 on 8/14/24.
//

import Foundation
import UIKit
import SnapKit

class CountriesListTableViewCell: UITableViewCell {
  
  private let countryLabel: UILabel = {
    let label = UILabel()
    label.text = "Country"
    label.font = UIFont.systemFont(ofSize: 15)
    label.textColor = .black
    return label
  }()
  
  private let cityLabel: UILabel = {
    let label = UILabel()
    label.text = "City"
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    contentView.addSubview(countryLabel)
    contentView.addSubview(cityLabel)
    
    countryLabel.snp.makeConstraints {
      $0.leading.equalTo(contentView.snp.leading).offset(20)
      $0.centerY.equalTo(contentView)
    }
    
    cityLabel.snp.makeConstraints {
      $0.leading.equalTo(countryLabel.snp.trailing).offset(10)
      $0.centerY.equalTo(contentView)
    }
  }
  
  func inputData(with info: CountriesListModel) {
    countryLabel.text = info.countryName
    cityLabel.text = info.cityName
  }
}



