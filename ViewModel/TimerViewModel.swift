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
    
    //시간 설정
    func setTime(hours: Int, minutes: Int, seconds: Int) {
        timerModel.setTime(hours: hours, minutes: minutes, seconds: seconds)
        updateTimeText() // 시간 값을 즉시 라벨에 반영
    }
    
    // 타이머 시작
    func startTimer() {
        guard timerState.value != .running else { return }
        
        timerState.accept(.running)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    // 타이머 일시정지
    func pauseTimer() {
        guard timerState.value == .running else { return }
        timerState.accept(.paused)
        timer?.invalidate()
    }
    
    //타이머 취소 or 리셋
    func resetTimer() {
        timer?.invalidate()
        timerState.accept(.stopped)
        timerModel.reset()
        updateTimeText()
    }
    
    private func tick() {
        timerModel.tick()
        print("Tick in ViewModel")  // Debugging
        if timerModel.remainingTime <= 0 {
            resetTimer()
        } else {
            updateTimeText()
        }
    }

    
    private func updateTimeText() {
        timeText.accept(timerModel.formattedTime())
    }
}


