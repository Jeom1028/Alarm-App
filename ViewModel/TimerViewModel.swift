//
//  TimerViewModel.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import RxSwift
import RxCocoa
import Foundation

enum TimerState {
    case stopped
    case running
    case paused
}

class TimerViewModel {
    private let disposeBag = DisposeBag()
    private var timer: Timer?
    private let timerModel = TimerModel()
    
    let timerState = BehaviorRelay<TimerState>(value: .stopped)
    let timeText = BehaviorRelay<String>(value: "00:00:00")
    let progress = BehaviorRelay<Float>(value: 1.0)
    
    private var totalDuration: TimeInterval = 0
    
    func setTime(hours: Int, minutes: Int, seconds: Int) {
        timerModel.setTime(hours: hours, minutes: minutes, seconds: seconds)
        totalDuration = TimeInterval((hours * 3600) + (minutes * 60) + seconds)
        updateTimeText()
        updateProgress() // 초기화 시 progress를 설정합니다.
    }
    
    func startTimer() {
        guard timerState.value != .running else { return }
        
        timerState.accept(.running)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func pauseTimer() {
        guard timerState.value == .running else { return }
        timerState.accept(.paused)
        timer?.invalidate()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timerState.accept(.stopped)
        timerModel.reset()
        updateTimeText()
        updateProgress()
    }
    
    private func tick() {
        timerModel.tick()
        print("Tick in ViewModel")
        if timerModel.remainingTime <= 0 {
            resetTimer()
        } else {
            updateTimeText()
            updateProgress() // 시간이 지날 때마다 progress를 업데이트합니다.
        }
    }
    
    private func updateTimeText() {
        timeText.accept(timerModel.formattedTime())
    }
    
    private func updateProgress() {
        if totalDuration > 0 {
            let progressValue = Float(timerModel.remainingTime) / Float(totalDuration)
            progress.accept(progressValue)
        } else {
            progress.accept(1.0)
        }
    }
}


