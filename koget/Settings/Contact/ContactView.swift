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
    case etc = "기타 유형"
    case none = "선택하세요"
}

struct ContactView: View {
    
    
    @State var titleText: String = ""
    @State var bodyText: String = ""
    
    @State var isPresentSendAlert = false
    @StateObject var viewModel = ContactViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        GeometryReader { geometryProxy in
            ZStack {
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
                        .frame(height: geometryProxy.size.height / 2)
                        .padding([.top, .bottom], 8)
                    
                    
                    Button {
                        isPresentSendAlert.toggle()
                    } label: {
                        ButtonWithText(title: "문의 보내기")
                    }
                    .padding([.top, .bottom], 8)
                    .alert("내용 확인", isPresented: $isPresentSendAlert) {
                        Button {
                            viewModel.checkTheField()
                            self.dismiss()
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
                    
                    Spacer()

                }
                
                .padding(16)
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

