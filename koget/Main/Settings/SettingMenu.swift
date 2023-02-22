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
        ZStack {
            Color.init(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            VStack {
                Spacer()
                List {
                    Section("공지사항") {
                        
                        NavigationLink {
                            PatchNoteList()
                        } label: {
                            Label("업데이트 소식", systemImage: "square.and.pencil")
                        }
                        // SettingMenuButton(title: "패치 노트", imageType: .symbol, imageName: "square.and.pencil") {
                        //     viewModel.showPatchNote.toggle()
                        // }
                        NavigationLink {
                            LockscreenHelper()
                        } label: {
                            Label("위젯을 잠금화면에 등록하는 방법", systemImage: "apps.iphone.badge.plus")
                        }

                        // SettingMenuButton(title: "만든 위젯을 잠금화면에 등록하는 방법", imageType: .symbol, imageName: "apps.iphone.badge.plus") {
                        //     viewModel.showUseLockscreen.toggle()
                        // }
                        
         
                        
                    }
                    
                    Section("앱에 관하여") {
                        
                        SettingMenuButton(title: "앱 소개 다시보기", imageType: .symbol, imageName: "book") {
                            viewModel.showWelcomeSheet.toggle()
                        }
                        
                        
                        SettingMenuButton(title: "앱 평가하기", imageType: .symbol, imageName: "star.fill", imageColor: .yellow) {
                            requestReview()
                        }
                        
                        SettingMenuButton(title: "코젯 버전", subtitle: APP_VERSION, imageType: .asset, imageName: "Koget") {
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
