//
//  StampRowView.swift
//  CoffeeStampApp
//
//  Created by yoonie on 2/18/26.
//

import SwiftUI
import Combine

struct StampRowView: View {
    
    @ObservedObject var vm: StampViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            Text(vm.stamp.name)
                .font(.title2.bold())
            
            Text(vm.stamp.company)
                .font(.caption)
        } //:VSTACK
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .topTrailing) {
            Button {
                // FAV ACTION
                vm.stamp.isFav.toggle()
                save()
            } label: {
                Image(systemName: "star")
                    .font(.title3)
                    .symbolVariant(.fill)
                    .foregroundStyle(vm.stamp.isFav ? .yellow : .gray.opacity(0.3))
            }
            .buttonStyle(.plain)
        }
    }
    
    // save fav
    func save() {
        do {
            try vm.viewModelSave()
        } catch {
            print("Error: \(error)")
        }
    }
}
//
//#Preview {
//    StampRowView(index: 1)
//}
