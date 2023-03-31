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
    @State var assetList: WidgetAssetList?
    @State var widgetType: WidgetType = .image
    //Present Views
    @State var isAppPickerPresent = false
    @State var isPresentQustionmark = false
    @State var errorAlert = UIView()

    let namePlaceholder: String = S.Textfield.Placeholder.widgetName
    let urlPlaceholder: String = S.Textfield.Placeholder.url

    var alertTitle: String = S.UrlTestButton.checkUrl
    var alertMessage: String = S.UrlTestButton.checkUrlSubtitleSpecific
    @State var isSchemeErrorAlertPresent: Bool = false

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var constant: Constants

    var body: some View {
        
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

                    Spacer()

                    // 위젯 아이콘
                    PhotoEditMenu(isEditingMode: .constant(true), viewModel: viewModel)
                        .shadow(radius: 0.7, x: 0.1, y: 0.1)
                        .padding(.horizontal, 16)
                    // 텍스트필드 그룹
                    VStack(spacing: 8) {
                        EditTextField(systemSymbol: .tag, placeHolder: namePlaceholder, viewModel: viewModel, text: $viewModel.name)

                        EditTextField(systemSymbol: .link, placeHolder: urlPlaceholder, viewModel: viewModel, text: $viewModel.url)
                            .overlay {
                                if viewModel.url != "" {
                                    withAnimation {
                                        HStack {
                                            Spacer()
                                            URLTestButton(viewModel: viewModel)
                                        }
                                    }
                                }
                            }
                    }
                    .padding(.horizontal, 16)

                    // Opacity Picker
                    if viewModel.image != nil {
                        if !viewModel.moreOptionOn {
                            moreOptionButton
                                .padding(.horizontal, 16)
                        } else {
                            OpacityPickerContainer(viewModel: viewModel, isPresentQustionmark: $isPresentQustionmark)
                                .padding(.horizontal, 16)
                        }
                    }

                    Spacer()
                    
                    // 만들기, 뒤로가기 버튼
                    makeAndBackButton
                        .padding(.horizontal, 16)

                    Spacer()
                }
                .navigationTitle(S.MakeWidgetView.navigationTitle)
                .navigationBarTitleDisplayMode(.large)
                .animation(.easeOut(duration: 0.2), value: viewModel.moreOptionOn)
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

    // MARK: - Views

    var fetchAppListLabel: some View {
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

    var makeAndBackButton: some View {
        Group {
            // 위젯생성 버튼
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
            .alert(alertTitle, isPresented: $isSchemeErrorAlertPresent) {
                Button(S.Alert.Scheme.app) {
                    viewModel.url = viewModel.url + "://"
                }
                Button(S.Alert.Scheme.web) {
                    viewModel.url = "https://" + viewModel.url
                }
                Button(S.Button.cancel) {

                }
            } message: {
                Text(alertMessage)
            }
            .alert(S.MakeWidgetView.IsImageError.title, isPresented: $viewModel.isImageError) {
                defaultImageCheckAlertView
            } message: {
                Text(S.MakeWidgetView.IsImageError.message)
            }

            // 돌아가기 버튼
            TextButton(title: S.Button.goBack,
                       titleColor: AppColor.Label.first,
                       backgroundColor: AppColor.Fill.first) {
                self.dismiss()

            }
        }
    }

    var defaultImageCheckAlertView: some View {
        Group {
            Button(S.MakeWidgetView.IsImageError.okButton) { // 기본이미지로 생성
                viewModel.image = UIImage(named: "KogetClear")
                viewModel.addWidget()
                dismiss()
            }
            Button(S.Button.cancel) {
                return
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
                    Text(S.Button.changeOpacity)
                        .font(.custom(CustomFont.NotoSansKR.medium, size: 14))
                        .foregroundColor(AppColor.Label.second)
                        .padding(4)
                }
                .background(AppColor.Background.second)
                .cornerRadius(5)
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
