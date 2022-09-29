//
//  SubviewUITester.swift
//  BMUITester
//
//  Created by HeonJin Ha on 2022/09/29.
//



import UIKit
import SnapKit



class SubviewUITester: UIViewController {
    
    let buttonOne: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("테스트", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonOneTapped), for: .touchDown)
        
        return button
    }()
    
    let buttonTwo: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("테스트2", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonTwoTapped), for: .touchDown)
        
        return button
    }()
    
    var buttonOneSubView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        configureUI()
        
        
    }
    
    
    func configureUI() {
        
        view.addSubview(buttonOne)
        buttonOne.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.width.height.equalTo(100)
        }
        
        view.addSubview(buttonTwo)
        buttonTwo.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(buttonOne.snp.bottom).offset(50)
            make.width.height.equalTo(buttonOne)
        }
        
        
        
    }
    
    @objc func buttonOneTapped() {
        print("Button One Tapped !")
        buttonOne.addSubview(buttonOneSubView)
        buttonOneSubView.translatesAutoresizingMaskIntoConstraints = false
        buttonOneSubView.backgroundColor = .red
        
        buttonOneSubView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.width.height.equalTo(50)
        }
    }
    
    @objc func buttonTwoTapped() {
        print("Button Two Tapped !")
    }
    

}

