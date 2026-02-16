//
//  Stamp.swift
//  CoffeeStampApp
//
//  Created by YoonieMac on 2/16/26.
//

import Foundation
import CoreData

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
}
