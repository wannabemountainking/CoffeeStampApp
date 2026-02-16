//
//  UserDetailView.swift
//  CoffeeStampApp
//
//  Created by yoonie on 2/18/26.
//

import SwiftUI
internal import CoreData
import Combine

struct UserDetailView: View {
    
    // Navigation SplitView에서 ipad 와 iphone 크기를 다르게 하기 위한 environment
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    //뷰모델 가져오기
    @ObservedObject var vm: StampViewModel
    
    var isiPhone: Bool {
        horizontalSizeClass == .compact
    }
    
    var body: some View {
        List {
            Text(isiPhone ? "아이폰" : "아이패드")
            
            Section("General") {
                LabeledContent {
                    Text(vm.stamp.name)
                } label: {
                    Text("Name")
                }
                LabeledContent {
                    Text(vm.stamp.company)
                } label: {
                    Text("Company")
                }
                LabeledContent {
                    Text("\(vm.stamp.totalFreeCoffee)")
                } label: {
                    Text("Total Free Coffee")
                }
            }//:SECTION
            
            Section("Stamp \(vm.stamp.selectedCoffee)/7") {
                if isiPhone {
                    VStack(spacing: 20) {
                        HStack {
                            ForEach(1..<4, id: \.self) { index in
                                Image(systemName: "cup.and.saucer")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .onTapGesture {
                                        // SELECT COFFEE ACTION
                                        vm.stamp.selectedCoffee = index
                                        save()
                                    }
                                    .foregroundStyle(index <= vm.stamp.selectedCoffee ? .accentColor : Color.gray.opacity(0.3))
                            } //:LOOP
                            .padding(.horizontal, 20)
                        } //:HSTACK
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        HStack {
                            ForEach(4..<8, id: \.self) { index in
                                Image(systemName: "cup.and.saucer")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .onTapGesture {
                                        // SELECT COFFEE ACTION
                                        vm.stamp.selectedCoffee = index
                                        save()
                                    }
                                    .foregroundStyle(index <= vm.stamp.selectedCoffee ? .accentColor : Color.gray.opacity(0.3))
                            } //:LOOP
                            .padding(.horizontal, 15)
                        } //:HSTACK
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Image(systemName: "cup.and.saucer.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(Color.accentColor)
                            .onTapGesture {
                                // COUNT TOTAL FREE COFFEE ACTION
                                vm.stamp.totalFreeCoffee += 1
                                vm.stamp.selectedCoffee = 0
                                save()
                            }
                    } //:VSTACK
                } else {
                    //iPad 일때
                    
                    VStack(spacing: 30) {
                        HStack {
                            ForEach(1..<8, id: \.self) { index in
                                Image(systemName: "cup.and.saucer")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .onTapGesture {
                                        // SELECT COFFEE ACTION
                                        vm.stamp.selectedCoffee = index
                                        save()
                                    }
                                    .foregroundStyle(index <= vm.stamp.selectedCoffee ? Color.accentColor : .gray.opacity(0.3))
                                    .padding(.horizontal)
                            } //:LOOP
                            .padding(.horizontal, 20)
                        } //:HSTACK
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Image(systemName: "cup.and.saucer.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(Color.accentColor)
                            .onTapGesture {
                                // COUNT TOTAL FREE COFFEE ACTION
                                vm.stamp.totalFreeCoffee += 1
                                vm.stamp.selectedCoffee = 0
                                save()
                            }
                    } //:VSTACK
                }//:CONDITIONAL
            }//:SECTION
            
            Section("Notes") {
                Text(vm.stamp.notes)
            }//:SECTION
            
        } //:LIST
        .scrollContentBackground(.hidden) // Background Color 보이게 하기
        .background(Color.accent.opacity(0.5))
        .navigationTitle("Test Name")
        .navigationBarTitleDisplayMode(.inline)
    }//: body
    
    func save() {
        do {
            try vm.viewModelSave()
        } catch {
            print("Errir In Saving: \(error)")
        }
    }
}

//#Preview {
//    NavigationStack {
//        UserDetailView()
//    }
//}
