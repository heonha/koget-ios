//
//  BackgroundPickerView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/02.
//

import UIKit
import SnapKit
import UIImageColors
import SwiftUI
import RulerView

/// Color Pallet 를 담고있는 View 입니다.
class BackgroundPickerView: UIView {

    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    var target: MakeWallpaperViewController!
    
    var contentView = UIView()
    var colorSlider = UIView()
    

    
    // 편집중인 이미지를 리사이징 (평균 컬러 추출용)
    var colorImage: UIImage = {
        var editingImage = UIImage()
        EditViewModel.shared.editingPhoto
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
    
    init(target: MakeWallpaperViewController) {
        self.target = target
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        makeColorSlider()
    }
    
    struct PalletCircle {
        let name: String
        let circle: UIImage
    }
    
    /// 컬러 팔레트를 구성합니다. (이미지에서 추출)
    func makeColorPallets(image: UIImage) -> [BackgroundColorPallet] {
        
        let imageColors = image.getColors()!
        
        let blurColor = image.blurImage()!
        
        let colors: [PalletCircle] = [
            // 기본컬러
            PalletCircle(name: "Black", circle: UIColor.black.image()),
            PalletCircle(name: "White", circle: UIColor.white.image()),
            // 이미지로부터 추출한 컬러
            PalletCircle(name: "fromImageOne", circle: imageColors.primary.image()),
            PalletCircle(name: "fromImgTwo", circle: imageColors.secondary.image()),
            PalletCircle(name: "fromImgThree", circle: imageColors.detail.image()),
            PalletCircle(name: "fromImgFour", circle: imageColors.background.image()),
        ]
        
        // 블러 써클
        let blur = PalletCircle(name: "Blur", circle: blurColor)
        let blurCircle = BackgroundColorPallet(color: blur.circle, target: target, type: .showRuler)
            
        var pallets: [BackgroundColorPallet] = [blurCircle]
        
        for color in colors {
            let item = BackgroundColorPallet(color: color.circle, target: target)
            pallets.append(item)
        }
        
        return pallets
    }
    
    
    private func makeColorSlider() {
        
        let circleSize: CGFloat = 30.0
        let colorCircles = makeColorPallets(image: colorImage)
        
        for circle in colorCircles {
            
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.layer.cornerRadius = 15
            stackView.addArrangedSubview(circle)
            
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
    
    // 블러뷰를 클릭하면 블러뷰가 실행된다.
    // 실행 후 현재 블러 정도를 조절기를 나타낸다.
    // 다른곳을 클릭하거나 뒤로가기를 누르면 다시 배경선택기가 나타난다.
    
}



// 
// 
// struct ColorPickerView_Previews: PreviewProvider {
//     static var previews: some View {
//         
//         let sampleImage = UIImage(named: "testImage")!
//         
//         let testView = BackgroundPickerView(target: MakeWallpaperViewController())
// 
// 
//         TestPreviewViewController_Representable(sampleImage: sampleImage, testView: testView)
//             .edgesIgnoringSafeArea(.all)
//             .previewInterfaceOrientation(.portrait)
//     }
// }
// 
// struct TestPreviewViewController_Representable: UIViewControllerRepresentable {
//     
//     let sampleImage: UIImage!
//     let testView: UIView!
//     
//     init(sampleImage: UIImage!, testView: UIView!) {
//         self.sampleImage = sampleImage
//         self.testView = testView
//     }
//     
//     func makeUIViewController(context: Context) -> UIViewController {
//         
//         ImageViewModel.shared.editingPhotoSubject.onNext(self.sampleImage)
//         
//         let mainVC = TestPreviewViewController(testView: testView, viewHeight: 50, defaultBGColor: .gray)
// 
//         let viewer = mainVC
//         
//         return viewer
//     }
//     
//     func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//         
//     }
//     
//     typealias UIViewControllerType = UIViewController
// }
// 
// 
