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
                AppColor.Background.first
                
                VStack(alignment: .center ,spacing: 8) {
                    //"잠금화면에 위젯 등록"
                    Text(S.LockscreenHelper.descriptionTitle)
                        .font(.custom(CustomFont.NotoSansKR.bold, size: 20))
                        .fontWeight(.bold)
                        .padding(.vertical, 12)
                    
                    ZStack {
                        Color.black
                        VideoPlayer(player: player)
                            .frame(height: deviceSize.height / 2.5)
                            .cornerRadius(12)
                        
                    }
                    .frame(height: deviceSize.height / 2.2)
                    .cornerRadius(12)
                    
                    ZStack {
                        AppColor.Background.second
                            .cornerRadius(12)
                        VStack {
                            // 설명
                            TabView {
                                VStack(alignment: .leading ,spacing: 8) {
                                    Spacer()
                                    Text(S.LockscreenHelper.description1)
                                    Text(S.LockscreenHelper.description2)
                                    Text(S.LockscreenHelper.description3)
                                    Spacer()
                                }
                                VStack(alignment: .leading ,spacing: 8) {
                                    Spacer()
                                    Text(S.LockscreenHelper.description4)
                                    Text(S.LockscreenHelper.description5)
                                    Text(S.LockscreenHelper.description6)
                                    Spacer()
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                
                            }
                            .tabViewStyle(.page(indexDisplayMode: .automatic))
                        }
                    }
                    .frame(height: deviceSize.height / 3)
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
