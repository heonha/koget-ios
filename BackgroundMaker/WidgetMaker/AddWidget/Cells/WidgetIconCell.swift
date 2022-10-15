//
//  WidgetIconCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/04.
//

import UIKit
import SnapKit
import WidgetKit

/// 위젯 아이콘을 담고 있는 CollectionView Cell
class WidgetIconCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let reuseID = Constants.reuseID_WidgetIconCell
    
    var labelHeight: CGFloat = 30
    
    let imgView = UIImageView()
    let label = UILabel()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        // addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        
        
        
    }
    
    @available(iOS 16.0, *)
    func makeIconLockScreen(image: UIImage) {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.image = image
        
        imgView.alpha = 1
        
        ViewModel.shared.cropCornerRadius(view: imgView, radius: self.frame.width / 2)
        
        addSubview(imgView)
        
        imgView.snp.makeConstraints { make in
            make.width.equalTo(frame.width)
            make.height.equalTo(frame.width)
            make.top.centerX.equalToSuperview()

        }
    }
    
    func makeIcon(image: UIImage) {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.image = image
        
        imgView.alpha = 1
        
        ViewModel.shared.cropCornerRadius(view: imgView, radius: self.frame.width / 2)
        
        addSubview(imgView)
        
        imgView.snp.makeConstraints { make in
            make.width.equalTo(frame.width)
            make.height.equalTo(frame.width)
        }
    }

    
    func makeLabel(text: String, height: CGFloat) {
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .white
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        addSubview(label)
        
        imgView.snp.remakeConstraints { make in
            make.width.equalTo(frame.width)
            make.height.equalTo(frame.width)
            make.top.centerX.equalToSuperview()

        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(labelHeight)
        }
    }
    
    func remakeAlpha(view: UIView, alpha: CGFloat) {
        view.alpha = alpha
    }
    
    
}
