//
//  StampRowView.swift
//  CoffeeStampApp
//
//  Created by yoonie on 2/18/26.
//

import SwiftUI

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
                // TODO: FAV ACTION
            } label: {
                Image(systemName: "star")
                    .font(.title3)
                    .symbolVariant(.fill)
                    .foregroundStyle(.yellow)
            }

        }
    }
}
//
//#Preview {
//    StampRowView(index: 1)
//}
