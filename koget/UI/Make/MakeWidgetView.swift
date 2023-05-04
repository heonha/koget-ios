//
//  AddWidgetView.swiftplus.circle
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
    let navigationBarColor = AppColor.Background.second
    
    @StateObject var viewModel = MakeWidgetViewModel()
    @EnvironmentObject var constant: AppStateConstant
    @EnvironmentObject var coreData: WidgetCoreData
    
    @Environment(\.dismiss) var dismiss

    @State var assetList: WidgetAssetList?
    @State var widgetType: WidgetType = .image
    //Present Views
    @State var isAppPickerPresent = false
    @State var isPresentQustionmark = false
    @State var errorAlert = UIView()
    @State var isSchemeErrorAlertPresent: Bool = false

    let navigationTitle = "위젯 만들기"
    let namePlaceholder: String = "위젯 이름"
    let urlPlaceholder: String = "URL - (특수문자 :// 포함)"
    var alertTitle: String = "URL 확인"
    var alertMessage: String = "URL에 문자 ://이 없습니다.\n아래 타입을 누르면 자동으로 교정됩니다."

    var body: some View {
        ScrollView {
            ZStack {
                AppColor.Background.second
                    .ignoresSafeArea(edges: .bottom)
                Rectangle()
                    .foregroundColor(AppColor.Background.first)

                VStack(spacing: 16) {
                    fetchAppListLabel
                        .sheet(isPresented: $isAppPickerPresent) {
                            WidgetAssetList(viewModel: viewModel)
                        }
                    Spacer()

                    PhotoEditMenu(isEditingMode: .constant(true), viewModel: viewModel)
                        .shadow(radius: 0.7, x: 0.1, y: 0.1)

                    VStack(spacing: 8) {
                        EditTextField(systemSymbol: .tag, placeHolder: namePlaceholder, viewModel: viewModel, text: $viewModel.name)

                        urlTextField
                    }

                    // Opacity Picker
                    opacityPicker

                    Spacer()
                    
                    // 만들기, 뒤로가기 버튼
                    makeAndBackButton

                    Spacer()
                }
                .padding(.horizontal, 16)
                .navigationTitle(navigationTitle)
                .navigationBarTitleDisplayMode(.large)
                .animation(.easeOut(duration: 0.2), value: viewModel.moreOptionOn)
            }
            .onTapGesture {
                hideKeyboard()
                isPresentQustionmark = false
            }
        }
    }

    // MARK: - Views

    var fetchAppListLabel: some View {
        Button {
            isAppPickerPresent.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Constants.kogetGradient)
                    .shadow(color: .black.opacity(0.3), radius: 0.5, x: 1, y: 2)

                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(constant.isDarkMode ? Color.black : Color.gray)
                    .opacity(0.5)

                Text(S.MakeWidgetView.fetchAppListLabel)
                    .font(.custom(CustomFont.NotoSansKR.medium, size: 18))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 0.5, x: 1, y: 1)
            }
        }
        .frame(width: Constants.deviceSize.width - 32, height: 40)
        .padding(.vertical)
    }

    var urlTextField: some View {
        HStack {
            EditTextField(systemSymbol: .link,
                          placeHolder: urlPlaceholder,
                          trailingPadding: viewModel.url.isEmpty ? 82 : nil,
                          viewModel: viewModel,
                          text: $viewModel.url)
            .overlay {
                if !viewModel.url.isEmpty {
                    withAnimation {
                        HStack {
                            Spacer()
                            URLTestButton(viewModel: viewModel)
                        }
                    }
                }
            }
        }
    }

    var opacityPicker: some View {
        ZStack {
            if viewModel.image != nil {
                if !viewModel.moreOptionOn {
                    moreOptionButton
                } else {
                    OpacityPickerContainer(viewModel: viewModel, isPresentQustionmark: $isPresentQustionmark)
                }
            }
        }
    }

    var doneButton: some View {
        TextButton(title: S.Button.finish, titleColor: .white, backgroundColor: AppColor.kogetBlue) {
            viewModel.makeWidgetAction { result in

                if let result = result {
                    switch result {
                    case .urlError:
                        isSchemeErrorAlertPresent.toggle()
                        return
                    default:
                        return
                    }
                } else {
                    self.dismiss()
                    return
                }

            }
        }
    }

    var makeAndBackButton: some View {
        Group {
            // 위젯생성 버튼
            doneButton
                .alert(alertTitle, isPresented: $isSchemeErrorAlertPresent) {
                    Button("앱 (주소://)") {
                        viewModel.url = viewModel.url + "://"
                    }
                    Button("웹페이지 (https://)") {
                        viewModel.url = "https://" + viewModel.url
                    }
                    Button("취소") {

                    }
                } message: {
                    Text(alertMessage)
                }
                .alert("이미지 확인", isPresented: $viewModel.isImageError) {
                    defaultImageCheckAlertView
                } message: {
                    Text("아직 이미지 아이콘이 없어요. \n기본 이미지로 생성할까요?")
                }

            TextButton(title: "뒤로가기",
                       titleColor: AppColor.Label.first,
                       backgroundColor: AppColor.Fill.first) {
                self.dismiss()
            }
        }
    }

    var defaultImageCheckAlertView: some View {
        Group {
            Button("기본이미지로 생성") {
                viewModel.image = UIImage(named: "KogetClear")
                viewModel.addWidget()
                dismiss()
            }

            Button(S.Button.cancel) {

            }
        }
    }

    var moreOptionButton: some View {
        HStack {
            Spacer()
            Button {
                viewModel.moreOptionOn.toggle()
            } label: {
                ZStack {
                    Text("투명도 조절")
                        .font(.custom(CustomFont.NotoSansKR.medium, size: 14))
                        .foregroundColor(AppColor.Label.second)
                        .padding(4)
                }
                .background(AppColor.Background.second)
                .cornerRadius(5)
            }
        }
    }

    func addWidget() {
        
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
