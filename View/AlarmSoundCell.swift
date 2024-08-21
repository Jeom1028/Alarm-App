//
//  AlarmSoundCell.swift
//  Alarm App
//
//  Created by 강유정 on 8/17/24.
//

import UIKit
import SnapKit

class AlarmSoundCell: UITableViewCell {
    static let id = "AlarmSoundCell"
    
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
        contentView.backgroundColor = .olveDrab.withAlphaComponent(0.4)
        
        // Auto Layout 제약 조건
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 셀에 표시할 내용을 구성하는 메서드 - YJ
    func configure(with sound: String) {
        titleLabel.text = sound
    }
}
