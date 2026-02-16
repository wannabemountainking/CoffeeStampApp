//
//  StampProvider.swift
//  CoffeeStampApp
//
//  Created by YoonieMac on 2/16/26.
//
//Provider: Core Data에서 ViewContext 내용을 가져오기 위한 singleton instance 생성을 위한 class
// -> Core Data의 환경을 ViewContext(서고 안내데스크) 에 만드는 작업
import Foundation
import CoreData

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
            if let error {
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
}
