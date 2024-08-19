//
//  File.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import Foundation
import RxSwift
import RxCocoa

class AlarmViewModel {
    
    private let alarmsSubject = PublishSubject<[Alarm]>()
//    private let selectedSoundSubject = BehaviorSubject<String?>(value: nil)
    private let disposeBag = DisposeBag()
    
    init() {
        fetchalarms()
    }
    
    //MARK: - 코어데이터에서 정보 가져와서 방출하는 메서드 - YJ
    func fetchalarms() {
        Observable.create { observer in
            let coreDataManager = CoreDataManager.shared
            let fetchedAlarms = coreDataManager.read(entityName: "Alarm", predicate: nil, ofType: Alarm.self)
            observer.onNext(fetchedAlarms)
            observer.onCompleted()
            return Disposables.create()
        }
        .bind(to: alarmsSubject)
        .disposed(by: disposeBag)
    }
    
    //MARK: - 새로운 알람 데이터를 Core Data에 저장하는 메서드 - YJ
    func addAlarm(hour: Int, minute: Int, ampm: String, sound: String) {
        let coreDataManager = CoreDataManager.shared
        coreDataManager.create(
            entityName: "Alarm",
            values: [
                "hour": hour,
                "minute": minute,
                "ampm": ampm,
                "sound": sound
            ],
            ofType: Alarm.self
        )
        
        // 업데이트된 데이터 가져오기
        fetchalarms()
    }
}
