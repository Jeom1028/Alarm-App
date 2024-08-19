//
//  TimerCell.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/19/24.
//

import UIKit
import SnapKit

class TimerSoundCell: UITableViewCell {
    static let id = "TimerSoundCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    private func setupCell() {
        contentView.addSubview(titleLabel)
        
        // Auto Layout 제약 조건
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        // 셀의 여백 제거
        layoutMargins = .zero
        separatorInset = .zero
        contentView.layoutMargins = .zero
        
        // 선택된 배경 색상 설정
        let selectedBackgroundView = UIView()
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with sound: String, isChecked: Bool) {
        titleLabel.text = sound
        accessoryType = isChecked ? .checkmark : .none
        self.backgroundColor = .olveDrab.withAlphaComponent(0.3)
    }
}
