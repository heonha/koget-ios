//
//  TextWidgetCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/18.
//
import UIKit
import SnapKit


class TextWidgetCell: UICollectionViewCell {
    
    static let reuseID = "TextWidgetCell"
    
    let label = ViewModel.shared.makeLabel(text: "no data", fontSize: 18, fontWeight: .semibold)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configureUI() {
        addSubview(label)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .black
        label.backgroundColor = .white
        ViewModel.shared.cropCornerRadius(view: label)
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.white.cgColor

        
        //MARK: AutoLayout 구성 (Snapkit 사용)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

