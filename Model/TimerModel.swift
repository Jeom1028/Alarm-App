//
//  TimerModel.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/13/24.
//

import Foundation

class TimerModel {
    private var hours: Int = 0
    private var minutes: Int = 0
    private var seconds: Int = 0
    private(set) var remainingTime: Int = 0
    
    func setTime(hours: Int, minutes: Int, seconds: Int) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        updateRemainingTime()
        print("Time Set: \(hours):\(minutes):\(seconds)")  // Debugging
    }

    func tick() {
        if remainingTime > 0 {
            remainingTime -= 1

            let totalSeconds = remainingTime
            hours = totalSeconds / 3600
            minutes = (totalSeconds % 3600) / 60
            seconds = totalSeconds % 60
            
            print("Tick: \(hours):\(minutes):\(seconds)")  // Debugging
        }
    }

    func reset() {
        hours = 0
        minutes = 0
        seconds = 0
        updateRemainingTime()
    }
    
    func formattedTime() -> String {
        return String(format: "%02d:%02d:%02d", hours,minutes,seconds)
    }
    
    func updateRemainingTime() {
        remainingTime = (hours * 3600) + (minutes * 60) + seconds
        print("Updating Remaining Time: hours: \(hours), minutes: \(minutes), seconds: \(seconds), remainingTime: \(remainingTime)") // 디버깅
    }


}
