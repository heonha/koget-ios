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

    @State var widgetType: WidgetType = .image
    //Present Views
    @State var isAppPickerPresent = false
    @State var isPresentQustionmark = false

    @State var errorAlert = UIView()

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var constant: Constants

    var body: some View {
        
        GeometryReader { proxy in
            ScrollView {
                ZStack {

                    //MARK: - Background
                    AppColor.Background.second
                        .ignoresSafeArea(edges: .bottom)
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
                        // 위젯 아이콘
                        ChooseImageMenuButton(viewModel: viewModel, appPicker: $assetList, widgetType: $widgetType)
                            .shadow(radius: 0.7, x: 0.1, y: 0.1)
                            .padding(.horizontal, 16)
                        // 텍스트필드 그룹
                        MakeWidgetTextFieldView(viewModel: viewModel)
                            .padding(.horizontal, 16)

                        if viewModel.image != nil {
                            LinkWidgetOpacityPicker(viewModel: viewModel, isPresentQustionmark: $isPresentQustionmark)
                                .padding(.horizontal, 16)
                        }
                        // 만들기, 뒤로가기 버튼
                        makeAndBackButton
                            .padding(.horizontal, 16)
                            .alert("이미지 확인", isPresented: $viewModel.isImageError) {
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
                .onAppear {
                    assetList = WidgetAssetList(viewModel: viewModel)
                }
            }
        }
    }

    // MARK: - Assets

    var fetchAppListLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Constants.kogetGradient)
                .shadow(color: .black.opacity(0.3), radius: 0.5, x: 1, y: 2)
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(constant.isDarkMode ? Color.black : Color.clear)
                .opacity(0.15)

            Text("앱 리스트에서 가져오기")
                .font(.custom(CustomFont.NotoSansKR.medium, size: 18))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 0.5, x: 1, y: 1)
        }
    }

    var makeAndBackButton: some View {
        Group {
            // 위젯생성 버튼
            Button {
                viewModel.makeWidgetAction { result in
                    switch result {
                    case .success:
                        self.dismiss()
                    case .error:
                        return
                    }
                }
            } label: {
                ButtonWithText(title: "완료", titleColor: .white, color: AppColor.kogetBlue)
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
                viewModel.addWidget()
                dismiss()
            }
            Button("취소") {
                return
            }
        }
    }

}

struct AddWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MakeWidgetView(assetList: WidgetAssetList(viewModel: MakeWidgetViewModel()))
                .environmentObject(Constants.shared)
        }
    }
}
