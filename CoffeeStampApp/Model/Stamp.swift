//
//  Stamp.swift
//  CoffeeStampApp
//
//  Created by YoonieMac on 2/16/26.
//

import Foundation
internal import CoreData

// Core Data Model을 Manually 생성
// final -> 하위 subclass에서 override 막기
final class Stamp: NSManagedObject, Identifiable {
    
    // Core Data 안에 subclass 에 NSObject로 접근하기 위해서 @NSManaged 사용
    @NSManaged var name: String
    @NSManaged var company: String
    @NSManaged var isFav: Bool
    @NSManaged var notes: String
    @NSManaged var totalFreeCoffee: Int
    @NSManaged var selectedCoffee: Int
    
    // name, company 에 값이 있는 경우 저장이 안되게 save 를 disable하기 위한 Computed Property
    var isValid: Bool {
        !name.isEmpty && !company.isEmpty
    }
}


extension Stamp {
    private static var stampFetchRequest: NSFetchRequest<Stamp> {
        NSFetchRequest(entityName: "Stamp")
    }
    
    // all() 함수를 할 때 request 를 sort 해서 array로 return 하기
    static func all() -> NSFetchRequest<Stamp> {
        let request: NSFetchRequest<Stamp> = stampFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Stamp.name, ascending: true)
        ]
        return request
    }
    
    // Stamp가 아무것도 없는 Blank 상태에서 Core Data 추가 하기
    static func empty(context: NSManagedObjectContext = StampProvider.shared.viewContext) -> Stamp {
        return Stamp(context: context)
    }
    
    // Favorite 될 수 있게 하는 함수
    static func favFilter(config: FavConfig) -> NSPredicate {
        switch config.filter {
        case .all:
            // NSPredicate 으로 모든 값 호출
            NSPredicate(value: true)
        case .fave:
            // %@은 검새고할 값을 전달할 때 사용함. Core Data에서 isFav가 true인 것만 검색하고 알려줌
            // 만약 %@을 사용해 값 형식을 대체해야 할 때는 NSNumber로 value값을 포장해서 전달함(모두 객체로 만들어 보내는 Objective-C방식)
            NSPredicate(format: "isFav == %@", NSNumber(value: true))
        }
    }
    
    // Sort 함수
    static func sort(order: Sort) -> [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \Stamp.name, ascending: order == .asc)]
    }
}


// MARK: - FAV Logic
struct FavConfig: Equatable {
    enum Filter {
        case all, fave
    }
    var filter: Filter = .all
}

// MARK: - Sort Logic
enum Sort {
    case asc, dec
}
