//
//  MakeWidgetOnboarding.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI

struct MakeWidgetOnboarding: View {
    var body: some View {
        VStack {
            Text("위젯 만들기 버튼을 눌러 위젯을 만듭니다.")
            Text("사전 구성된 앱을 불러올 수도 있으며, 사용자 임의로 추가할 수도 있어요.")
            Text("만든 위젯은 배경화면 편집화면에서 추가할 수 있어요.")
            Text("앱 실행, 원하는 웹페이지 등 URL만 알고있다면 무엇이든 할 수 있어요. ")
            Text("위젯을 삭제하는 방법은 이 버튼을 누르세요.")
        }
    }
}

struct MakeWidgetOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        MakeWidgetOnboarding()
    }
}
