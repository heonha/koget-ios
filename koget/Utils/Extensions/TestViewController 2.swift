//
//  BlurredCircularButton.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/11.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {
    
    //MARK: - Properties
    let myImg: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "swift")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        testVisualEffectView(rootView: view, targetView: myImg)
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .black
    }
    
    func testVisualEffectView(rootView: UIView, targetView: UIView) {
        let imageView = UIImageView(image: UIColor.white.image())
        imageView.frame = CGRect(x: 0, y: rootView.center.y, width: rootView.frame.width, height: 300)
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)

        
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = rootView.frame
        view.addSubview(blurredEffectView)
        
        
        imageView.addSubview(targetView)
        targetView.frame = CGRect(x: 0, y: imageView.center.y, width: 200, height: 200)
        // targetView.snp.makeConstraints { make in
        //     make.width.height.equalTo(200)
        // }

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = view.frame

        vibrancyEffectView.contentView.addSubview(targetView)
        blurredEffectView.contentView.addSubview(vibrancyEffectView)
    }
    

    
}
