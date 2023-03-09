//
//  HowToUseMenus.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/24.
//

import SwiftUI
import WelcomeSheet

struct SettingMenu: View, AppStoreReviewable {
    
    @ObservedObject var viewModel = HelperSheetViewModel.shared
    @EnvironmentObject var constant: Constants
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    AppColor.Background.first
                }
                VStack {
                    Spacer()
                    List {
                        Section("사용방법") {
                            NavigationLink {
                                LockscreenHelper()
                            } label: {
                                Label("위젯을 잠금화면에 등록하는 방법", systemImage: "apps.iphone.badge.plus")
                            }

                            SettingMenuButton(title: "소개화면 다시보기", imageType: .symbol, imageName: "doc.append", imageColor: AppColor.Label.second) {
                                viewModel.showWelcomeSheet.toggle()
                            }
                        }

                        Section("소통하기") {
                            SettingMenuButton(title: "앱 추가요청", imageType: .symbol, imageName: "doc.append", imageColor: AppColor.Label.second) {
                                viewModel.showAssetRequestView.toggle()
                            }

                            SettingMenuButton(title: "문의하기", imageType: .symbol, imageName: "paperplane.fill", imageColor: AppColor.Label.second) {
                                viewModel.showContactView.toggle()
                            }
                        }
                            Section("앱에 관하여") {

                            SettingMenuButton(title: "앱 평가하기", imageType: .symbol, imageName: "star.fill", imageColor: .yellow) {
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

struct SettingMenuButton: View {
    
    enum ImageType {
        case symbol
        case asset
    }

    var title: LocalizedStringKey
    var subtitle: String? = nil
    var imageType: ImageType
    var imageName: String
    var imageSize: CGFloat = 20
    var imageColor: Color = AppColor.Label.first
    var action: () -> Void

    var titleColor: Color = AppColor.Label.first
    var subtitleColor: Color = AppColor.Label.second

    var body: some View {
        Button {
            action()
        } label: {
            LazyHStack {
                
                switch imageType {
                case .symbol:
                    Image(systemName: imageName)
                        .tint(imageColor)
                        .shadow(color: Color.black.opacity(0.2), radius: 0.1, x: 1, y: 1)
                        .frame(width: imageSize)
                case .asset:
                    Image(imageName)
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(Circle())
                }

                LazyHStack {
                    Text(title)
                        .foregroundStyle(titleColor)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .foregroundStyle(subtitleColor)
                    }
                }
            }
        }
    }
}
