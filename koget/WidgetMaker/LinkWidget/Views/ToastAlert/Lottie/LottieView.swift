//
//  LottieView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/22.
//

import SwiftUI
import Lottie

// 로티 애니메이션 뷰
struct LottieView: UIViewRepresentable {
    var name : String
    var loopMode: LottieLoopMode
    var speed: CGFloat
    
    // 간단하게 View로 JSON 파일 이름으로 애니메이션을 실행합니다.
    init(jsonName: String, loopMode : LottieLoopMode = .loop, speed: CGFloat = 1.0){
        self.name = jsonName
        self.loopMode = loopMode
        self.speed = speed
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animationSpeed = speed

  //컨테이너의 너비와 높이를 자동으로 지정할 수 있도록합니다. 로티는 컨테이너 위에 작성됩니다.
  
  
        animationView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(animationView)
         //레이아웃의 높이와 넓이의 제약
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(jsonName: "success")
            .frame(width: 100, height: 100)
    }
}
