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
    
    var urlStringAlertTitle: String = S.UrlTestButton.checkUrl
    var urlStringAlertMessage: String = S.UrlTestButton.checkUrlSubtitleNourl
    var addWebScheme: String = "웹페이지"
    var addAppScheme: String = "앱"

    @State var isurlStringAlertPresent: Bool = false

    // OpenURL Alert
    var openURLAlertTitle: String = S.UrlTestButton.testUrl
    var openURLAlertMessage: String = S.UrlTestButton.checkRun

    @State var targetURL: URL?
    @State var isOpenURLAlertPresent: Bool = false
    @State var canOpenResult: Bool?
    
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
                    .frame(width: 100, height: 25)

                } else {
                    HStack {
                        resultTextView
                    }
                    .frame(width: 25, height: 25)
                }
            }
            .alert(alertTitle, isPresented: $isSchemeErrorAlertPresent) {
                Button("앱 (주소://)") {
                    viewModel.url = viewModel.url + "://"
                }
                Button("웹페이지 (https://)") {
                    viewModel.url = "https://" + viewModel.url
                }
                Button("취소") {

                }
            } message: {
                Text(alertMessage)
            }
            .alert(urlStringAlertTitle, isPresented: $isurlStringAlertPresent) {} message: {
                Text(urlStringAlertMessage)

                Button(S.UrlTestButton.runTest) {
                    viewModel.openURL { result in
                        // print(result)
                        self.canOpenResult = result
                    }
                }
            }
            .alert(openURLAlertTitle, isPresented: $isOpenURLAlertPresent) {
                
                Button(S.Button.cancel) {
                    
                }
                Button(S.UrlTestButton.runTest) {
                    viewModel.openURL { result in
                        // print(result)
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
