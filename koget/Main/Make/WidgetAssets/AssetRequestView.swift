//
//  AssetRequestView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/19.
//

import SwiftUI
import ToastUI

struct AssetRequestView: View {
    
    @State var isSuccess: Bool = false
    @State var isFailure: Bool = false

    
    @ObservedObject var viewModel = AssetRequestViewModel()

    @Environment(\.dismiss) var dismiss
    var body: some View {

        VStack {
            
            Text("앱/웹 추가 요청")
                .font(.system(size: 20))
                .fontWeight(.bold)
            Divider()
            
            
            
            //MARK: 앱 이름
            HStack {
                Spacer()
                Text("앱/웹 이름")
                    .bold()
                    .frame(width: 100)
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.init(uiColor: .secondarySystemFill))
                        .opacity(0.8)
                    TextField("요청할 앱/웹 이름", text: $viewModel.appName)
                        .padding(.horizontal, 4)
                        .background(Color.clear)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textCase(.none)
                }
                .padding(.trailing, 16)
                .padding(.vertical, 4)
                
            }
            .frame(height: 50)
            
            //MARK: 앱 이름
            HStack {
                Spacer()
                
                Text("내용")
                    .bold()
                    .frame(width: 100)
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.init(uiColor: .secondarySystemFill))
                        .opacity(0.8)
                    TextField("선택사항", text: $viewModel.body)
                        .padding(.horizontal, 4)
                        .background(Color.clear)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textCase(.none)
                }
                .padding(.trailing, 16)
                .padding(.vertical, 4)
                
            }
            .frame(height: 50)
            
            
            Text("요청하신 앱/웹은 검토 결과에 따라 앱에 추가 될 예정입니다.")
                .font(.system(size: 13))
                .padding()
            
            
            Button {
                viewModel.checkTheField { result in
                    switch result {
                    case true:
                        self.isSuccess.toggle()
                    case false:
                        self.isFailure.toggle()
                    }
                }
            } label: {
                ButtonWithText(title: "요청하기", titleColor: .white, color: Color("Navy"))
                
            }
            .padding(.horizontal, 24)
                
                Spacer()
                
                
            }
            .padding(.vertical)
            .presentationDetents([.medium])
            .onTapGesture {
                hideKeyboard()
            }
            .toast(isPresented: $isSuccess, dismissAfter: 1.3, onDismiss: {
                dismiss()
            }) {
                ToastAlert(jsonName: .send, title: "앱/웹 추가요청 성공", subtitle: "요청을 보내주셔서 감사합니다.")
            }
            .toast(isPresented: $isFailure, dismissAfter: 1.0, onDismiss: {

            }) {
                ToastAlert(jsonName: .error, title: "앱/웹 이름을 기재해주세요.", subtitle: nil)
            }

    }
}

struct AssetRequestView_Previews: PreviewProvider {
    static var previews: some View {
        AssetRequestView()
    }
}
