//
//  FailLinkViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/09.
//

import UIKit

class FailLinkViewController: UIViewController {
    
    //MARK: - Properties
    
    // [Todo]
    // DeepLinking Fail시 이곳으로 연결 하도록 하기.
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemTeal
    }
    
}
