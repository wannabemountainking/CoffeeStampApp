//
//  UserDetailView.swift
//  CoffeeStampApp
//
//  Created by yoonie on 2/18/26.
//

import SwiftUI

struct UserDetailView: View {
    
    // Navigation SplitView에서 ipad 와 iphone 크기를 다르게 하기 위한 environment
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isiPhone: Bool {
        horizontalSizeClass == .compact
    }
    
    var body: some View {
        List {
            Text(isiPhone ? "아이폰" : "아이패드")
            
            Section("General") {
                LabeledContent {
                    Text("Test Name")
                } label: {
                    Text("Name")
                }
                LabeledContent {
                    Text("Test Company")
                } label: {
                    Text("Company")
                }
                LabeledContent {
                    Text("10")
                } label: {
                    Text("Total Free Coffee")
                }
            }//:SECTION
            
            Section("Stamp \(1)/7") {
                if isiPhone {
                    VStack(spacing: 20) {
                        HStack {
                            ForEach(1..<4, id: \.self) { index in
                                Image(systemName: "cup.and.saucer")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .onTapGesture {
                                        // TODO: SELECT COFFEE ACTION
                                    }
                                    .foregroundStyle(.accent)
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
                                        // TODO: SELECT COFFEE ACTION
                                    }
                                    .foregroundStyle(.accent)
                            } //:LOOP
                            .padding(.horizontal, 20)
                        } //:HSTACK
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Image(systemName: "cup.and.saucer.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.accent)
                            .onTapGesture {
                                // TODO: COUNT TOTAL FREE COFFEE ACTION
                            }
                    } //:VSTACK
                } else {
                    VStack(spacing: 30) {
                        HStack {
                            ForEach(1..<8, id: \.self) { index in
                                Image(systemName: "cup.and.saucer")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .onTapGesture {
                                        // TODO: SELECT COFFEE ACTION
                                    }
                                    .foregroundStyle(.accent)
                                    .padding(.horizontal, 3)
                            } //:LOOP
                            .padding(.horizontal, 20)
                        } //:HSTACK
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Image(systemName: "cup.and.saucer.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.accent)
                            .onTapGesture {
                                // TODO: COUNT TOTAL FREE COFFEE ACTION
                            }
                    } //:VSTACK
                }//:CONDITIONAL
            }//:SECTION
            
            Section("Notes") {
                Text("Test Notes")
            }//:SECTION
            
        } //:LIST
        .scrollContentBackground(.hidden) // Background Color 보이게 하기
        .background(Color.accent.opacity(0.5))
        .navigationTitle("Test Name")
        .navigationBarTitleDisplayMode(.inline)
    }//: body
}

#Preview {
    NavigationStack {
        UserDetailView()
    }
}
