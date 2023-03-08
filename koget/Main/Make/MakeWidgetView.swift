//
//  AddWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/22.
//

import SwiftUI
import SwiftEntryKit
import Localize_Swift

enum WidgetType {
    case image
}

struct MakeWidgetView: View {
    let navigationBarColor = AppColor.Background.second
    
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

    @State var successAlert = UIView()
    @State var errorAlert = UIView()

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                
                //MARK: - Background
                AppColor.Background.second
                    .ignoresSafeArea()
                Rectangle()
                    .foregroundColor(AppColor.Background.first)
                
                //MARK: - Contents
                VStack(spacing: 16) {
                    // 앱 리스트에서 가져오기
                    Button {
                        isAppPickerPresent.toggle()
                    } label: {
                        fetchAppListLabel
                    }
                    .frame(width: deviceSize.width - 32, height: 40)
                    .padding(.vertical)
                    .sheet(isPresented: $isAppPickerPresent) {
                        assetList
                    }
                    // 아이콘
                    ChooseImageMenuButton(viewModel: viewModel, appPicker: $assetList, widgetType: $widgetType)
                        .shadow(radius: 0.7, x: 0.1, y: 0.1)
                    
                    // 텍스트필드 그룹
                    MakeWidgetTextFieldView(viewModel: viewModel)

                    if viewModel.image != nil {
                        LinkWidgetOpacityPicker(viewModel: viewModel, isPresentQustionmark: $isPresentQustionmark)
                    }

                    makeAndBackButton
                        .padding(.horizontal, 16)
                        .alert("이미지 확인", isPresented: $isImageError) {
                            defaultImageCheckAlert
                        } message: {
                            Text("아직 이미지 아이콘이 없어요. \n기본 이미지로 생성할까요?")
                        }
                    Spacer()
                }
                .navigationTitle("위젯 만들기")
                .navigationBarTitleDisplayMode(.large)
            }
            .onTapGesture {
                hideKeyboard()
                isPresentQustionmark = false
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                assetList = WidgetAssetList(viewModel: viewModel)
                successAlert = setAlertView()
            }
        }
    }

    // MARK: - Assets

    var makeAndBackButton: some View {
        Group {
            // 위젯생성 버튼
            Button {
                makeWidgetAction()
            } label: {
                ButtonWithText(title: "완료", titleColor: .white, color: AppColor.Background.third)
            }
            // 돌아가기 버튼
            Button {
                self.dismiss()
            } label: {
                ButtonWithText(title: "돌아가기")
            }
        }
    }

    var defaultImageCheckAlert: some View {
        Group {
            Button("기본이미지로 생성") {
                viewModel.image = UIImage(named: "KogetClear")
                saveWidget()
            }
            Button("취소") {
                return
            }
        }
    }

    var fetchAppListLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Constants.kogetGradient)
                .shadow(color: .black.opacity(0.3), radius: 0.5, x: 1, y: 2)
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Constants.isDarkMode ? Color.black : Color.white)
                .opacity(0.15)

            Text("앱 리스트에서 가져오기")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 0.5, x: 1, y: 1)
        }
    }
    
    private func saveWidget() {
        viewModel.addWidget()
        self.dismiss()
    }

    private func makeWidgetAction() -> Void {
        viewModel.checkTheTextFields { error in
            if let error = error {
                if error == .emptyImage {
                    isImageError.toggle()
                } else {
                    // 실패
                    self.errorAlert = setErrorAlertView(subtitle: error.rawValue.localized())
                    self.presentErrorAlert()
                }
            } else {
                // 성공
                viewModel.addWidget()
                self.dismiss()
                self.displayToast()
            }
        }
    }

    private func setAlertView() -> UIView {
        return EKMaker.setToastView(title: "위젯 생성 완료!", subtitle: "코젯앱을 잠금화면에 추가해 사용하세요.", named: "success")
    }

    private func displayToast() {
        SwiftEntryKit.display(entry: successAlert, using: EKMaker.whiteAlertAttribute)
    }

    private func setErrorAlertView(subtitle: String) -> UIView {
        return EKMaker.setToastView(title: "확인 필요", subtitle: subtitle, named: "failed")
    }
    
    private func presentErrorAlert() {
        SwiftEntryKit.display(entry: errorAlert, using: EKMaker.whiteAlertAttribute)
    }
}

struct AddWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MakeWidgetView(assetList: WidgetAssetList(viewModel: MakeWidgetViewModel()))
        }
    }
}
