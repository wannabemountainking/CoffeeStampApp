//
//  StampViewModel.swift
//  CoffeeStampApp
//
//  Created by YoonieMac on 2/16/26.
//

import Foundation
import CoreData
import Combine


final class StampViewModel: ObservableObject {
    
    // MARK: - PROPERTY
    // Add, Edit, Detail 에서 사용될 Stamp
    // Bool값에 let 이 선언된 이유는 아마도 나중에 분기하기 위함일 듯
    @Published var stamp: Stamp
    @Published var isNew: Bool
    
    // MARK: - CORE DATA
    let provider: StampProvider
    let context: NSManagedObjectContext
    
    init(provider: StampProvider, stamp: Stamp? = nil) {
        self.provider = provider
        self.context = provider.newContext // 새로 갈아 끼움
        
        // 현재 stamp에 데이터가 있는 경우 edit 모드로 넘어갈 수 있게 exist 불러오기
        if let stamp, let existingStamp = provider.exist(stamp: stamp, context: context) {
            self.stamp = existingStamp
            self.isNew = false
        } else {
            // Stamp가 NSManagedObject를 상속받고 있고 NSManagedObject는 태생적으로 자신이 속하는 context를 알아야 함. 그래서 모든 NSManagedObject는 context를 넣어줘야 생성됨
            self.stamp = Stamp(context: self.context)
            self.isNew = true
        }

    }
    
    // MARK: - FUNCTION(CRUD)
    // add, edit 할 때 데이터 저장
    func viewModelSave() throws {
        //context의 변화가 있을 경우 자기 자신을 저장하는 것
        if context.hasChanges {
            try context.save()
        }
    }
}
