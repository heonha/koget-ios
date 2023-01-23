//
//  TrashAlert.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/23.
//

import SwiftUI

struct TrashAlert: View {
    
    var opacity: CGFloat = 0.8
    var title: String
    var subtitle: String
    
    var body: some View {
        ZStack {
            Color.white
                .opacity(opacity)
            VStack(spacing: 12) {
                LottieView(jsonName: "trash", loopMode: .playOnce)
                    .frame(width: 150, height: 150)
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                Text(subtitle)
                    .font(.system(size: 18, weight: .medium))
            }
        }
        .frame(width: 300, height: 300)
        .cornerRadius(16)
    }
    
}

struct TrashAlert_Previews: PreviewProvider {
    static var previews: some View {
        TrashAlert(title: "삭제 완료!", subtitle: "")
    }
}
