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
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.init(uiColor: .secondarySystemBackground)
                    .ignoresSafeArea()

                ZStack {
                    AppColors.secondaryBackgroundColor
                        .ignoresSafeArea()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("KogetClear")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }

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

                        }

                        Section("앱에 관하여") {

                            SettingMenuButton(title: "앱 소개 다시보기", imageType: .symbol, imageName: "book") {
                                viewModel.showWelcomeSheet.toggle()
                            }

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
            .welcomeSheet(isPresented: $viewModel.showWelcomeSheet, isSlideToDismissDisabled: true, pages: viewModel.pages)
            .sheet(isPresented: $viewModel.showUseLockscreen) {
                LockscreenHelper()
            }
            .sheet(isPresented: $viewModel.showPatchNote) {
                PatchNoteList()
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
    var titleColor: Color = .black
    var subtitle: String? = nil
    var subtitleColor: Color = .black
    var imageType: ImageType
    var imageName: String
    var imageColor: Color = .black
    var imageSize: CGFloat = 20
    var action: () -> Void

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
