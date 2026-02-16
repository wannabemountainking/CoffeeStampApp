//
//  MainView.swift
//  CoffeeStampApp
//
//  Created by YoonieMac on 2/16/26.
//

import SwiftUI

struct MainView: View {
    
    // MARK: - Property
    // Core Data fetch 해오기 @FetchRequest 사용
    @FetchRequest(fetchRequest: Stamp.all()) private var stamps
    // ViewModel 연결
    @EnvironmentObject private var vm: StampViewModel
    // provider 연결
    var provider = StampProvider.shared
    
    // MARK: - STATE
    // selected Single item and add, edit stamp
    @State private var selectedItem: Stamp?
    @State private var stampToEdit: Stamp?
    
    // MARK: - Body
    var body: some View {
        NavigationSplitView {
            // View
            ZStack {
                if stamps.isEmpty {
                    NoUserView()
                } else {
                    List {
                        ForEach(stamps) { stamp in
                            NavigationLink {
                                // Destination -> UserDetailView()
                                UserDetailView()
                            } label: {
                                // Label -> StampRowView()
                                StampRowView(vm: .init(provider: provider, stamp: stamp))
                                    .swipeActions(edge: .leading) {
                                        // TODO: DELETE ACTION
                                    }//: SwipeAction
                                    .swipeActions(edge: .trailing) {
                                        // TODO: EDIT ACTION
                                    }//: SwipeAction
                            } //:NavLink
                        } //:LOOP
                        // LIST 배경 설정
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.accent.opacity(0.5))
                                .padding(.vertical, 5)
                        )
                    } //:LIST
                }// CONDITIONAL(stamps가 비어있을 때와 아닐따)
            } //:ZSTACK
            .navigationTitle("Coffee Stamp")
            .toolbar {
                // ADD BUTTON
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // TODO: ADD ACTION
                        stampToEdit = .empty(context: provider.newContext)
                    } label: {
                        Image(systemName: "plus")
                            .symbolVariant(.circle)
                            .font(.title2)
                    }
                    .tint(.accent)
                }
                
                //Fav Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: FAV ACTION
                    } label: {
                        Image(systemName: "star.fill")
                            .font(.title2)
                    }
                    .tint(.yellow)
                }
                
                // Sort Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: Sort Action
                    } label: {
                        Image(systemName: "arrow.up")
                            .symbolVariant(.circle)
                            .font(.title2)
                    }
                    .tint(.mint)
                }
            } //:TOOLBAR
            .sheet(item: $stampToEdit) {
                // dismiss
                stampToEdit = nil
            } content: { stamp in
                NavigationStack {
                    CreateUserView(vm: .init(provider: provider, stamp: stamp))
                }
            }

        } detail: {
            // Navigation Link를 눌렀을 때 View -> value 값을 넘겨줘야 되는데 여기서는 NavigationLink를 사용해서 넘겨줘야 하기 때문에 detail 사용 안함
        }//: Navigation

    }//: body
}

//#Preview {
//    MainView()
//}
