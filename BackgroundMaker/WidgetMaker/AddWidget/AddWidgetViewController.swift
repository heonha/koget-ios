//
//  AddWidgetViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/30.
//

import UIKit
import SnapKit
import WidgetKit


struct Icon {
    let imageName: String
    lazy var image: UIImage = {
        let img = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        ?? UIImage(systemName:  imageName)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        ?? UIColor.blue.image()
        return img
    }()
}



class AddWidgetViewController: UIViewController {
    
    //MARK: - Properties
    
    let sampleIconTitle: UILabel = ViewModel.shared.makeLabel(
        text: "아이콘 선택하기",
        color: .white,
        fontSize: 20,
        fontWeight: .bold,
        alignment: .left
    )
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .darkGray
        
        view.addSubview(sampleIconTitle)
        sampleIconTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(30)
        }
    }
    
}
