//
//  StampProvider.swift
//  CoffeeStampApp
//
//  Created by YoonieMac on 2/16/26.
//
//Provider: Core Data에서 ViewContext 내용을 가져오기 위한 singleton instance 생성을 위한 class
// -> Core Data의 환경을 ViewContext(서고 안내데스크) 에 만드는 작업
import Foundation
internal import CoreData

class StampProvider {
    
    // singleton instance 선언
    static let shared = StampProvider()
    
    // container
    private let container: NSPersistentContainer
    
    // ViewContext
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    // Add Stamp Context 추가하는 computed property
    // newContext가 쓰이는 적절한 상황은 새 데이터를 생성할 때(Add/Edit 화면)로 새 객체는 viewContext와 무관하게 만들어졌다가 save()하면 automaticallyMergesChangesFromParent = true 덕분에 viewContext가 자동으로 감지 -> UI 업데이트
    // 만약 newContext에서 delete를 하면 삭제후 save()해도 viewContexxt는 자동으로 모름.
    var newContext: NSManagedObjectContext {
        // NSManagedObject가 main Thread에서 작동할 수 있게 설정 -> viewContext는 view에 나타나는 것이기 때문에 main thread 에서 해 줘야 나중에 error 안생감
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        // 위에 설정한 context값을 현재 container StoreCoordinator에서 작동하게 해주는 코드
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        return context
    }
    
    // MARK: - INIT
    private init() {
        container = NSPersistentContainer(name: "StampDataModel")
        
        // ViewContext 가 변화 될 때 자동으로 기존 데이터에 merge 시켜서 자동 업데이트 시켜줌
        // claude: 무거운 작업은 버벅거릴 가능성이 있어 ViewContext가 아닌 BackgroundContext에서 작업하고 save()하기도 하는데 이때 viewContext의 부모 컨텍스트인 BackgroundContext에서의 변화를 자식컨텍스트 viewContext는 모르는데 automaticallyMergesChangesFromParent = true하면 viewContext도 자동 업데이트 됨
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA: \(error)")
            } else {
                print("SUCCESSFULLU LOADED CORE DATA: \(description)")
            }
        }
    }
    
    // Stamp Core Data에 저장되어 있는지 없는지 확인하기
    func exist(stamp: Stamp, context: NSManagedObjectContext) -> Stamp? {
        try? context.existingObject(with: stamp.objectID) as? Stamp
    }
    
    //Delete Data: core data에 있는지 확인, 있으면 지우고, 이 상태를 비동기로(지운 후 저장을 확실하게 하기) 처리
    func delete(stamp: Stamp, context: NSManagedObjectContext) throws {
        // 1. 현재 스템프가 있는 지 확인하기
        if let existingStamp = exist(stamp: stamp, context: context) {
            // 2. 선택된 stamp를 context에서 지움 -> core data 에서 지움
            context.delete(existingStamp)
            // 3. 삭제한 다음에 다시 상태를 context에 저장해야 함 -> 비동기 처리해야되서 Task를 사용 (background 상태에서 작업할 수 있게 함)
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }
}
