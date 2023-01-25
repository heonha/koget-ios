//
//  OnboardingPage.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/24.
//

import SwiftUI

struct OnboardingPage: View {
    
    enum ContentType {
        case lottie
        case image
    }
    
    var type: ContentType
    var imageName: String? = nil
    var imageName2: String? = nil
    var imageName3: String? = nil
    var imageSize: CGFloat = 150
    
    var jsonName: String? = nil
    var oneLine: String
    var twoLine: String = ""
    var threeLine: String = ""
    
    var isLastPage: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            switch type {
            case .image:
                HStack(spacing: 32) {
                    
                    if let imageName = imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(width: imageSize, height: imageSize)
                    }
                    
                    if let imageName2 = imageName2 {
                        Image(imageName2)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(width: imageSize, height: imageSize)
                    }
                    
                    if let imageName3 = imageName3 {
                        Image(imageName3)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(width: imageSize, height: imageSize)
                    }
                    
                }
                .frame(width: 350, height: 350)
                
            case .lottie:
                if let jsonName = jsonName {
                    LottieView(jsonName: jsonName)
                        .frame(width: 350, height: 350)
                }
            }
            
            VStack(spacing: 8) {
                Text(oneLine)
                Text(twoLine)
                Text(threeLine)
            }
            .font(.system(size: 16, weight: .semibold))
            .multilineTextAlignment(.center)
            .frame(width: DEVICE_SIZE.width - 48)
            
            Spacer()
            
            ZStack {
                Spacer()
                HStack {
                    if isLastPage {
                        Button {
                            dismiss()
                            MainWidgetViewModel.shared.isFirstRun = false
                            // withAnimation(.spring()) {
                            //     MainWidgetViewModel.shared.isFirstRun.toggle()
                            // }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(height: 40)
                                    .foregroundStyle(Constants.kogetGradient)
                                    .clipped()
                                    .opacity(0.9)
                                Text("코젯 시작하기")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .cornerRadius(5)
                        }
                        .padding(.horizontal)
                    } else {
                        LottieView(jsonName: "rightArrow", loopMode: .loop, speed: 1.5)
                            .frame(width: 50, height: 50)
                            .padding(.trailing)
                    }
                    
                }
            }
        }
    }
    
    
}



struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPage(type: .image, oneLine: "")
    }
}
