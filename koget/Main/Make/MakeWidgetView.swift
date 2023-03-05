//
//  AddWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/22.
//

import SwiftUI
import SwiftEntryKit

enum WidgetType {
    case image
}

struct MakeWidgetView: View {
    let navigationBarColor = AppColors.secondaryBackgroundColor
    
    @StateObject var viewModel = MakeWidgetViewModel()
    @State var assetList: WidgetAssetList?
    
    @State var iconImage: UIImage = UIImage(named: "plus.circle")!
    @State var isSuccess = false
    @State var isError = false
    @State var isImageError = false
    @State var errorMessage = ""
    @State var widgetType: WidgetType = .image
    //Present Views
    @State var isAppPickerPresent = false
    @State var isPresentQustionmark = false

    @State var toastUIView = UIView()
    
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
                    .frame(width: deviceSize.width - 32, height: 40)
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
                                    self.displayToast()
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
                toastUIView = EKMaker.setToastView(title: "위젯 생성 완료!", subtitle: "코젯앱을 잠금화면에 추가해 사용하세요.", named: "success")
            }

        }
    }
    
    private func saveWidget() {
        viewModel.addWidget()
        self.dismiss()
    }

    func displayToast() {
        SwiftEntryKit.display(entry: toastUIView, using: EKMaker.whiteAlertAttribute)
    }
}

struct AddWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MakeWidgetView(assetList: WidgetAssetList(viewModel: MakeWidgetViewModel()))
        }
    }
}
