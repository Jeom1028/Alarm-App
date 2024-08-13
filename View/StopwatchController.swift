//
//  File.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import UIKit
import SnapKit

class StopwatchController: UIViewController {
    
  let timeLabel = {
    let label = UILabel()
    label.text = "00:00.00"
    label.font = UIFont.systemFont(ofSize: 60, weight: .bold)
    return label
  }()
  
  let startAndPauseButton = {
    let button = UIButton()
    button.setTitle("시작", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 30
    button.backgroundColor = .olveDrab.withAlphaComponent(0.7)
    return button
  }()
  
  let labAndResetButton = {
    let button = UIButton()
    button.setTitle("랩", for: .normal)
    button.layer.cornerRadius = 30
    button.backgroundColor = .black.withAlphaComponent(0.7)
    return button
  }()
  
  let buttonStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 150
    stackView.alignment = .fill
    return stackView
  }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
      configureUI()
    }
  
  
  func configureUI() {
    [timeLabel, buttonStackView].forEach {
      view.addSubview($0)
    }
    [labAndResetButton, startAndPauseButton].forEach {
      buttonStackView.addArrangedSubview($0)
    }
    
    timeLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(150)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(50)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(timeLabel.snp.bottom).offset(50)
      $0.centerX.equalToSuperview()
    }
    
    startAndPauseButton.snp.makeConstraints {
      $0.width.height.equalTo(60)
    }
    
    labAndResetButton.snp.makeConstraints {
      $0.width.height.equalTo(60)
    }
  }
}
