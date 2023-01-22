//
//  SuccessAlert.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/22.
//

import SwiftUI
import Lottie
import ToastUI

struct SuccessAlert: View {
    
    var opacity: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            Color.white
                .opacity(opacity)
            VStack(spacing: 12) {
                LottieView(jsonName: "success", loopMode: .playOnce)
                    .frame(width: 150, height: 150)
                Text("위젯 생성 성공!")
                    .font(.system(size: 20, weight: .bold))
                Text("코젯앱을 잠금화면에 추가해 사용하세요.")
                    .font(.system(size: 18, weight: .medium))


            }
        }
        .frame(width: 300, height: 300)
        .cornerRadius(16)
    }
}

struct SuccessAlert_Previews: PreviewProvider {
    static var previews: some View {
        SuccessAlert()
            .frame(width: 300, height: 300)
    }
}
