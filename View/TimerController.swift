//
//  TimerView.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import UIKit
import SnapKit

class TimerController: UIViewController {
    
    private let hoursPicker = UIPickerView()
    private let minutesPicker = UIPickerView()
    private let secondsPicker = UIPickerView()
    
    private let startButton: UIButton = {
       let button = UIButton()
        button.setTitle("시작", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.brown
       return button
    }()
    
    private let cancleButton: UIButton = {
       let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.brown
        return button
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Courier-Bold", size: 40)
        label.textAlignment = .center
        label.text = "00:00:00"
        label.textColor = UIColor.khaki
        label.backgroundColor = .black
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    private var pickersStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = UIColor.olveDrab
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        
        pickersStackView = UIStackView(arrangedSubviews: [hoursPicker, minutesPicker, secondsPicker])
        pickersStackView.axis = .horizontal
        pickersStackView.distribution = .fillEqually
        pickersStackView.spacing = 10
        
        [pickersStackView, timeLabel, startButton, cancleButton].forEach { view.addSubview($0) }
        
        pickersStackView.snp.makeConstraints  {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(150)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(pickersStackView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(20)
            $0.right.equalToSuperview().inset(100)
            $0.width.equalTo(80)
            $0.height.equalTo(50)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(100)
            $0.width.equalTo(80)
            $0.height.equalTo(50)
        }
    }
}
