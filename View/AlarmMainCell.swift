//
//  AlarmMainCell.swift
//  Alarm App
//
//  Created by 강유정 on 8/17/24.
//

import UIKit
import SnapKit

class AlarmMainCell: UITableViewCell {
    static let id = "AlarmMainCell"
    
    private let amapLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 45)
        label.textColor = .black
        return label
    }()
    
    private let switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor.olveDrab // 스위치가 켜졌을 때의 색상
        switchControl.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return switchControl
    }()
    
    // 클로저를 통해 스위치 상태 변경 이벤트 전달
    var switchChanged: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        [
            amapLabel,
            timeLabel,
            switchControl
        ].forEach { contentView.addSubview($0) }
        
        amapLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(30)
            $0.bottom.equalTo(contentView.snp.bottom).inset(25)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(55)
            $0.centerY.equalToSuperview()
        }
        
        switchControl.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).inset(16)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    //MARK: - 스위치의 상태가 변경될 때 호출 - YJ
    @objc private func switchChanged(_ sender: UISwitch) {
        switchChanged?(sender.isOn)
        // 스위치의 새로운 상태를 인자로 전달
    }
    
    //MARK: - 셀에 표시할 내용을 구성하는 메서드 - YJ
    func configure(with alarm: Alarm) {
        amapLabel.text = alarm.ampm
        
        // 두 자리 형식으로 분을 포맷
        let formattedTime = "\(alarm.hour):\(String(format: "%02d", alarm.minute))"
        timeLabel.text = formattedTime
    }
}

