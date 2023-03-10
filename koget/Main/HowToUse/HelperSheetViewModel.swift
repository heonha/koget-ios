//
//  HelperSheetViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/25.
//

import SwiftUI
import WelcomeSheet

struct WelcomeSheetContent {
    let title: LocalizedStringKey
    let rows: [WelcomeSheetContentRow]
    
    struct WelcomeSheetContentRow {
        let title: LocalizedStringKey
        let content: LocalizedStringKey
        let systemName: String
    }
}

class HelperSheetViewModel: ObservableObject {
    @Published var showWelcomeSheet = false
    @Published var showPatchNote = false
    @Published var showUseLockscreen = false
    @Published var showContactView = false
    @Published var showAssetRequestView = false
    @Published var showHowtoUseView = false


    let rawContents = [
        WelcomeSheetContent(title: "코젯을 소개합니다!", rows: [
            .init(title: "앱 바로가기", content: "자주 사용하는 앱을 등록하고 잠금화면에서 바로 실행할 수 있어요.", systemName: "arrow.up.forward.app.fill")
        ])
    ]
    
    static let shared = HelperSheetViewModel()
    
    private init() {
    }
    
    lazy var pages = [
        WelcomeSheetPage(title: String.localizedString("코젯을 소개합니다!") , rows: [
            WelcomeSheetPageRow(imageSystemName: "arrow.up.forward.app.fill",
                                accentColor: .red,
                                title: String.localizedString("앱 바로가기"),
                                content: String.localizedString("자주 사용하는 앱을 등록하고 잠금화면에서 바로 실행할 수 있어요.")),
            
            WelcomeSheetPageRow(imageSystemName: "network",
                                accentColor: .init(uiColor: .systemBlue),
                                title: String.localizedString("웹페이지 바로가기"),
                                content: String.localizedString("자주 들어가는 웹페이지 주소(URL)을 등록하면 웹 사이트도 바로 이동할 수 있어요")),
            
        ], mainButtonTitle: "다음".localized()),
        
        WelcomeSheetPage(title: String.localizedString("코젯의 특별한 점"), rows: [
            WelcomeSheetPageRow(imageSystemName: "ipad.and.iphone",
                                accentColor: .red,
                                title: String.localizedString("다양한 국내 앱 바로가기"),
                                content: String.localizedString("해외앱은 물론 국내에서 자주 사용하는 앱 바로가기를 탑재했어요")),
            
            WelcomeSheetPageRow(imageSystemName: "rectangle.and.pencil.and.ellipsis",
                                accentColor: .init(uiColor: .systemBlue),
                                title: String.localizedString("내 마음대로 커스텀"),
                                content: String.localizedString("바로가기 아이콘, URL을 내 마음대로 커스텀 할 수 있어요.")),
            
            WelcomeSheetPageRow(imageSystemName: "text.viewfinder",
                                accentColor: .black,
                                title: String.localizedString("연결되는 링크 URL 공개"),
                                content: String.localizedString("위젯 생성시 연결되는 URL을 볼 수 있어서 신뢰할 수 있는 링크인지 확인이 가능해요.")),
            
        ], mainButtonTitle: String.localizedString("코젯 시작하기"))
    ]
    
}

struct WelcomeSheetViewModel_Previews: PreviewProvider {
    static var previews: some View {
        
        Button {
            
        } label: {
            Text("실행")
        }
        .welcomeSheet(isPresented: .constant(true), pages: HelperSheetViewModel.shared.pages)
        
    }
}
