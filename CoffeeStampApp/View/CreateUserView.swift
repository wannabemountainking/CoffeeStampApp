//
//  CreateUserView.swift
//  CoffeeStampApp
//
//  Created by yoonie on 2/18/26.
//

import SwiftUI

struct CreateUserView: View {
    
    // Sheet 을 닫기 위한 dismiss
    @Environment(\.dismiss) var dismiss
    
    // viewmodel 연결
    @ObservedObject var vm: StampViewModel
    
    var body: some View {
        List {
            Section {
                // content
                TextField("Name*", text: $vm.stamp.name)
                    .keyboardType(.namePhonePad)
                TextField("Company*", text: $vm.stamp.company)
                    .keyboardType(.namePhonePad)
                Toggle("Favorite", isOn: $vm.stamp.isFav)
            } header: {
                Text("GENERAL")
                    .foregroundStyle(.black)
            } footer: {
                Text("* You should fill in name & Company name")
            }//:SECTION
            
            Section("NOTE") {
                TextField("", text: $vm.stamp.notes, axis: .vertical)
                    .keyboardType(.namePhonePad)
            }//:SECTION
            .foregroundStyle(.black)
        } //:LIST
        // list background
        .scrollContentBackground(.hidden)
        .background(Color.accentColor.opacity(0.3))
        .navigationTitle("New User")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    // USER SAVE ACTION
                    validate()
                    dismiss()
                } label: {
                    Text("Done")
                }
                .disabled(!vm.stamp.isValid)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    // TODO: DISMISS ACTION
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
        
    }//: body
}


extension CreateUserView {
    func validate() {
        if vm.stamp.isValid {
            do {
                try vm.viewModelSave()
            } catch {
                print("No Stamp Data")
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        CreateUserView()
//    }
//}
