//
//  AlramModalController.swift
//  Alarm App
//
//  Created by 강유정 on 8/13/24.
//

import UIKit
import SnapKit

class AlarmModalController: UIViewController {
    
    private let datePicker = UIPickerView()
    private let viewModel = AlarmViewModel()
    
    private let soundLabel: UILabel = {
        let label = UILabel()
        label.text = "사운드 선택"
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .olveDrab.withAlphaComponent(0.3)
        tableView.layer.cornerRadius = 15
        tableView.rowHeight = 45
        return tableView
    }()
    
    private let hours = Array(1...12)
    private let minutes = Array(0...59)
    private let ampm = ["오전", "오후"]
    private let sound = ["기상나팔", "불침번", "행정반", "안함"]
    
    private var selectedSound: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupUI()
        
        datePicker.delegate = self
        datePicker.dataSource = self
        
        tableView.dataSource = self
        tableView.delegate = self
        // tableView 셀 등록
        tableView.register(AlarmSoundCell.self, forCellReuseIdentifier: AlarmSoundCell.id)
        
    }
    
    //MARK: - 바 버튼을 설정하는 메서드 - YJ
    private func setupNavigationBar() {
        title = "알람 추가"
        // 네비게이션 바 타이틀 색상 설정
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.brown ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        // 네비게이션 바에 취소 버튼 추가
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .black
        navigationItem.leftBarButtonItem = cancelButton
        // 네비게이션 바에 저장 버튼 추가
        let addButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupUI() {
        [
            datePicker,
            soundLabel,
            tableView
        ].forEach { view.addSubview($0) }
        
        datePicker.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
        
        soundLabel.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(35)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(soundLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(180)
            $0.width.equalToSuperview().inset(25)
        }
    }
    
    //MARK: - 취소 버튼을 눌렸을 때 호출되는 메서드 - YJ
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil) // 모달 닫기
    }
    
    //MARK: - 저장 버튼을 눌렸을 때 호출되는 메서드 - YJ
    @objc func addButtonTapped() {
        // 선택된 정보 가져오기
        let ampm = ampm[datePicker.selectedRow(inComponent: 0)]
        let hour = hours[datePicker.selectedRow(inComponent: 1)]
        let minute = minutes[datePicker.selectedRow(inComponent: 2)]
        
        // Core Data에 저장
        viewModel.addAlarm(hour: hour, minute: minute, ampm: ampm, sound: selectedSound)
        
        // 알림 예약
        viewModel.scheduleAlarmNotification(hour: hour, minute: minute, ampm: ampm, sound: selectedSound)
        print("\(hour), \(minute), \(ampm), \(selectedSound)")
        
        dismiss(animated: true, completion: nil) // 모달 닫기
    }
}

//MARK: - UIPickerView에 표시할 데이터와 동작을 정의 - YJ
extension AlarmModalController: UIPickerViewDelegate, UIPickerViewDataSource {
    // UIPickerView에서 표시할 컴포넌트의 수를 반환하는 메서드
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    // 각 열에서 표시할 행의 수를 반환하는 메서드
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return ampm.count
        case 1:
            return hours.count
        case 2:
            return minutes.count
        default:
            return 0
        }
    }
    
    // 각 컴포넌트의 행에 표시할 문자열을 반환하는 메서드
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return ampm[row]
        case 1:
            return "\(hours[row])"
        case 2:
            return String(format: "%02d", minutes[row]) // 2자리로 포맷
        default:
            return nil
        }
    }
}

//MARK: - TableView 설정 - YJ
extension AlarmModalController: UITableViewDataSource, UITableViewDelegate {
    
    // 각 섹션의 행 수를 반환하는 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sound.count
    }
    
    // 각 셀을 구성하는 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmSoundCell.id, for: indexPath) as! AlarmSoundCell
        
        let soundName = sound[indexPath.row]
        cell.configure(with: soundName)
        
        return cell
    }
    
    // 셀을 선택했을 때 호출되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSound = sound[indexPath.row]
    }
}
