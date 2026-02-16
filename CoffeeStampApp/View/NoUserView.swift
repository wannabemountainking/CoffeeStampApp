//
//  NoUserView.swift
//  CoffeeStampApp
//
//  Created by YoonieMac on 2/19/26.
//

import SwiftUI

struct NoUserView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("😰 No Users")
                .font(.largeTitle.bold())
            Text("☝️ 위에 + 버튼을 눌러서 새로운 User를 추가하세요")
                .font(.callout)
        }
    }
}

#Preview {
    NoUserView()
}
