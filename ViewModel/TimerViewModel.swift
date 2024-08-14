//
//  TimerViewModel.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import RxSwift
import RxCocoa
import Foundation
import UserNotifications  // 추가

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

    init() {
        requestNotificationPermission()  // 초기화 시 알림 권한 요청
    }
    
    func setTime(hours: Int, minutes: Int, seconds: Int) {
        timerModel.setTime(hours: hours, minutes: minutes, seconds: seconds)
        totalDuration = TimeInterval((hours * 3600) + (minutes * 60) + seconds)
        updateTimeText()
        updateProgress()
    }
    
    func startTimer() {
        guard timerState.value != .running else { return }
        
        timerState.accept(.running)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        
        // 타이머가 종료될 때 로컬 알림을 스케줄링
        scheduleNotification(in: totalDuration)
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
        
        // 타이머 리셋 시 알림 제거
        removePendingNotifications()
    }
    
    private func tick() {
        timerModel.tick()
        print("Tick in ViewModel")
        if timerModel.remainingTime <= 0 {
            resetTimer()
        } else {
            updateTimeText()
            updateProgress()
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
    
    // 알림 권한 요청
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    // 알림 스케줄링
    private func scheduleNotification(in timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "기상!!"
        content.body = "3중대 기상!!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    // 펜딩된 알림 제거
    private func removePendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
