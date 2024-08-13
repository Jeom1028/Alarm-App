//
//  AlramModalController.swift
//  Alarm App
//
//  Created by 강유정 on 8/13/24.
//

import UIKit

class AlramModalController: UIViewController {
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time // 시간 모드로 설정
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .olveDrab
        
        setupNavigationBar()
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
    
    //MARK: - 취소 버튼을 눌렸을 때 호출되는 메서드 - YJ
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil) // 모달 닫기
    }
    
    //MARK: - 취소 버튼을 눌렸을 때 호출되는 메서드 - YJ
    @objc func addButtonTapped() {
        print("저장버튼누름")
    }
}
