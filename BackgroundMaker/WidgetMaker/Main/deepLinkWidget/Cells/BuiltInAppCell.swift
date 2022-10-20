//
//  BuiltInAppCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/16.
//


import UIKit
import SnapKit

class BuiltInAppCell: UITableViewCell {
    
    static let reuseID = "BuiltInAppCell"
    static let cellHeight: CGFloat = 50
    
    var iconImageView: UIImageView = ViewModel.shared.makeImageView(image: nil)
    var appNameLabel: UILabel = ViewModel.shared.makeLabel(text: "no Name", fontSize: 18, fontWeight: .semibold, alignment: .left)

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setup() {
        contentView.backgroundColor = .black
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(appNameLabel)
        
        let imageHeight: CGFloat = 40
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.centerY.equalTo(contentView)
            make.height.width.equalTo(imageHeight)
        }
        iconImageView.layer.cornerRadius = imageHeight / 2
        iconImageView.clipsToBounds = true

        
        appNameLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView)
            make.top.bottom.equalTo(contentView)
            make.height.equalTo(BuiltInAppCell.cellHeight)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
        }

        
        
        
    }
    
    private func layout() {
        
    }
}
