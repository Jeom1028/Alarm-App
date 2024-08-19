//
//  TimerViewModel.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import RxSwift
import RxCocoa
import Foundation
import UserNotifications
import UIKit

enum TimerState {
    case stopped
    case running
    case paused
}

class TimerViewModel: NSObject, UNUserNotificationCenterDelegate {
    private let disposeBag = DisposeBag()
    private var timer: Timer?
    private let timerModel = TimerModel()
    
    let timerState = BehaviorRelay<TimerState>(value: .stopped)
    let timeText = BehaviorRelay<String>(value: "00:00:00")
    let progress = BehaviorRelay<Float>(value: 1.0)
    
    private var totalDuration: TimeInterval = 0

    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self  // Add this line
        requestNotificationPermission()
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
        
        startBackgroundTask()
        print("Starting timer and scheduling notification")
        scheduleNotification(in: totalDuration)
    }

    func pauseTimer() {
        guard timerState.value == .running else { return }
        timerState.accept(.paused)
        timer?.invalidate()
        endBackgroundTask()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timerState.accept(.stopped)
        timerModel.reset()
        updateTimeText()
        updateProgress()
        endBackgroundTask()
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
    
    private func scheduleNotification(in timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "기상!!"
        content.body = "3중대 기상!!"
        content.sound = UNNotificationSound.default

        print("Scheduling notification with content: \(content.title), \(content.body)")

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    private func removePendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func startBackgroundTask() {
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            self.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTaskID != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
    }
    
    // UNUserNotificationCenterDelegate method to handle notifications while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show alert and sound when app is in foreground
        completionHandler([.banner, .sound])
    }
}
