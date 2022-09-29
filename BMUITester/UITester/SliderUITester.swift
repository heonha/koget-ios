//
//  SliderUITester.swift
//  BMUITester
//
//  Created by HeonJin Ha on 2022/09/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SliderUITester: UIViewController {
    
    var sliderDisposeBag = DisposeBag()
    
    lazy var sliderObservable: Observable<Float> = editSlider.rx.value.asObservable()
    
    var editSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 0.5
        slider.alpha = 0.9
        slider.tintColor = .white
        slider.isHidden = true
        return slider
    }()
    
    /// 편집할 이미지가 들어갈 이미지 뷰
    var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "TestImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(mainImageView)
        
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        makeSliderView() // 룰러뷰(눈금뷰) 정의
        sliderSubscriber()
        resizeImageView()
    }
}


extension SliderUITester {
    
    func makeSliderView() {
        

        view.addSubview(editSlider)
        editSlider.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        
    }
    
    
    /// 슬라이더 Value를 구독합니다.
    func sliderSubscriber() {
        sliderObservable
            .debounce(.milliseconds(10), scheduler: MainScheduler.instance) // 업데이트 시간 조절으로 리소스 최적화
            .map { float in
                CGFloat(float) * 40
            }
            .subscribe { value in
                ImageEditModel.shared.makeImageRoundBlur(imageView: self.mainImageView, insetY: value)
            } onError: { error in
                print("DEBUG: sliderObservable Error: \(error.localizedDescription)")
            } onCompleted: {
                print("DEBUG: sliderObservable Completed")
                
            } onDisposed: {
                print("DEBUG: sliderObservable Disposed")
            }.disposed(by: sliderDisposeBag)
    }

    /// 불러온 이미지에 따라서 이미지 뷰의 크기를 조절합니다.
    func resizeImageView() {
        /// 이미지뷰 레이아웃
        let screenSize = UIScreen.main.bounds
        
        
        guard let image = mainImageView.image else {
            print("이미지없음")
            return
        }
        
        let imageSize = image.size
        print("DEBUG: ImageSize \(imageSize)")

        let imageHeight = (imageSize.height * screenSize.width) / imageSize.width
        
        let resizeHeight = (screenSize.height - imageHeight) / 2
        
        mainImageView.snp.remakeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(screenSize.width)
            make.height.equalToSuperview().inset(resizeHeight)
        }
    }
}
