//
//  File.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import UIKit
import SnapKit

class StopwatchController: UIViewController, UITableViewDataSource, UITabBarDelegate {
  
  var timer: Timer?
  var timeInterval: TimeInterval = 0.0 //Double 타입의 초단위 시간(0.0)
  
  var currentTimeData: Double = 0.0 //현재 시간을 담아줄 변수
  var lastLapTimeData: Double = 0.0 //마지막 lap time data 변수
  
  var lapTimeData: [String] = [] //기록된 lap time data
  let tableView = UITableView()
  
  let timeLabel = {
    let label = UILabel()
    label.text = "00:00.00"
    label.font = UIFont.systemFont(ofSize: 65, weight: .bold)
    //    label.textAlignment = .center
    return label
  }()
  
  let startAndPauseButton = {
    let button = UIButton()
    button.setTitle("시작", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 40
    button.backgroundColor = .olveDrab.withAlphaComponent(0.7)
    return button
  }()
  
  let lapAndResetButton = {
    let button = UIButton()
    button.setTitle("랩", for: .normal)
    button.layer.cornerRadius = 40
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
    setupTableView()
    setupButtons()
    lapAndResetButton.isEnabled = false
  }
  
  func configureUI() {
    [timeLabel, buttonStackView, tableView].forEach {
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
      $0.top.equalTo(timeLabel.snp.bottom).offset(100)
      $0.centerX.equalToSuperview()
    }
    
    startAndPauseButton.snp.makeConstraints {
      $0.width.height.equalTo(80)
    }
    
    lapAndResetButton.snp.makeConstraints {
      $0.width.height.equalTo(80)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(buttonStackView.snp.bottom).offset(35)
      $0.left.right.bottom.equalToSuperview()
    }
  }
  
  func setupTableView() {
    tableView.dataSource = self
    tableView.register(StopwatchTableCell.self, forCellReuseIdentifier: "TableViewCell")
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lapTimeData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? StopwatchTableCell else {
      return UITableViewCell()
    }
    let lapNumber = lapTimeData.count - indexPath.row
    cell.lapTagLabel.text = "Lap \(lapNumber)"
    
    //lapTimeData.count-indexPath.row-1 는 배열의 마지막 요소에서부터 차례대로 접근하기 위함(테이블뷰가 역순이므로 동일한 순서로 가져와야 오류가 발생하지 않는다)
    cell.lapTimeLabel.text = lapTimeData[lapTimeData.count-indexPath.row-1]

    return cell
  }
  
  func setupButtons() {
    startAndPauseButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
    lapAndResetButton.addTarget(self, action: #selector(lapTimer), for: .touchUpInside)
  }
  
  @objc
  func startTimer() {
    if timer == nil {
      startAndPauseButton.setTitle("중단", for: .normal)
      startAndPauseButton.backgroundColor = .red.withAlphaComponent(0.7)
      timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true) //0.01초 단위로 updateTimer 반복(repeats)
      lapAndResetButton.isEnabled = true
      lapAndResetButton.setTitle("랩", for: .normal)
      lapAndResetButton.backgroundColor = .black.withAlphaComponent(0.7)
    } else {
      startAndPauseButton.setTitle("시작", for: .normal)
      startAndPauseButton.backgroundColor = .olveDrab.withAlphaComponent(0.7)
      timer?.invalidate() //타이머 중단 메서드
      timer = nil
      lapAndResetButton.setTitle("재설정", for: .normal)
    }
  }
  
  @objc
  func updateTimer() {
    timeInterval += 0.01
    timeLabel.text = doubleToTimeString(timeInterval) //Double 타입의 time을 String으로 변환하여 텍스트 노출
    
    if let current = timeStringToDouble(timeLabel.text ?? "00:00.00") {
      currentTimeData = current //다시 Double로 변환하여 lapTime 계산에 필요한 변수에 저장
    }
  }
  
  @objc
  func lapTimer() {
    if timer != nil {
      let lapTime = currentTimeData - lastLapTimeData
      let StringLapTime = doubleToTimeString(lapTime) //Double 타입의 time을 String으로 변환하여 텍스트 노출
      lapTimeData.append(StringLapTime)
      lastLapTimeData = currentTimeData
      print(lapTimeData)
      tableView.reloadData()
    } else {
      lapAndResetButton.setTitle("랩", for: .normal)
      lapAndResetButton.backgroundColor = .systemGray2
      resetData()
    }
  }
  
  func resetData() {
    lapAndResetButton.isEnabled = false
    lapTimeData.removeAll()
    timeInterval = 0.0
    lastLapTimeData = 0.0
    currentTimeData = 0.0
    timeLabel.text = "00:00.00"
    tableView.reloadData()
  }
  
  func timeStringToDouble(_ timeString: String) -> Double? {
    let components = timeString.split(separator: ":").map { String($0) }
    guard components.count == 2,
          let minutes = Double(components[0]),
          let secondsAndMilliseconds = components.last?.split(separator: "."),
          secondsAndMilliseconds.count == 2,
          let seconds = Double(secondsAndMilliseconds[0]),
          let milliseconds = Double(secondsAndMilliseconds[1]) else {
      return nil
    }
    
    let totalSeconds = (minutes * 60) + seconds + (milliseconds / 100.0)
    return totalSeconds
  }
  
  func doubleToTimeString(_ timeInterval: Double) -> String {
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
    
    let timeString = String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    return timeString
  }
}
