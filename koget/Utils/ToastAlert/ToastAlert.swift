//
//  ToastAlert.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/23.
//

import SwiftUI

struct ToastAlert: View {
    
    enum ToastAlertType: String {
        case normal = "success"
        case send = "sendSuccess"
        case error = "error"
        case trash = "trash"
    }
    
    var jsonName: ToastAlertType
    
    var title: String
    var subtitle: String?
    var size = CGSize(width: 250, height: 250)
    var opacity: CGFloat = 0.8
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.5)
            VStack(alignment: .center, spacing: 12) {
                LottieView(jsonName: jsonName.rawValue, loopMode: .playOnce, speed: 1.5)
                    .frame(width: 150, height: 150)
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.center)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 16, weight: .medium))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(width: size.width, height: size.height)
        .cornerRadius(12)
        .background(
            VisualEffect(style: .systemThinMaterial)
                .opacity(0.9)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ErrorAlert_Previews: PreviewProvider {
    static var previews: some View {
        ToastAlert(jsonName: .normal, title: "URL에 문자열 ://가 반드시 들어가야 합니다.", subtitle: nil)
    }
}


struct VisualEffect: UIViewRepresentable {
    @State var style : UIBlurEffect.Style // 1
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style)) // 2
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    } // 3
}
