//
//  ButtonViewCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/11.
//

import UIKit
import SnapKit

class ButtonViewCell: UICollectionViewCell {
    
    static let reuseID = "ButtonViewCell"
    
    var button: UIButton?

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .white
        
        //MARK: SubView (button) 구성하기.
        
        if let button = button {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .gray
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            contentView.addSubview(button)
            
            //MARK: AutoLayout 구성 (Snapkit 사용)
            button.snp.makeConstraints {
                $0.edges.equalTo(contentView) // 슈퍼뷰에 딱 붙게
            }
            
        } else {
            let errorMessage = UILabel()
            errorMessage.translatesAutoresizingMaskIntoConstraints = false
            errorMessage.text = "Error"
            errorMessage.adjustsFontSizeToFitWidth = true
            contentView.addSubview(errorMessage)
            errorMessage.snp.makeConstraints {
                $0.edges.equalTo(contentView) // 슈퍼뷰에 딱 붙게
            }
        }
    }
}

