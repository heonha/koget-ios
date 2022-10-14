//
//  ImageTextButton.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/10.
//

import UIKit
import SnapKit



class ImageTextButton: UIView {
    
    //MARK: - Properties
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        
        return sv
    }()
    
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .gray
        
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    
    /// 투명한 버튼
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.alpha = 0.3
        button.setImage(UIColor.gray.image(), for: .selected)
        
        return button
    }()
    
    
    //MARK: - INIT
    init(image: UIImage, title: String, titleColor: UIColor = .white, action: UIAction?, backgroundColor: UIColor = .systemBlue) {
        
        
        super.init(frame: .zero)
        
        configureUI()
        
        setImage(image: image)
        setTitle(title: title)
        setTitleColor(color: titleColor)
        
        if let settedAction = action {
            button.addAction(action!, for: .touchDown)
        }
        stackView.backgroundColor = backgroundColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    var isSelected = false

    
    func toggle() {
        isSelected = !isSelected
    }
    
    
    //MARK: Image Set
    private func setImage(image: UIImage) {
        self.imageView.image = image
    }
    
    
    //MARK: Title Set
    private func setTitle(title: String, fontSize: CGFloat = 13) {
        self.label.text = title
        self.label.numberOfLines = 1
        self.label.font = .systemFont(ofSize: fontSize)
    }
    
    
    func setTitleColor(color: UIColor) {
        self.label.textColor = color
    }
    
    
    //MARK: - Layout
    private func configureUI() {
        
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        addSubview(button)
        
        // contentView는 rootview의 역할을 합니다.
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalTo(stackView)
        }
        
    } // #END configureUI
    
    
}
