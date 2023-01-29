//
//  ContactView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI

enum ContectType: String {
    case app = "앱 관련 문제"
    case addApp = "앱 추가요청"
    case feedback = "피드백 보내기"
    case etc = "기타 문의사항"
    case none = "선택하세요"
}

struct ContactView: View {
    
    @State var titleText: String = ""
    @State var bodyText: String = ""
    @State var isSuccess: Bool = false
    @State var isFailure: Bool = false
    
    @State var isPresentSendAlert = false
    @StateObject var viewModel = ContactViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        GeometryReader { (geometryProxy) in
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            
                            Text("문의 유형")
                            
                            Spacer()
                            
                            Menu {
                                Button {
                                    viewModel.contactType = .app
                                } label: {
                                    Text(ContectType.app.rawValue)
                                }
                                Button {
                                    viewModel.contactType = .addApp
                                    
                                } label: {
                                    Text(ContectType.addApp.rawValue)
                                }
                                Button {
                                    viewModel.contactType = .feedback
                                } label: {
                                    Text(ContectType.feedback.rawValue)
                                }
                                Button {
                                    viewModel.contactType = .etc
                                } label: {
                                    Text(ContectType.etc.rawValue)
                                }
                                
                                
                            } label: {
                                ZStack {
                                    
                                    if viewModel.contactType == .none {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundColor(.init(uiColor: .secondarySystemFill))
                                    }
                                    Text(viewModel.contactType.rawValue)
                                        .bold()
                                        .frame(width: DEVICE_SIZE.width / 1.5, height: 35)
                                        .foregroundColor(.black)
                                }
                            }
                            .frame(width: DEVICE_SIZE.width / 1.5, height: 35)
                            Spacer()
                            
                        }
                        
                        Divider()
                        TextFieldView(placeholder: "문의 제목", type: .title, text: $viewModel.title)
                            .padding([.top, .bottom], 8)
                        
                        Divider()
                        CustomTextEditor(placeHolder: "이곳에 문의내용을 입력하세요.", text: $viewModel.body)
                            .frame(height: geometryProxy.size.height / 2.5)
                            .padding([.top, .bottom], 8)
                        
                        
                        Button {
                            isPresentSendAlert.toggle()
                        } label: {
                            ButtonWithText(title: "문의 보내기")
                        }
                        .padding([.top, .bottom], 8)
                        Divider()
                        VStack(alignment: .leading, spacing: 8) {
                            Text("문의 안내사항")
                                .bold()
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("* 문의 내용에 개인정보를 입력하지 마세요.")
                                Text("* 문의는 익명으로 발송됩니다.")
                                Text("* 문의 내용은 앱 서비스 개선에 활용됩니다.")
                                Text("* 앱 개선을 위하여 기기의 버전정보를 수집합니다.")
                            }
                            .font(.system(size: 15))
                        }
                        .foregroundColor(.gray)
                        
                        
                        
                        
                        Spacer()
                        
                    }
                    
                    .padding(16)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("문의하기")
                        .bold()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text("코젯 버전")
                        Text("\(viewModel.version)")
                            .bold()
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toast(isPresented: $isSuccess, dismissAfter: 1.5, onDismiss: {
                dismiss()
            }) {
                ToastAlert(jsonName: .send, title: "문의 보내기 성공", subtitle: "피드백을 보내주셔서 감사합니다.")
            }
            .toast(isPresented: $isFailure, dismissAfter: 1.5, onDismiss: {

            }) {
                ToastAlert(jsonName: .error, title: "빈칸을 확인해주세요.", subtitle: nil)
            }
            .alert("내용 확인", isPresented: $isPresentSendAlert) {
                Button {
                    viewModel.checkTheField { result in
                        if result {
                            isSuccess.toggle()
                        } else {
                            isFailure.toggle()
                        }
                    }
                } label: {
                    Text("보내기")
                        .bold()
                }
                
                Button {
                    
                } label: {
                    Text("취소")
                }
            } message: {
                Text("문의를 보낼까요?")
            }

        }
        
    }
}


struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactView()
        }
    }
}

