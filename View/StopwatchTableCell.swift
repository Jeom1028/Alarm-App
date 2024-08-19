//
//  StopwatchTableViewCell.swift
//  Alarm App
//
//  Created by 김솔비 on 8/14/24.
//

import UIKit
import SnapKit

class StopwatchTableCell: UITableViewCell {
  
  let lapTagLabel = {
    let label = UILabel()
    label.text = "랩"
    label.textAlignment = .left
    label.font = UIFont.systemFont(ofSize: 15)
    return label
  }()
  
  let lapTimeLabel = {
    let label = UILabel()
    label.text = "00:00.00"
    label.textAlignment = .right
    label.font = UIFont.systemFont(ofSize: 15)
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("*T_T*")
  }
  
  func configureUI() {
    [lapTagLabel, lapTimeLabel].forEach {
      contentView.addSubview($0)
    }
    
    lapTagLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
    
    lapTimeLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalToSuperview()
    }
  }
}
