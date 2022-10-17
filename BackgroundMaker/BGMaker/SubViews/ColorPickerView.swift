//
//  ColorPickerView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/02.
//

import UIKit
import SnapKit
import ChameleonFramework


/// Color Pallet 를 담고있는 View 입니다.
class ColorPickerView: UIView {
    
    
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    var target: UIViewController!
    
    var backgroundView = UIView()
    var contentView: UIView = UIView()
    var colorSlider = UIView()
    
    // 편집중인 이미지를 리사이징 (평균 컬러 추출용)
    var colorImage: UIImage = {
        var editingImage = UIImage()
        var mainImg = ImageViewModel.shared.editingPhoto
            .subscribe { image in
                image.map { image in
                    
                    guard let image = image else {return}
                    
                    let compImg = image.jpegData(compressionQuality: 0.3)
                    editingImage = UIImage(data: compImg!, scale: 10) ?? UIColor.white.image()
                }
            }.dispose()
        
        return editingImage
    }()


    /// 컬러 팔레트 스택뷰
    let stackView: UIStackView = {
        let sv = UIStackView()
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .center
        sv.distribution = .fillEqually

        return sv
    }()
    
    
    
    
    init(target: UIViewController) {
        self.target = target
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.3
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        makeColorSlider()

    }
    

    
    private func makeColorSlider() {

        let colorArray = NSArray(ofColorsFrom: colorImage, withFlatScheme: true)
        let colorBlack = UIColor.black
        let colorOne = UIColor(averageColorFrom: colorImage)!
        let colorTwo = colorArray![1] as! UIColor
        let colorThree = colorArray![2] as! UIColor
        let colorFour = colorArray![3] as! UIColor
        let colorWhite = UIColor.white
        
        
        lazy var circleBlack = ColorPalletView(color: colorBlack, target: target)
        lazy var circleWhite = ColorPalletView(color: colorWhite, target: target)
        lazy var circleOne = ColorPalletView(color: colorOne, target: target)
        lazy var circleTwo = ColorPalletView(color: colorTwo, target: target)
        lazy var circleThree = ColorPalletView(color: colorThree, target: target)
        lazy var circleFour = ColorPalletView(color: colorFour, target: target)
        
        let colorCircles = [circleBlack, circleWhite, circleOne, circleTwo, circleThree, circleFour]
        let circleSize: CGFloat = 30.0
        
        for circle in colorCircles {
        
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.layer.cornerRadius = 15
            stackView.addArrangedSubview(circle)
        
            var circleSize: CGFloat = 30
            /// Color Pallet 크기 지정
            circle.snp.makeConstraints { make in
                make.height.equalTo(circleSize)
                make.width.equalTo(circleSize)
            }
        
        }
        
        addSubview(stackView)

        /// 팔레트 색상 갯수에 따라서 StackView의 크기를 조절합니다.
        stackView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo((colorCircles.count - 1) * 10 + colorCircles.count * 30)
            make.height.equalTo(30)
        }
        
    }
    
}
