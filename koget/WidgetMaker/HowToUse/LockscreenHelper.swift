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
        ZStack {
            Color.white
            
            VStack(alignment: .leading ,spacing: 8) {
                ZStack {
                    Color.black
                    VideoPlayer(player: player)
                        .frame(height: 400)
                        .cornerRadius(12)

                }
                .frame(height: 450)
                .cornerRadius(12)

                Text("만든 위젯을 잠금화면에 등록하는 방법")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.vertical, 8)
                ZStack {
                    Color.init(uiColor: .secondarySystemFill)
                        .cornerRadius(12)
                    VStack {
                        TabView {
                            VStack(alignment: .leading ,spacing: 8) {
                                Spacer()
                                Text("1. 잠금화면 상태에서 ") +
                                Text("화면을 길게 탭하세요.").font(.system(size: 18, weight: .bold))
                                Text("2. ") + Text("사용자화 - 잠금화면 - 위젯선택").font(.system(size: 18, weight: .bold)) + Text(" 누르기")
                                Text("3. 위젯 리스트에서 ") +
                                Text("코젯을 선택").font(.system(size: 18, weight: .bold)) +
                                Text(" 해주세요.")
                                Spacer()
                            }
                            VStack(alignment: .leading ,spacing: 8) {
                                Spacer()
                                Text("4. ") +
                                Text("'바로가기 위젯추가'").font(.system(size: 18, weight: .bold)) +
                                Text("를 누르세요.")
                                Text("5. ") +
                                Text("'눌러서 위젯선택'").font(.system(size: 18, weight: .bold)) +
                                Text("을 눌러 위젯을 선택하세요.")
                                Text("6. ") + Text("우측 상단 완료").font(.system(size: 18, weight: .bold)) +
                                Text("버튼을 눌러 저장하세요.")
                                Spacer()
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .automatic))
                    }
                }
                .frame(height: 150)



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

struct HowToUseMenu_Previews: PreviewProvider {
    static var previews: some View {
        LockscreenHelper()
    }
}
