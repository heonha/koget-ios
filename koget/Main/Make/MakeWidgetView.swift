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
    @State var isPresentQustionmark: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        
        GeometryReader { proxy in
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
                    
                    LinkWidgetOpacityPicker(viewModel: viewModel, isPresentQustionmark: $isPresentQustionmark)

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

            .onTapGesture {
                hideKeyboard()
                isPresentQustionmark = false
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                assetList = WidgetAssetList(viewModel: viewModel)
            }
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




struct LinkWidgetOpacityPicker: View {
    
    @StateObject var viewModel: MakeWidgetViewModel
    var pickerWidthRatio: CGFloat = 0.5
    @Binding var isPresentQustionmark: Bool
    
    var body: some View {
        
        
        HStack {
            Text("투명도")
                .font(.system(size: 20, weight: .bold))
            Button {
                isPresentQustionmark.toggle()
            } label: {
                Image(systemName: "questionmark.circle")
                    .foregroundColor(.gray)
            }
            .overlay(
                GeometryReader { geometry in
                    ZStack(content: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)

                        Text("잠금화면에서의 아이콘 투명도입니다.")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                    })
                    .frame(idealWidth: max(geometry.size.width, 250), idealHeight: 30)
                    .offset(x: -110, y: -40)
                    .opacity(
                        isPresentQustionmark ? 0.7 : 0.0
                    )
                .animation(.linear(duration: 0.2), value: isPresentQustionmark)
                }
            )
            
           
            Spacer()
            OpacityPicker(viewModel: viewModel, widthRatio: pickerWidthRatio, type: .make)
            Spacer()
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .grayscale(1)
                    .clipShape(Circle())
                    .opacity(viewModel.opacityValue ?? 1.0)
                    .opacity(0.7)
            }
            
            
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        
        .padding(.bottom, 16)
    }
}
