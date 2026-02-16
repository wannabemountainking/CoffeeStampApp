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
    @EnvironmentObject var vm: StampViewModel
    // provider 연결
    var provider = StampProvider.shared
    
    // MARK: - STATE
    // selected Single item and add, edit stamp
    @State var selectedItem: Stamp?
    @State var stampToEdit: Stamp?
    
    // Fav
    @State var isFav: Bool = false
    @State private var favConfig: FavConfig = .init()
    
    // Sort
    @State private var sort: Sort = .asc
    @State private var isAsc: Bool = false
    
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
                                UserDetailView(vm: .init(provider: provider, stamp: stamp))
                            } label: {
                                // Label -> StampRowView()
                                StampRowView(vm: .init(provider: provider, stamp: stamp))
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        // DELETE ACTION
                                        Button {
                                            // action
                                            do {
                                                // 이미 viewContext에서 태어난 stamp를 지울 때는 같은 집(viewContext) 에서 지워야 한다.
                                                // newContext는 새 물건을 만드는 작업대
                                                // viewContext 는 현재 화면에 올라와 있는 진열대
                                                try provider.delete(stamp: stamp, context: provider.viewContext)
                                            } catch {
                                                print("ERROR DELETING DATA: \(error)")
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(.red)

                                    }//: SwipeAction
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        // EDIT ACTION
                                        Button {
                                            //action
                                            stampToEdit = stamp
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                    }//: SwipeAction
                            } //:NavLink
                        } //:LOOP
                        // LIST 배경 설정
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.accentColor.opacity(0.5))
                                .padding(.vertical, 5)
                        )
                    } //:LIST
                }// CONDITIONAL(stamps가 비어있을 때와 아닐따)
            } //:ZSTACK
            .navigationTitle("Coffee Stamp")
            .toolbar {
                // ADD BUTTON
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // TODO: ADD ACTION
                        stampToEdit = .empty(context: provider.newContext)
                    } label: {
                        Image(systemName: "plus")
                            .symbolVariant(.circle)
                            .font(.title2)
                    }
                }
                
                //Fav Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // FAV ACTION
                        if isFav {
                            favConfig.filter = FavConfig.Filter.all
                            isFav.toggle()
                        } else {
                            favConfig.filter = FavConfig.Filter.fave
                            isFav.toggle()
                        }
                    } label: {
                        Image(systemName: isFav ? "star.fill" : "star")
                            .font(.title2)
                    }
                    .tint(.yellow)
                }
                
                // Sort Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Sort Action
                        if isAsc {
                            sort = Sort.asc
                            isAsc.toggle()
                        } else {
                            sort = Sort.dec
                            isAsc.toggle()
                        }
                    } label: {
                        Image(systemName: isAsc ? "arrow.up" : "arrow.down")
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
            .onChange(of: favConfig) { newFav in
                stamps.nsPredicate = Stamp.favFilter(config: newFav)
            }
            .onChange(of: sort) { newSort in
                stamps.nsSortDescriptors = Stamp.sort(order: newSort)
            }

        } detail: {
            // Navigation Link를 눌렀을 때 View -> value 값을 넘겨줘야 되는데 여기서는 NavigationLink를 사용해서 넘겨줘야 하기 때문에 detail 사용 안함
        }//: Navigation

    }//: body
}

//#Preview {
//    MainView()
//}
