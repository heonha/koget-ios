//
//  HowToUseMenus.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/24.
//

import SwiftUI
import SFSafeSymbols

struct SettingMenu: View, AppStoreReviewService {
    
    @ObservedObject var viewModel = SettingMenuViewModel.shared
    @EnvironmentObject var constant: Constants

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

                        // 사용방법
                        Section(S.SettingMenu.Section.HowToUse.title) {
                            SettingMenuButton(
                                title: S.SettingMenu.Section.HowToUse.addWidget,
                                imageType: .symbol,
                                systemSymbol: .appsIphoneBadgePlus,
                                imageColor: AppColor.Label.second) {
                                viewModel.showHowtoUseView.toggle()
                            }
                        }
                        // 소통하기
                        Section(S.SettingMenu.Section.Communicate.title) {
                            SettingMenuButton(title: S.SettingMenu.Section.Communicate.requestAddApp, imageType: .symbol, systemSymbol: .noteTextBadgePlus, imageColor: AppColor.Label.second) {
                                viewModel.showAssetRequestView.toggle()
                            }

                            SettingMenuButton(title: S.SettingMenu.Section.Communicate.contactUs, imageType: .symbol, systemSymbol: .paperplaneFill, imageColor: AppColor.Label.second) {
                                viewModel.showContactView.toggle()
                            }
                        }

                        // 앱에 관하여
                        Section(S.SettingMenu.Section.AboutApp.title) {

                            SettingMenuButton(title: S.SettingMenu.Section.AboutApp.voteRate, imageType: .symbol, systemSymbol: .starFill, imageColor: .yellow) {
                                requestReview()
                            }

                            SettingMenuButton(title: S.License.title, imageType: .symbol, systemSymbol: .listBulletClipboard, imageColor: .gray) {
                                viewModel.showLicenseView.toggle()
                            }

                            SettingMenuButton(title: S.kogetVersion, subtitle: appVersion, imageType: .asset, imageName: "Koget") {
                            }
                            .disabled(true)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
                .navigationTitle(S.SettingMenu.navigationTitle)
            }
            .tint(.black)
            .sheet(isPresented: $viewModel.showUseLockscreen) {
                AddWidgetVideoView()
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
                AddWidgetVideoView()
            })
            .sheet(isPresented: $viewModel.showLicenseView, content: {
                LicenseView()
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
