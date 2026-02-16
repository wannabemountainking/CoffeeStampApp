//
//  CoffeeStampAppApp.swift
//  CoffeeStampApp
//
//  Created by YoonieMac on 2/16/26.
//

import SwiftUI

@main
struct CoffeeStampAppApp: App {
    
    @StateObject var vm: StampViewModel = .init(provider: StampProvider.shared)
    
    var body: some Scene {
        WindowGroup {
            MainView()
            // Core Data 를 SwiftUI에 managedObjectContext 로 넘겨줘야 Core Data를 가져올 수 있음
                .environment(\.managedObjectContext, StampProvider.shared.viewContext)
            // viewModel 넘겨주기
                .environmentObject(vm)
        }
    }
}
