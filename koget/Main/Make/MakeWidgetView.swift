//
//  AddWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/22.
//

import SwiftUI

enum WidgetType {
    case image
}

struct MakeWidgetView: View {
    
    
    let navigationBarColor = AppColors.secondaryBackgroundColor
    
    @StateObject var viewModel = MakeWidgetViewModel()
    @State var assetList: WidgetAssetList?
    
    @State var iconImage: UIImage = UIImage(named: "plus.circle")!
    @State var isSuccess = false
    @State var isError: Bool = false
    @State var isImageError: Bool = false

    @State var errorMessage: String = ""
    @State var widgetType: WidgetType = .image
    
    //Present Views
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
                
                Button {
                    isAppPickerPresent.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(Constants.kogetGradient)
                        Text("앱 리스트에서 가져오기")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
                .frame(width: DEVICE_SIZE.width - 32, height: 40)
                .padding(.vertical)
                .sheet(isPresented: $isAppPickerPresent) {
                    assetList
                }
                
                ImageMenuButton(viewModel: viewModel, appPicker: $assetList, widgetType: $widgetType)
                        .shadow(radius: 0.7, x: 0.1, y: 0.1)
                
                // 텍스트필드 그룹
                MakeWidgetTextFieldView(viewModel: viewModel)
                    .padding(.bottom, 16)
                
                
                Group {
                    // 위젯생성 버튼
                    Button {
                        viewModel.checkTheTextFields { error in
                            if let error = error {
                                
                                if error == .emptyImage {
                                    isImageError.toggle()
                                    
                                } else {
                                    // 실패
                                    self.errorMessage = error.rawValue.localized()
                                    self.isError.toggle()
                                }
                  
                            } else {
                                // 성공
                                viewModel.addWidget()
                                self.dismiss()
                                MainWidgetViewModel.shared.makeSuccessful = true
                            }
                        }
                    } label: {
                        ButtonWithText(title: "완료", titleColor: .white, color: Color.secondary)
                    }
                    
                    .toast(isPresented: $isError, dismissAfter: 1.5) {
                        
                    } content: {
                        ToastAlert(jsonName: .error, title: errorMessage, subtitle: nil)
                    }

                    // 돌아가기 버튼
                    Button {
                        self.dismiss()
                    } label: {
                        ButtonWithText(title: "돌아가기")
                    }
                    
                }
                .padding(.horizontal, 16)
                .alert("이미지 확인", isPresented: $isImageError) {
                    
                    Button("기본이미지로 생성") {
                        viewModel.image = UIImage(named: "KogetClear")
                        print(viewModel.image)
                        saveWidget()
                    }
                    
                    Button("취소") {
                        return
                    }
                    

                } message: {
                    Text("아직 이미지 아이콘이 없어요. \n기본 이미지로 생성할까요?")
                }

                Spacer()
            }
            .navigationTitle("위젯 만들기")
        }
        //MARK: - Toolbar
        // .toolbar {
        //     ToolbarItem(placement: .principal) {
        //         ZStack {
        //             Text("위젯 만들기")
        //                 .font(.system(size: 20))
        //                 .fontWeight(.semibold)
        //                 .foregroundColor(AppColors.label)
        //         }
        //     }
        // }
        .onTapGesture {
            hideKeyboard()
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            assetList = WidgetAssetList(viewModel: viewModel)
        }
    }
    
    
    private func saveWidget() {
        viewModel.addWidget()
        self.dismiss()
        MainWidgetViewModel.shared.makeSuccessful = true
    }
}

struct AddWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MakeWidgetView(assetList: WidgetAssetList(viewModel: MakeWidgetViewModel()))
        }
    }
}



