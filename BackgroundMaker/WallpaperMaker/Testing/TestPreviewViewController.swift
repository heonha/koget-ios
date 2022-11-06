//
//  TestPreviewViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/03.
//

import UIKit
import SnapKit
import SwiftUI

class TestPreviewViewController: UIViewController {
    
    let testView: UIView!
    let viewHeight: CGFloat!
    var defaultBGColor: UIColor!
    
    init(testView: UIView, viewHeight: CGFloat, defaultBGColor: UIColor = .systemBackground) {
        
        self.testView = testView
        self.viewHeight = viewHeight
        self.defaultBGColor = defaultBGColor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = defaultBGColor
        setTestView()
        
    }
    
    
    func setTestView() {
        view.addSubview(testView)
        testView.snp.makeConstraints { make in
            make.centerY.leading.trailing.equalTo(view)
            make.height.equalTo(viewHeight)
        }
    }
    
}
