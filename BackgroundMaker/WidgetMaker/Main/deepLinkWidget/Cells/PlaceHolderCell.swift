//
//  PlaceHolderCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/16.
//

import UIKit
import SnapKit


class PlaceHolderCell: UICollectionViewCell {
    
    let label = ViewModel.shared.makeLabel(text: "아직 추가한 위젯이 없어요. \n 첫 딥링크 위젯을 추가해보세요.", fontSize: 18, fontWeight: .semibold)
    
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
        label.textColor = .gray
        
        //MARK: AutoLayout 구성 (Snapkit 사용)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

