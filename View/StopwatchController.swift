//
//  File.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import UIKit
import SnapKit

class StopwatchController: UIViewController, UITableViewDataSource, UITabBarDelegate {
  
  var timer: DispatchSourceTimer?
  var timeInterval: TimeInterval = 0.0 //Double 타입의 초단위 시간(0.0)
  
  var currentTimeData: Double = 0.0 //현재 시간을 담아줄 변수
  var lastLapTimeData: Double = 0.0 //마지막 lap time data 변수
  
  var lapTimeData: [String] = [] //기록된 lap time data
  let tableView = UITableView()
  
  var backgroundTask: UIBackgroundTaskIdentifier = .invalid
  
  let timeLabel = {
    let label = UILabel()
    label.text = "00:00.00"
//    label.font = UIFont.systemFont(ofSize: 65, weight: .bold)
    label.font = UIFont.monospacedDigitSystemFont(ofSize: 65, weight: UIFont.Weight.bold)
    label.textAlignment = .center

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
    
    //백그라운드 상태를 감지하기 위한 NotificationCenter 설정
    NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
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
    
    //테이블뷰가 역순으로 표시되므로 lapTimeData 배열의 끝에서부터 값을 가져옴
    let lapTime = lapTimeData[lapTimeData.count - indexPath.row - 1]
    cell.lapTimeLabel.text = lapTime
    
    //lapTimeData 배열에서 가장 작은 값과 큰 값에 포인트
    if let minLapTime = lapTimeData.min(), let maxLapTime = lapTimeData.max() {
      if lapTime == minLapTime {
        cell.lapTimeLabel.textColor = .red
      } else if lapTime == maxLapTime {
        cell.lapTimeLabel.textColor = .blue
      } else {
        cell.lapTimeLabel.textColor = .black
      }
    }
    
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
  
      timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global()) //백그라운드 스레드에서 타이머 실행(UI가 아니므로)
      timer?.schedule(deadline: .now(), repeating: 0.01) //타이머 시작시간과 반복되는 주기 설정(즉시 시작 및 0.01초마다 반복)
      
      timer?.setEventHandler(handler: { [weak self] in //이벤트 핸들러
        guard let self = self else { return }
        
        self.timeInterval += 0.01
        
        //timeLabel 업데이트는 UI 작업이므로 메인 스레드에서 실행
        DispatchQueue.main.async {
          self.timeLabel.text = self.doubleToTimeString(self.timeInterval)
        
        if let current = self.timeStringToDouble(self.timeLabel.text ?? "00:00.00") {
          self.currentTimeData = current
        }
        }
      })
      timer?.resume() //타이머 호출 필수!
      
      lapAndResetButton.isEnabled = true //랩 버튼 활성화
      lapAndResetButton.setTitle("랩", for: .normal)
      lapAndResetButton.backgroundColor = .black.withAlphaComponent(0.7)
      
      startBackgroundTask() //백그라운드 시작
    } else {
      startAndPauseButton.setTitle("시작", for: .normal)
      startAndPauseButton.backgroundColor = .olveDrab.withAlphaComponent(0.7)
      
      timer?.cancel() //타이머 중단 메서드
      timer = nil
      
      lapAndResetButton.setTitle("재설정", for: .normal)
      
      endBackgroundTask() //백그라운드 종료
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
  
  @objc
  func appDidEnterBackground() {
    if timer != nil {
      startBackgroundTask()
    }
  }
  
  @objc
  func appWillEnterForeground() {
    endBackgroundTask()
  }
  
  func startBackgroundTask() {
    if backgroundTask == .invalid {
      backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
        self?.endBackgroundTask()
      }
    }
  }
  
  func endBackgroundTask() {
    if backgroundTask != .invalid {
      UIApplication.shared.endBackgroundTask(backgroundTask)
      backgroundTask = .invalid
    }
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
    
    let total = (minutes * 60) + seconds + (milliseconds / 100.0)
    return total
  }
  
  func doubleToTimeString(_ timeInterval: Double) -> String {
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
    
    let timeString = String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    return timeString
  }
}
