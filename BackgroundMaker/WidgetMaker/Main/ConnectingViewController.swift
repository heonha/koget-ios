//
//  ConnectingViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/12.
//

import UIKit
import SnapKit

class ConnectingViewController: UIViewController {
    
    //MARK: - Properties
    
    let label = ViewModelForCocoa.shared.makeLabel(text: "앱에 딥링크 연결 중...", color: .white, fontSize: 20, fontWeight: .bold)
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .black
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
    }
    
}
