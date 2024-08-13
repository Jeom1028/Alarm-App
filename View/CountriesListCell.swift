//
//  CountriesListCell.swift
//  Alarm App
//
//  Created by t2023-m0102 on 8/14/24.
//

import Foundation
import UIKit
import SnapKit

class CountriesListCell: UITableViewCell {
  
  private let countryLabel: UILabel = {
    let label = UILabel()
    label.text = "City, Country"
    label.font = UIFont.systemFont(ofSize: 15)
    label.textColor = .black
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
    
    countryLabel.snp.makeConstraints {
      $0.leading.equalTo(contentView.snp.leading).offset(20)
      $0.centerY.equalTo(contentView)
    }
  }
}



