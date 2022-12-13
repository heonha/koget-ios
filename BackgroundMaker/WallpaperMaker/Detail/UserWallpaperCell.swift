//
//  UserWallpaperCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/30.
//

import UIKit
import SnapKit

class UserWallpaperCell: UICollectionViewCell {
    
    static let reuseID = "UserWallpaperCell"
    
    var imageView = UIImageView()
    
    var checkButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "circle")?.addShadow(color: .darkGray), for: .normal)
        btn.setImage(UIImage(named: "checkmark.circle.fill.white")?.addShadow(color: .black), for: .selected)
        btn.isHidden = true
        return btn
    }()
    
    var isEditing: Bool = false {
        didSet {
            checkButton.isHidden = !isEditing
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .clear
        //MARK: SubView (imageView) 구성하기.
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        ViewModelForCocoa.shared.cropCornerRadius(view: imageView, radius: 5)
        
        addSubview(imageView)

        //MARK: AutoLayout 구성 (Snapkit 사용)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        configureCheckmarkBtn()
        
    }
    
    func configureCheckmarkBtn() {
        addSubview(checkButton)
        let buttonFrame: CGFloat = 30
        checkButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(self).inset(8)
            make.width.height.equalTo(buttonFrame)
        }
    }
}

