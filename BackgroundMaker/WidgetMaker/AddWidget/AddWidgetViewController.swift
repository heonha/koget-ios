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
    let name: String
}

struct IconList {
    
    static let icons: [Icon] = [
        Icon(name: "swift")
    ]
    
}

class AddWidgetViewController: UIViewController {
    
    //MARK: - Properties
    
    let segment: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["커스텀 위젯", "위젯 고르기"])
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.setTitleTextAttributes(
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .semibold)],
            for: .normal
        )
        
        return seg
    }()
    
    
    let sampleIconTitle: UILabel = ViewModel.shared.makeLabel(
        text: "위젯 추가하기",
        color: .white,
        fontSize: 20,
        fontWeight: .bold,
        alignment: .center
    )
    
    lazy var contentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - AddView
    
    // [Todo]
    // - 이름
    var name: String?
    var nameLabel: UILabel = ViewModel.shared.makeLabel(
        text: "위젯 이름", color: .white, fontSize: 18, fontWeight: .bold, alignment: .left)
    var nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "위젯 이름"
        tf.backgroundColor = .darkGray
        ViewModel.shared.cropCornerRadius(view: tf, radius: 5)
        ViewModel.shared.makeLayerShadow(to: tf.layer)
        
        return tf
    }()
    
    // - URL
    var url: String?
    var urlLabel: UILabel = ViewModel.shared.makeLabel(text: "딥링크 URL", color: .white, fontSize: 18, fontWeight: .bold, alignment: .left)
    var urlTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "예시: youtube://"
        tf.backgroundColor = .darkGray
        ViewModel.shared.cropCornerRadius(view: tf, radius: 5)
        ViewModel.shared.makeLayerShadow(to: tf.layer)
        
        return tf
    }()
    
    //MARK: - UI Properties
    
    // - 추가하기 버튼
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("추가하기", for: .normal)
        button.backgroundColor = AppColors.blackDarkGrey
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchDown)
        
        ViewModel.shared.cropCornerRadius(view: button)
        ViewModel.shared.makeLayerShadow(to: button.layer)
        
        return button
    }()
    
    // 아이콘 배열
    var icons: [Icon]?
    let iconCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 스크롤 방향
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(WidgetIconCell.self, forCellWithReuseIdentifier: WidgetIconCell.reuseID)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .black
        
        return cv
    }()
    
    
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewUI()
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = AppColors.buttonPutple
        
        view.addSubview(sampleIconTitle)
        ViewModel.shared.makeLayerShadow(to: sampleIconTitle.layer)
        
        // Title
        sampleIconTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        // Segment
        let segmentHeight: CGFloat = 40
        view.addSubview(segment)
        segment.snp.makeConstraints { make in
            make.top.equalTo(sampleIconTitle.snp.bottom).inset(-8)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(segmentHeight)
        }
        
        // View
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom).inset(-8)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
    }
    
}


extension AddWidgetViewController {
    
    //MARK: - Selectors
    
    // Todo
    // - Widget Data 저장
    private func saveData() {
        
        print("PlaceHolder : Data Saved")
    }
    
    // 아이콘 가져오기
    private func fetchIcons() {
        
    }
    
    // - Dismiss Window
    @objc func addButtonTapped() {
        saveData()
        self.dismiss(animated: true)
    }
    
    
    //MARK: - Methods
    
    private func configureViewUI() {

        // Layout Values
        let insets: (top: CGFloat, leadingTrailing: CGFloat) = (8, 16)
        let spacing: CGFloat = -8
        let labelHeight: CGFloat = 30
        let textFieldHeight: CGFloat = 40
        let buttonHeight: CGFloat = 35
        
        
        contentView.backgroundColor = AppColors.blackDarkGrey
        
        // 위젯이름 (Label, TextField)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        ViewModel.shared.makeLayerShadow(to: nameLabel.layer)
        ViewModel.shared.makeLayerShadow(to: nameTextField.layer)

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(insets.top)
            make.leading.trailing.equalTo(contentView).inset(insets.leadingTrailing)
            make.height.equalTo(labelHeight)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).inset(spacing)
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(textFieldHeight)
        }
        
        
        
        // URL (Label, TextField)
        contentView.addSubview(urlLabel)
        contentView.addSubview(urlTextField)
        ViewModel.shared.makeLayerShadow(to: urlLabel.layer)
        ViewModel.shared.makeLayerShadow(to: urlTextField.layer)


        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).inset(spacing)
            make.leading.trailing.equalTo(contentView).inset(insets.leadingTrailing)
            make.height.equalTo(labelHeight)
        }
        
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(urlLabel.snp.bottom).inset(spacing)
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(textFieldHeight)
        }
        
        // Button Layout
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(urlTextField.snp.bottom).inset(-20)
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(buttonHeight)
        }

        
        
    }
    
}
