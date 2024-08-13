//
//  TimerModel.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/13/24.
//

import Foundation

class TimerModel {
    private(set) var remainingTime: Int = 0
    
    func setTime(hours: Int, minus: Int, seconds: Int) {
        remainingTime = (hours * 3600) + (minus * 60) + seconds
    }
    
    func tick() {
        guard remainingTime > 0 else { return }
        remainingTime -= 1
    }
    
    func formattedTime() -> String {
        let hours = remainingTime / 3600
        let minutes = (remainingTime % 3600) / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d:%02d", hours,minutes,seconds)
    }
}
