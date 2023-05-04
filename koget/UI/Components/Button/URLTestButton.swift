//
//  URLTestButton.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI

struct URLTestButton: View {
    
    var title: String = S.Button.test

    @ObservedObject var viewModel: MakeWidgetViewModel

    // Error Alert
    var alertTitle: String = S.UrlTestButton.checkUrl
    var alertMessage: String = S.UrlTestButton.checkUrlSubtitleSpecific
    @State var isSchemeErrorAlertPresent: Bool = false

    // OpenURL Alert
    var openURLAlertTitle: String = S.UrlTestButton.testUrl
    var openURLAlertMessage: String = S.UrlTestButton.checkRun

    // Auto add scheme mark
    let appSchemeLabel: String = S.Alert.Scheme.app
    let webSchemeLabel: String = S.Alert.Scheme.web
    let cancelLabel: String = S.Button.cancel

    @State var targetURL: URL?
    @State var isOpenURLAlertPresent: Bool = false
    @State var canOpenResult: Bool?
    @State var previousURL: String?
    
    var body: some View {
        HStack {
            Spacer()
            //MARK: 테스트 버튼
            Button {
                urlCheckAction()
            } label: {
                if canOpenResult == nil {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(AppColor.Background.second)
                            .opacity(0.95)
                            .shadow(color: .black.opacity(0.2), radius: 0.5, x: 1, y: 1)
                        Text(title)
                            .foregroundColor(AppColor.Label.first)
                            .font(.custom(CustomFont.NotoSansKR.medium, size: 16))
                    }

                } else {
                    HStack(alignment: .center) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(AppColor.Background.second)
                                .opacity(0.95)
                                .shadow(color: .black.opacity(0.2), radius: 0.5, x: 1, y: 1)
                            resultTextView
                        }
                    }
                }
            }
            .frame(width: 80, height: 25)
            // Scheme mark 추가 알럿
            .alert(alertTitle, isPresented: $isSchemeErrorAlertPresent) {
                Button(appSchemeLabel) { // 앱
                    viewModel.url = viewModel.url + "://"
                }
                Button(webSchemeLabel) { // 웹페이지
                    viewModel.url = "https://" + viewModel.url
                }
                Button(cancelLabel) { } // 취소
            } message: {
                Text(alertMessage)
            }
            // 테스트진행 선택지 알럿
            .alert(openURLAlertTitle, isPresented: $isOpenURLAlertPresent) {
                
                Button(S.Button.cancel) { } // 취소
                Button(S.UrlTestButton.runTest) { // 진행
                    previousURL = viewModel.url // 테스트 URL 저장
                    viewModel.openURL { result in
                        self.canOpenResult = result
                    }
                }
            } message: {
                Text(openURLAlertMessage) 
            }
        }
        .padding(4)
    }

    var resultTextView: some View {
        ZStack {
            if previousURL == viewModel.url {
                if let canOpen = canOpenResult {
                    if canOpen {
                        Image(systemSymbol: .checkmarkCircleFill)
                            .foregroundColor(.green)
                            .font(.custom(CustomFont.NotoSansKR.medium, size: 20))
                    } else {
                        Image(systemSymbol: .xmarkCircle)
                            .foregroundColor(.red)
                            .font(.custom(CustomFont.NotoSansKR.medium, size: 20))
                    }
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(AppColor.Background.second)
                        .opacity(0.95)
                        .shadow(color: .black.opacity(0.2), radius: 0.5, x: 1, y: 1)
                    Text(title)
                        .foregroundColor(AppColor.Label.first)
                        .font(.custom(CustomFont.NotoSansKR.medium, size: 16))
                }
            }
        }
    }

    func urlCheckAction() {
        viewModel.checkCanOpenURL { error in
            if let error = error {
                // print(error)
                switch error {
                case .openError:
                    isOpenURLAlertPresent.toggle()
                case .typeError:
                    isSchemeErrorAlertPresent.toggle()
                }
            } else {
                isOpenURLAlertPresent.toggle()
            }
        }
    }

}

struct URLTestButton_Previews: PreviewProvider {
    static var previews: some View {
        URLTestButton(viewModel: MakeWidgetViewModel())
    }
}
