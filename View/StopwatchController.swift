//
//  File.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import UIKit
import SnapKit

class StopwatchController: UIViewController {
  
  var timer: Timer?
  var timeInterval: TimeInterval = 0.0 //Double 타입의 초단위 시간(0.0)
  
  let tabelView = UITableView()
  
  let timeLabel = {
    let label = UILabel()
    label.text = "00: 00. 00"
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
  
  let lapAndResetButton = {
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
    setupButtons()
  }
  
  
  func configureUI() {
    [timeLabel, buttonStackView].forEach {
      view.addSubview($0)
    }
    [lapAndResetButton, startAndPauseButton].forEach {
      buttonStackView.addArrangedSubview($0)
    }
    
    timeLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(150)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(50)
      $0.width.equalTo(300)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(timeLabel.snp.bottom).offset(50)
      $0.centerX.equalToSuperview()
    }
    
    startAndPauseButton.snp.makeConstraints {
      $0.width.height.equalTo(60)
    }
    
    lapAndResetButton.snp.makeConstraints {
      $0.width.height.equalTo(60)
    }
  }
  
  func setupButtons() {
    startAndPauseButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
    //    lapAndResetButton.addTarget(self, action: #selector(<#T##@objc method#>), for: .touchUpInside)
  }
  
  @objc
  func startTimer() {
    if timer == nil {
      startAndPauseButton.setTitle("중단", for: .normal)
      timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true) //0.01초 단위로 updateTimer 반복(repeats)
    } else {
      startAndPauseButton.setTitle("시작", for: .normal)
      timer?.invalidate() //타이머 중단 메서드
      timer = nil
    }
  }
  
  @objc
  func updateTimer() {
    timeInterval += 0.01
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100) //경과시간 소수점 추출 후 밀리초단위로 계산
    timeLabel.text = String(format: "%02d: %02d. %02d", minutes, seconds, milliseconds) //계산된 시간 포맷팅(두자릿수로 변환하여 출력)
  }
}
