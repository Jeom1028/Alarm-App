//
//  TimerView.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TimerController: UIViewController {
    
    private let viewmodel = TimerViewModel()
    private let disposBag = DisposeBag()
    
    private let hoursPicker = UIPickerView()
    private let minutesPicker = UIPickerView()
    private let secondsPicker = UIPickerView()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.cornerRadius = 45
        button.backgroundColor = .olveDrab.withAlphaComponent(0.7)
        return button
    }()
    
    private let cancleButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.cornerRadius = 45
        button.backgroundColor = .black.withAlphaComponent(0.7)
        return button
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Courier-Bold", size: 60)
        label.textAlignment = .center
        label.text = "00:00:00"
        label.textColor = UIColor.black
        label.backgroundColor = .white
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor.black
        progressView.trackTintColor = UIColor.lightGray
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        return progressView
    }()
    
    private let soundTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "soundCell")
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        return tableView
    }()
    
    
    private var pickersStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPickers()
        bindViewModel()
        view.backgroundColor = UIColor.white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(timeLabelTapped))
        timeLabel.addGestureRecognizer(tapGesture)
        
        pickersStackView.isHidden = true
        
        soundTableView.delegate = self
        soundTableView.dataSource = self
    }
    
    private func setupUI() {
        pickersStackView = UIStackView(arrangedSubviews: [hoursPicker, minutesPicker, secondsPicker])
        pickersStackView.axis = .horizontal
        pickersStackView.distribution = .fillEqually
        pickersStackView.spacing = 10
        
        [pickersStackView, timeLabel, progressBar, startButton, cancleButton, soundTableView].forEach { view.addSubview($0) }
        
        
        // progressBar 레이아웃 설정
        progressBar.snp.makeConstraints {
            $0.bottom.equalTo(pickersStackView.snp.top).offset(-10)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(200)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(80)
        }
        
        pickersStackView.snp.makeConstraints  {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(200)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(150)
        }

        
        startButton.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(60)
            $0.right.equalToSuperview().inset(75)
            $0.width.height.equalTo(90)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(60)
            $0.left.equalToSuperview().inset(75)
            $0.width.height.equalTo(90)
        }
        
        soundTableView.snp.makeConstraints {
            $0.top.equalTo(startButton.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(200)  // 셀 3개 높이 설정 (각 셀 50, 헤더 50)
              }
    }
    
    @objc private func timeLabelTapped() {
        guard viewmodel.timerState.value == .stopped else { return }
        
        timeLabel.isHidden = true
        pickersStackView.isHidden = false
    }
    
    private func setupPickers() {
        hoursPicker.dataSource = self
        hoursPicker.delegate = self
        minutesPicker.delegate = self
        minutesPicker.dataSource = self
        secondsPicker.delegate = self
        secondsPicker.dataSource = self
    }
    
    private func bindViewModel() {
        let pickerData = Observable.just(Array(0...59))
        
        Observable.combineLatest(
            hoursPicker.rx.itemSelected.map { $0.row },
            minutesPicker.rx.itemSelected.map { $0.row },
            secondsPicker.rx.itemSelected.map { $0.row }
        )
        .subscribe(onNext: { [weak self] hours, minutes, seconds in
            print("Selected time from picker: \(hours)h \(minutes)m \(seconds)s")
            self?.viewmodel.setTime(hours: hours, minutes: minutes, seconds: seconds)
        }).disposed(by: disposBag)
        
        viewmodel.timerState
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .stopped:
                    self?.startButton.setTitle("시작", for: .normal)
                    self?.cancleButton.setTitle("취소", for: .normal)
                    self?.timeLabel.isHidden = false
                    self?.pickersStackView.isHidden = true
                case .running:
                    self?.startButton.setTitle("일시정지", for: .normal)
                    self?.timeLabel.isHidden = false
                    self?.pickersStackView.isHidden = true
                case .paused:
                    self?.startButton.setTitle("재시작", for: .normal)
                    self?.cancleButton.setTitle("초기화", for: .normal)
                    self?.timeLabel.isHidden = false
                    self?.pickersStackView.isHidden = true
                }
            }).disposed(by: disposBag)
        
        startButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                switch self.viewmodel.timerState.value {
                case .stopped, .paused:
                    self.viewmodel.startTimer()
                case .running:
                    self.viewmodel.pauseTimer()
                }
            }).disposed(by: disposBag)
        
        cancleButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewmodel.resetTimer()
            }).disposed(by: disposBag)
        
        viewmodel.timeText
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposBag)
        
        // progressBar 업데이트
        viewmodel.progress
            .observe(on: MainScheduler.instance)
            .bind(to: progressBar.rx.progress)
            .disposed(by: disposBag)
    }
}


extension TimerController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%02d", row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 선택된 값을 즉시 viewModel에 반영
        let hours = hoursPicker.selectedRow(inComponent: 0)
        let minutes = minutesPicker.selectedRow(inComponent: 0)
        let seconds = secondsPicker.selectedRow(inComponent: 0)
        viewmodel.setTime(hours: hours, minutes: minutes, seconds: seconds)
    }
}

extension TimerController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Custom view for header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.olveDrab

        let label = UILabel()
        label.text = "사운드"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.frame = CGRect(x: 16, y: 0, width: tableView.frame.width, height: 60)

        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "soundCell", for: indexPath)
        cell.textLabel?.text = "소리 \(indexPath.row + 1)"
        cell.backgroundColor = UIColor.khaki
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Sound \(indexPath.row + 1)")
        // 여기에 사용자가 소리를 선택했을 때의 로직 추가
    }
}
