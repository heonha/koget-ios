//
//  OnboardingView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/24.
//

import SwiftUI

struct OnboardingPageView: View {
    @Environment(\.dismiss) var dismiss
    @State var page = 0
    
    var body: some View {
        ZStack {
            
            TabView(selection: $page) {
                
                OnboardingPage(type: .image,
                               imageName: "Koget",
                               oneLine: "코젯은",
                               twoLine: "잠금화면 바로가기 위젯 생성앱이에요."
                )
                .onTapGesture {
                    withAnimation {
                        page += 1
                    }
                }
                
                OnboardingPage(type: .image,
                               imageName: "appOnboard",
                               imageSize: 350,
                               oneLine: "앱 바로가기, 웹페이지 바로가기를 지원하여,",
                               twoLine: "등록한 곳으로 빠르게 이동할 수 있어요."
                )
                .tag(1)
                .onTapGesture {
                    withAnimation {
                        page += 1
                    }
                }
                
                OnboardingPage(type: .image,
                               imageName: "kakaomap",
                               imageName2: "naver",
                               imageName3: "mobileid",
                               imageSize: 75,
                               oneLine: "카카오, 네이버, 모바일신분증 앱 등",
                               twoLine: "국내에서 자주 사용되는",
                               threeLine: "앱 바로가기도 준비 되어있어요!"
                )
                .tag(2)
                .onTapGesture {
                    withAnimation {
                        page += 1
                    }
                }
                
                OnboardingPage(type: .lottie,
                               jsonName: "apps",
                               oneLine: "이제,",
                               twoLine: "잠금화면에 바로가기 위젯을 만들어 볼까요?",
                               isLastPage: true
                )
                .tag(3)
                
            }
            
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            
        }
        .onDisappear(perform: {
            self.page = 0
        })
        .frame(height: DEVICE_SIZE.height - 200)
    }
}

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView()
    }
}

