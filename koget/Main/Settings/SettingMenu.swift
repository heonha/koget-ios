//
//  HowToUseMenus.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/24.
//

import SwiftUI
import WelcomeSheet
import SFSafeSymbols

struct SettingMenu: View, AppStoreReviewable {
    
    @ObservedObject var viewModel = HelperSheetViewModel.shared
    @EnvironmentObject var constant: Constants

    @State var widgetSizeTitle = "선택"

    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    Color.init(uiColor: .systemGroupedBackground)
                        .ignoresSafeArea()
                }
                VStack {
                    Spacer()
                    List {
                        Section("앱 설정") {
                            Button {

                            } label: {
                                HStack {
                                    Label("위젯 사이즈", systemSymbol: .arrowDownRightAndArrowUpLeftCircle)
                                    Spacer()
                                    Menu {
                                        Button("기본") {
                                            widgetSizeTitle = "기본"
                                            DeepLinkWidgetViewModel.shared.widgetPadding = 2
                                        }
                                        Button("중간") {
                                            widgetSizeTitle = "중간"
                                            DeepLinkWidgetViewModel.shared.widgetPadding = 8
                                        }
                                        Button("작음") {
                                            widgetSizeTitle = "작음"
                                            DeepLinkWidgetViewModel.shared.widgetPadding = 16
                                        }
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(AppColor.Fill.second)
                                            Text(widgetSizeTitle)
                                                .font(.custom(CustomFont.NotoSansKR.medium, size: 16))
                                        }
                                    }
                                    .frame(width: 80)
                                    .padding(1)
                                }
                            }
                            .foregroundColor(AppColor.Label.first)
                            .onAppear {
                                switch DeepLinkWidgetViewModel.shared.widgetPadding {
                                case 2:
                                    widgetSizeTitle = "기본"
                                case 8:
                                    widgetSizeTitle = "중간"
                                case 16:
                                    widgetSizeTitle = "작음"
                                default:
                                    widgetSizeTitle = "선택하세요"

                                }
                            }

                        }

                        Section("사용방법") {
                            SettingMenuButton(title: "위젯을 잠금화면에 등록하는 방법", imageType: .symbol, systemSymbol: .appsIphoneBadgePlus, imageColor: AppColor.Label.second) {
                                viewModel.showHowtoUseView.toggle()
                            }

                            SettingMenuButton(title: "소개화면 다시보기", imageType: .symbol, systemSymbol: .docAppend, imageColor: AppColor.Label.second) {
                                viewModel.showWelcomeSheet.toggle()
                            }
                        }

                        Section("소통하기") {
                            SettingMenuButton(title: "앱 추가요청", imageType: .symbol, systemSymbol: .noteTextBadgePlus, imageColor: AppColor.Label.second) {
                                viewModel.showAssetRequestView.toggle()
                            }

                            SettingMenuButton(title: "문의하기", imageType: .symbol, systemSymbol: .paperplaneFill, imageColor: AppColor.Label.second) {
                                viewModel.showContactView.toggle()
                            }
                        }

                        Section("앱에 관하여") {

                            SettingMenuButton(title: "앱 평가하기", imageType: .symbol, systemSymbol: .starFill, imageColor: .yellow) {
                                requestReview()
                            }
                            SettingMenuButton(title: "코젯 버전", subtitle: appVersion, imageType: .asset, imageName: "Koget") {
                            }
                            .disabled(true)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
                .navigationTitle("더보기")
            }
            .tint(.black)
            .welcomeSheet(isPresented: $viewModel.showWelcomeSheet, isSlideToDismissDisabled: true, preferredColorScheme: constant.isDarkMode ? .dark : .light, pages: viewModel.pages)
            .sheet(isPresented: $viewModel.showUseLockscreen) {
                LockscreenHelper()
            }
            .sheet(isPresented: $viewModel.showPatchNote) {
                PatchNoteList()
            }
            .sheet(isPresented: $viewModel.showContactView, content: {
                ContactView()
            })
            .sheet(isPresented: $viewModel.showAssetRequestView, content: {
                AssetRequestView()
            })
            .sheet(isPresented: $viewModel.showHowtoUseView, content: {
                LockscreenHelper()
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("KogetClear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }
        }
    }
}

struct HowToUseMenus_Previews: PreviewProvider {
    static var previews: some View {
        SettingMenu()
    }
}
