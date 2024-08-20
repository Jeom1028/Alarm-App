//
//  File.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import Foundation
import RxSwift
import UserNotifications

class AlarmViewModel {
    
    let alarmsSubject = BehaviorSubject(value: [Alarm]())
    private let disposeBag = DisposeBag()
    
    //MARK: - 알람 리스트 Observable - YJ
    var alarms: Observable<[Alarm]> {
        return alarmsSubject.asObservable()
    }
    
    init() {
        requestNotificationAuthorization()
        fetchAlarms()
    }
    
    //MARK: - 코어데이터에서 정보 가져와서 방출하는 메서드 - YJ
    func fetchAlarms() {
        let coreDataManager = CoreDataManager.shared
        let fetchedAlarms = coreDataManager.read(entityName: "Alarm", predicate: nil, ofType: Alarm.self)
        print("\(fetchedAlarms)")
        alarmsSubject.onNext(fetchedAlarms)
    }
    
    //MARK: - 새로운 알람 데이터를 Core Data에 저장하는 메서드 - YJ
    func addAlarm(hour: Int, minute: Int, ampm: String, sound: String) {
         let coreDataManager = CoreDataManager.shared
         
        // UUID 생성
        let id = UUID()
        
        coreDataManager.create(
            entityName: Alarm.className,
            values: [
                Alarm.Key.id: id,
                Alarm.Key.hour: hour,
                Alarm.Key.minute: minute,
                Alarm.Key.ampm: ampm,
                Alarm.Key.sound: sound
            ],
            ofType: Alarm.self
        )
        
        // 업데이트된 데이터 가져오기
        fetchAlarms()
    }
    
    //MARK: - 권한 요청하는 메서드 - YJ
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                if let error = error {
                    print("Notification permission denied: \(error.localizedDescription)")
                } else {
                    print("Notification permission denied.")
                }
            }
        }
    }
    
    //MARK: - 알림을 예약하는 메서드 - YJ
    func scheduleAlarmNotification(hour: Int, minute: Int, ampm: String, sound: String) {
        let content = UNMutableNotificationContent()
        content.title = "알람"
        content.body = "기상"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sound).wav"))
        
        // 12시간 형식에서 24시간 형식으로 변환
        let hour24 = convertTo24HourFormat(hour: hour, ampm: ampm)
        
        // 알림 트리거 설정
        let dateComponents = DateComponents(hour: hour24, minute: minute, second: 0)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // 알림 추가
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 요청 추가 에러: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - 12시간 형식을 24시간 형식으로 변환하는 메서드 - YJ
    private func convertTo24HourFormat(hour: Int, ampm: String) -> Int {
        switch ampm.lowercased() {
        case "오후":
            return (hour < 12) ? hour + 12 : hour
        case "오전":
            return (hour == 12) ? 0 : hour
        default:
            return hour
        }
    }
    
    // MARK: - 알람을 삭제하는 메서드 - YJ
    func deleteAlarm(at index: Int) {
        var currentAlarms = (try? alarmsSubject.value()) ?? []
        let alarmToDelete = currentAlarms[index]
        
        let coreDataManager = CoreDataManager.shared
        
        guard let uuid = alarmToDelete.value(forKey: Alarm.Key.id) as? UUID else {
            print("알람 UUID를 찾을 수 없음.")
            return
        }
        
        let predicate = NSPredicate(format: "\(Alarm.Key.id) == %@", uuid as CVarArg)
        coreDataManager.delete(entityName: Alarm.className, predicate: predicate, ofType: Alarm.self)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuid.uuidString])
        
        currentAlarms.remove(at: index)
        alarmsSubject.onNext(currentAlarms)  // 데이터 소스 업데이트
    }
}
