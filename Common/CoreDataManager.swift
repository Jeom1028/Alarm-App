//
//  CoreDataManager.swift
//  Alarm App
//
//  Created by 강유정 on 8/13/24.
//

import CoreData
import UIKit

//MARK: - 코어데이터 CRUD 일반적인 메서드 - YJ
class CoreDataManager {
    static let shared = CoreDataManager()
    
    // AppDelegate 내부에 있는 viewContext를 호출하는 코드
    private var context: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate가 초기화되지 않았습니다.")
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    private init() {}
    
    // Create
    // 생성 예시: CoreDataManager.shared.create(entityName: "Alram", values: ["time": ~~, "sound": "~~"], ofType: Alram.self)
    func create<T: NSManagedObject>(entityName: String, values: [String: Any], ofType type: T.Type) {
        guard let context = context, let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            print("엔티티 찾을 수 없음")
            return
        }
        
        let newObject = T(entity: entity, insertInto: context)
        for (key, value) in values {
            newObject.setValue(value, forKey: key)
        }
        
        saveContext()
    }
    
    
    // Read
    // 읽기 예시: CoreDataManager.shared.read(entityName: "Alarm", predicate: ~~, ofType: Alarm.self)
    func read<T: NSManagedObject>(entityName: String, predicate: NSPredicate? = nil, ofType type: T.Type) -> [T] {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        guard let context = context else { return [] }
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("데이터 읽기 실패")
            return []
        }
    }
    
    // Update
    // 업데이트 예시: CoreDataManager.shared.update(entityName: "Alarm", predicate: (기존 값), withValues: (새로운 값), ofType: Alarm.self)
    func update<T: NSManagedObject>(entityName: String, predicate: NSPredicate, withValues values: [String: Any], ofType type: T.Type) {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        guard let context = context else { return }
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                for (key, value) in values {
                    object.setValue(value, forKey: key)
                }
            }
            saveContext()
        } catch {
            print("업데이트 실패")
        }
    }
    
    // Delete
    // 삭제 예시: CoreDataManager.shared.delete(entityName: "Alarm", predicate: ~~, ofType: Alarm.self)
    func delete<T: NSManagedObject>(entityName: String, predicate: NSPredicate, ofType type: T.Type) {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        guard let context = context else { return }
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("삭제 실패")
        }
    }
    
    // 데이터 저장 함수
    private func saveContext() {
        guard let context = context else { return }
        if context.hasChanges {
            do {
                try context.save()
                print("문맥 저장 성공")
            } catch {
                print("문맥 저장 실패")
            }
        }
    }
}
