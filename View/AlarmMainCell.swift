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
//        label.numberOfLines = 0 // 여러 줄 텍스트를 허용
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 45)
        label.textColor = .black
//        label.numberOfLines = 0 // 여러 줄 텍스트를 허용
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    private func setupCell() {
        [
            amapLabel,
            timeLabel
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 셀에 표시할 내용을 구성하는 메서드 - YJ
    func configure(with alarm: Alarm) {
        amapLabel.text = alarm.ampm
        
        // 두 자리 형식으로 분을 포맷
        let formattedTime = "\(alarm.hour):\(String(format: "%02d", alarm.minute))"
        timeLabel.text = formattedTime
    }
}

