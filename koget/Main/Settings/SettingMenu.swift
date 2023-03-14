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
