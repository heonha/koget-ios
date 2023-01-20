//
//  AddWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/22.
//

import SwiftUI

struct MakeWidgetView: View {
    
    
    let navigationBarColor = AppColors.secondaryBackgroundColor
    
    @StateObject var viewModel = MakeWidgetViewModel()
    @State var assetList: WidgetAssetList?
    
    @State var iconImage: UIImage = UIImage(named: "plus.circle")!
    @State var alertTitle = (error: "입력확인", success: "생성 완료")
    @State var alertErrorMessage: String = ""
    var alertSuccessMessage = "잠금화면에 위젯을 추가하세요."

    @State var isErrorAlert: Bool = true
    
    
    //Present Views
    @State var isAlertPresent: Bool = false
    @State var isAppPickerPresent: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack {
            
            //MARK: - Background
            AppColors.secondaryBackgroundColor
                .ignoresSafeArea()
            Rectangle()
                .foregroundColor(AppColors.backgroundColor)

            
            //MARK: - Contents
            VStack(spacing: 16) {
                // 이미지 선택 메뉴
                
                ImageMenuButton(viewModel: viewModel, appPicker: $assetList)
                        .shadow(radius: 0.7, x: 0.1, y: 0.1)
                        .padding()
                
                // 텍스트필드 그룹
                MakeWidgetTextFieldView(viewModel: viewModel)
                
                // 위젯생성 버튼
                Button {
                    viewModel.checkTheTextFields { error in
                        if let error = error {
                            self.alertErrorMessage = error.rawValue
                            self.isAlertPresent.toggle()
                        } else {
                            viewModel.addWidget()
                            self.isErrorAlert = false
                            self.isAlertPresent.toggle()
                        }
                    }
                } label: {
                    ButtonWithText(title: "완료", titleColor: .white, color: .secondary)
                }
                .alert(isErrorAlert ? alertTitle.error : alertTitle.success, isPresented: $isAlertPresent)
                {
                    if isErrorAlert == false {
                        Button("확인") {
                            self.dismiss()
                        }
                    }
                } message: {
                    if isErrorAlert == true {
                        Text(alertErrorMessage)
                    } else {
                        Text(alertSuccessMessage)
                    }
                }


                // 돌아가기 버튼
                Button {
                    self.dismiss()
                } label: {
                    ButtonWithText(title: "돌아가기")
                }
                Spacer()
            }
        }
        //MARK: - Toolbar
        .toolbar {
            ToolbarItem(placement: .principal) {
                ZStack {
                    Text("위젯 만들기")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.label)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isAppPickerPresent.toggle()
                } label: {
                    Text("앱 가져오기")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("Navy"))
                }
                .sheet(isPresented: $isAppPickerPresent) {
                    assetList
                }
                
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear {
            assetList = WidgetAssetList(viewModel: viewModel)
        }
    }
}

struct AddWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MakeWidgetView(assetList: WidgetAssetList(viewModel: MakeWidgetViewModel()))
        }
    }
}



