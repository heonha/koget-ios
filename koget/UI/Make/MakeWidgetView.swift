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
    @EnvironmentObject var coreData: DeepLinkManager
    
    @Environment(\.dismiss) var dismiss

    @State var assetList: WidgetAssetList?
    @State var widgetType: WidgetType = .image
    //Present Views
    @State var isAppPickerPresent = false
    @State var isPresentQustionmark = false
    @State var errorAlert = UIView()
    @State var isSchemeErrorAlertPresent: Bool = false

    let navigationTitle = S.MakeWidgetView.navigationTitle
    let namePlaceholder: String = S.Textfield.Placeholder.widgetName
    let urlPlaceholder: String = S.Textfield.Placeholder.url
    var alertTitle: String = S.UrlTestButton.checkUrl
    var alertMessage: String = S.UrlTestButton.checkUrlSubtitleSpecific

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
        TextButton(title: S.Button.finish, titleColor: .white, backgroundColor: AppColor.Accent.primary) {
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

            TextButton(title: S.Button.goBack,
                       titleColor: AppColor.Label.first,
                       backgroundColor: AppColor.Fill.first) {
                self.dismiss()
            }
        }
    }

    var defaultImageCheckAlertView: some View {
        Group {
            Button(S.MakeWidgetView.IsImageError.okButton) {
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
