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
    
    var colorImage = UIImage()

    
    var firstColor = UIView()
    
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
        
        let stackView: UIStackView = {
            let sv = UIStackView()
            
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.axis = .horizontal
            sv.spacing = 10
            sv.alignment = .center
            sv.distribution = .fillEqually

            return sv
        }()
        
        addSubview(stackView)
        
        var imageColors = UIColor()
        

        var mainImg = ImageViewModel.shared.editingPhoto
            .subscribe { image in
                image.map { image in
                    
                    guard let image = image else {return}
                    
                    imageColors = UIColor(averageColorFrom: image)
                    let compImg = image.jpegData(compressionQuality: 0.3)
                    self.colorImage = UIImage(data: compImg!, scale: 10) ?? UIColor.white.image()
                }
            }.dispose()
        
        let colorArray = NSArray(ofColorsFrom: colorImage, withFlatScheme: false)
        
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
            
            /// Color Slider Layout
            circle.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.width.equalTo(30)
            }
            
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo((colorCircles.count - 1) * 10 + colorCircles.count * 30)
            make.height.equalTo(30)
        }
        
    }
    
}
