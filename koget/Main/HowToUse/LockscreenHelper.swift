//
//  HowToUseMenu.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/19.
//

import SwiftUI
import AVKit

struct LockscreenHelper: View {
    
    @State var player = AVPlayer()
    
    var body: some View {
        
        GeometryReader { (geometry) in
            ZStack {
                Color.white
                
                VStack(alignment: .center ,spacing: 8) {
                    
                    Text("잠금화면에 위젯 등록")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical, 12)
                    
                    ZStack {
                        Color.black
                        VideoPlayer(player: player)
                            .frame(height: geometry.size.height / 2.5)
                            .cornerRadius(12)
                        
                    }
                    .frame(height: geometry.size.height / 2.2)
                    .cornerRadius(12)
                    
                    ZStack {
                        Color.init(uiColor: .secondarySystemFill)
                            .cornerRadius(12)
                        VStack {
                            TabView {
                                VStack(alignment: .leading ,spacing: 8) {
                                    Spacer()
                                    Text("1. 잠금화면 상태에서 화면을 길게 탭하기.")
                                    Text("2. 사용자화 - 잠금화면 - 위젯선택 누르기")
                                    Text("3. 위젯 리스트에서 코젯을 선택")
                                    Spacer()
                                }
                                VStack(alignment: .leading ,spacing: 8) {
                                    Spacer()
                                    Text("4.'바로가기 위젯추가' 를 누르세요.")
                                    Text("5.'눌러서 위젯선택'을 눌러 위젯을 선택하세요.")
                                    Text("6. 우측 상단 '완료' 버튼을 눌러 저장하세요.")
                                    Spacer()
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                
                            }
                            .tabViewStyle(.page(indexDisplayMode: .automatic))
                        }
                    }
                    .frame(height: geometry.size.height / 3)
                }
                .padding(.horizontal)
                .navigationBarTitleDisplayMode(.inline)
                Spacer()
                
            }
            .onAppear{
                if player.currentItem == nil {
                    let item = AVPlayerItem(url: Bundle.main.url(forResource: "lockscreenTutorial", withExtension: "mp4")!)
                    player.replaceCurrentItem(with: item)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    player.play()
                })
            }
        }
        
    }
}

struct HowToUseMenu_Previews: PreviewProvider {
    static var previews: some View {
        LockscreenHelper()
    }
}
