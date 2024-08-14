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
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.cornerRadius = 10
        stackView.backgroundColor = .olveDrab.withAlphaComponent(0.4)
        stackView.axis = .vertical
        return stackView
    }()
    
    private let soundLabel: UILabel = {
        let label = UILabel()
        label.text = "사운드"
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    private let soundDataLabel: UIButton = {
        let label = UIButton()
        label.setTitle("안 함 ＞", for: .normal)
        label.titleLabel?.font = .systemFont(ofSize: 14)
        label.setTitleColor(.gray, for: .normal)
        label.contentHorizontalAlignment = .right
        return label
    }()
    
    private let hours = Array(1...12)
    private let minutes = Array(0...59)
    private let ampm = ["오전", "오후"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupUI()
        
        datePicker.delegate = self
        datePicker.dataSource = self
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
            stackView,
        ].forEach { view.addSubview($0) }
        
        datePicker.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalToSuperview().inset(25)
        }
        
        [
            soundLabel,
            soundDataLabel,
        ].forEach { stackView.addArrangedSubview($0) }
        
        soundLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        soundDataLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
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
        viewModel.addAlarm(hour: hour, minute: minute, ampm: ampm)

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

