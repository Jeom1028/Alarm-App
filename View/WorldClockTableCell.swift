//
//  WorldClockTalbeCell.swift
//  Alarm App
//
//  Created by t2023-m0102 on 8/13/24.
//

import Foundation
import SnapKit
import UIKit

class WorldClockTableCell: UITableViewCell {
  private let countryName: UILabel = {
    let label = UILabel()
    label.text = "서울"
    label.font = UIFont.systemFont(ofSize: 30)
    label.textColor = .black
    return label
  }()
  
  private let countryTime: UILabel = {
    let label = UILabel()
    label.text = "00:00"
    label.font = UIFont.systemFont(ofSize: 45)
    label.textColor = .black
    label.textAlignment = .right
    return label
  }()
  
  private let ampmLabel: UILabel = {
    let label = UILabel()
    label.text = "오전"
    label.font = UIFont.systemFont(ofSize: 20)
    label.textColor = .black
    return label
  }()
  
  private let differenceLabel: UILabel = {
    let label = UILabel()
    label.text = "오늘, +6시간"
    label.font = UIFont.systemFont(ofSize: 15)
    label.textColor = .black
    label.textAlignment = .left
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureCell() {
    contentView.addSubview(countryName)
    contentView.addSubview(countryTime)
    contentView.addSubview(ampmLabel)
    contentView.addSubview(differenceLabel)
    
    countryName.snp.makeConstraints {
      $0.leading.equalTo(contentView.snp.leading).offset(15)
      $0.bottom.equalTo(contentView.snp.bottom).inset(20)
    }
    
    countryTime.snp.makeConstraints {
      $0.trailing.equalTo(contentView.snp.trailing).offset(-15)
      $0.centerY.equalTo(contentView.snp.centerY)
    }
    
    ampmLabel.snp.makeConstraints {
      $0.trailing.equalTo(countryTime.snp.leading).offset(-10)
      $0.bottom.equalTo(contentView.snp.bottom).inset(30)
    }
    
    differenceLabel.snp.makeConstraints {
      $0.leading.equalTo(contentView.snp.leading).offset(15)
      $0.bottom.equalTo(countryName.snp.top).offset(0)
    }
  }
}
