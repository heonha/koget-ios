//
//  WidgetIconCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/04.
//

import UIKit
import SnapKit

class WidgetIconCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let reuseID = "WidgetIconCell"
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {

    }
    
    func makeIcon(image: UIImage) {
        let icon: UIImageView = {
            
            let img = UIImageView()
            img.translatesAutoresizingMaskIntoConstraints = false
            img.contentMode = .scaleAspectFill
            img.image = image
            img.alpha = 0.5
            
            ViewModel.shared.cropCornerRadius(view: img, radius: self.frame.width / 2)
            
           return img
        }()
        
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }

    
}
