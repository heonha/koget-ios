//
//  URLTestButton.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI
import Localize_Swift

struct URLTestButton: View {
    
    var title: LocalizedStringKey = "URL 실행 테스트"

    @ObservedObject var viewModel: MakeWidgetViewModel

    // Error Alert
    var alertTitle: String = "URL 확인".localized()
    var alertMessage: String = "문자열 :// 이 반드시 들어가야합니다. \n(앱이름:// 또는 https://주소)".localized()
    @State var isAlertPresent: Bool = false
    
    var urlStringAlertTitle: String = "URL 확인".localized()
    var urlStringAlertMessage: String = "URL에 들어갈 수 없는 글자가 있습니다.".localized()
    @State var isurlStringAlertPresent: Bool = false

    // OpenURL Alert
    var openURLAlertTitle: LocalizedStringKey = "URL테스트"
    var openURLAlertMessage: LocalizedStringKey = "입력한 URL을 실행하시겠습니까?\n 성공 시 앱 또는 웹 브라우저로 연결됩니다."
    @State var targetURL: URL?
    @State var isOpenURLAlertPresent: Bool = false
    @State var canOpenResult: Bool?
    
    var body: some View {
        HStack {
            
            Spacer()
            if let canOpen = canOpenResult {
                if canOpen {
                    Text("실행성공")
                        .foregroundColor(.green)
                        .font(.system(size: 16, weight: .semibold))
                        
                } else {
                    Text("실행실패")
                        .foregroundColor(.red)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            
            //MARK: 테스트 버튼
            Button {
                
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
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .tint(.init(uiColor: .secondarySystemFill))
                    Text(title)
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                }
            }
            .frame(width: 120, height: 25)
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
    }
}

struct URLTestButton_Previews: PreviewProvider {
    static var previews: some View {
        URLTestButton(viewModel: MakeWidgetViewModel())
    }
}
