//
//  ErrorAlert.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/23.
//

import SwiftUI

struct ErrorAlert: View {
    
    @Binding var errorMessage: String
    var opacity: CGFloat = 0.8

    
    var body: some View {
        ZStack {
            Color.white
                .opacity(opacity)
            VStack(spacing: 8) {
                LottieView(jsonName: "error", loopMode: .playOnce)
                    .frame(width: 150, height: 150)
                Text(errorMessage)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 180, height: 40)
                    .lineLimit(2, reservesSpace: true)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: 250, height: 250)
        .cornerRadius(12)
    }
}

struct ErrorAlert_Previews: PreviewProvider {
    static var previews: some View {
        ErrorAlert(errorMessage: .constant("URL에 문자열 ://가 반드시 들어가야 합니다."))
    }
}
