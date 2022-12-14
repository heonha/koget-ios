//
//  ImageTextButton.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/10.
//

import UIKit
import SnapKit
// import SwiftUI



class MenuButton: UIView {
    
    //MARK: - Properties
    
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .gray
        label.alpha = 0.9

        
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.alpha = 0.9
        
        return iv
    }()
    
    
    /// 투명한 버튼
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 1
        
        return button
    }()
    
    let buttonHeight: CGFloat!
    weak var target: MakeWallpaperViewController!
    
    
    //MARK: - INIT
    init(target: MakeWallpaperViewController, height: CGFloat = 50, image: UIImage, title: String,
         titleColor: UIColor = .white, action: Selector, backgroundColor: UIColor = .systemBlue) {
        
        self.buttonHeight = height
        self.target = target
        super.init(frame: .zero)
        
        configureUI()
        setImage(image: image)
        setTitle(title: title)
        setTitleColor(color: titleColor)
        button.addTarget(target, action: action, for: .touchDown)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    var isSelected = false

    
    func toggle() {
        isSelected = !isSelected
    }
    
    
    //MARK: Image Set
    private func setImage(image: UIImage) {
        self.imageView.image = image
    }
    
    
    //MARK: Title Set
    private func setTitle(title: String, fontSize: CGFloat = 13) {
        self.label.text = title
        self.label.numberOfLines = 2
        self.label.font = .systemFont(ofSize: fontSize)
    }
    
    
    func setTitleColor(color: UIColor) {
        self.label.textColor = color
    }
    
    
    //MARK: - Layout
    private func configureUI() {
        
        addSubview(imageView)
        addSubview(label)
        addSubview(button)
        
        let imageHeight = 30
        let labelHeight = 20
        
        // contentView는 rootview의 역할을 합니다.
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(imageHeight)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(-4)
            make.bottom.leading.trailing.equalTo(self)
            make.height.equalTo(labelHeight)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalTo(self)

        }
        
    } // #END configureUI
    
    
}


// struct MenuButton_Previews: PreviewProvider {
//     static var previews: some View {
//         MakeWallpaperViewController_Representable()
//             .edgesIgnoringSafeArea(.all)
//             .previewInterfaceOrientation(.portrait)
//     }
// }
