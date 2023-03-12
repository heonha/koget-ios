//
//  URLTestButton.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI
import Localize_Swift

struct URLTestButton: View {
    
    var title: String = "테스트".localized()

    @ObservedObject var viewModel: MakeWidgetViewModel

    // Error Alert
    var alertTitle: String = "URL 확인".localized()
    var alertMessage: String = "문자열 :// 이 반드시 들어가야합니다. \n(앱이름:// 또는 https://주소)".localized()
    @State var isAlertPresent: Bool = false
    
    var urlStringAlertTitle: String = "URL 확인".localized()
    var urlStringAlertMessage: String = "URL에 들어갈 수 없는 글자가 있습니다.".localized()
    @State var isurlStringAlertPresent: Bool = false

    // OpenURL Alert
    var openURLAlertTitle: String = "URL 테스트".localized()
    var openURLAlertMessage: String = "입력한 URL을 실행하시겠습니까?\n 성공 시 앱 또는 웹 브라우저로 연결됩니다.".localized()

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
            .alert(alertTitle, isPresented: $isAlertPresent) {} message: {
                Text(alertMessage)
            }
            .alert(urlStringAlertTitle, isPresented: $isurlStringAlertPresent) {} message: {
                Text(urlStringAlertMessage)
            }
            .alert(openURLAlertTitle, isPresented: $isOpenURLAlertPresent) {
                
                Button("취소") {
                    
                }
                Button("URL실행") {
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
                    isAlertPresent.toggle()
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
