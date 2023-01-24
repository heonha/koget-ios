//
//  HowToUseMenus.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/24.
//

import SwiftUI

struct HowToUseMenus: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                List {
                    NavigationLink("소개화면 다시보기") {
                        OnboardingPageView()
                    }
                    NavigationLink("만든 위젯을 잠금화면에 등록하는 방법") {
                        LockscreenHelper()
                    }
                }
                .listStyle(.insetGrouped)

            }
            .navigationTitle("도움말")
        }
        .tint(.black)
    }
}

struct HowToUseMenus_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseMenus()
    }
}
