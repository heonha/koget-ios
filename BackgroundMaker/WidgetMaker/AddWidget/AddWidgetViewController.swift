//
//  AddWidgetViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/30.
//

import UIKit
import SnapKit
import Photos

// CoreData 추가하기
// [] Data Model 만들기
// [] CoreData 메소드 만들기
// [] 커스텀 이미지, 일반 아이콘 이미지 로 설정할 수 있도록 선택지 추가.

protocol AddWidgetViewControllerDelegate {
    func addDeepLinkWidget(widget: DeepLink)
}

class AddWidgetViewController: UIViewController {
    
    private let coredataContext = CoreData.shared.persistentContainer.viewContext

    var delegate: AddWidgetViewControllerDelegate?
    
    //MARK: - Properties
    
    private let iconImageView: UIImageView = {
        let iv = ViewModel.shared.makeImageView(
            image: UIImage(named: "plus.circle"), contentMode: .scaleAspectFit
        )
        ViewModel.shared.makeLayerShadow(to: iv.layer)

        
        return iv
    }()
    
    private lazy var iconImageViewButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(pickerButtonTapped), for: .touchDown)

        return btn
    }()
    
    private let segment: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["커스텀 위젯", "위젯 고르기"])
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.setTitleTextAttributes(
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .semibold)],
            for: .normal
        )
        
        return seg
    }()
    
    
    private let sampleIconTitle: UILabel = ViewModel.shared.makeLabel(
        text: "위젯 추가하기",
        color: .white,
        fontSize: 20,
        fontWeight: .bold,
        alignment: .center
    )
    
    private lazy var contentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - AddView
    
    // [Todo]
    // - 이름
    private var name: String?
    private var nameLabel: UILabel = ViewModel.shared.makeLabel(
        text: "위젯 이름", color: .white, fontSize: 18, fontWeight: .bold, alignment: .left)
    private var nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "위젯 이름"
        tf.backgroundColor = .darkGray
        ViewModel.shared.cropCornerRadius(view: tf, radius: 5)
        ViewModel.shared.makeLayerShadow(to: tf.layer)
        
        return tf
    }()
    
    
    // - URL
    private var url: String?
    private var urlLabel: UILabel = ViewModel.shared.makeLabel(text: "딥링크 URL", color: .white, fontSize: 18, fontWeight: .bold, alignment: .left)
    private var urlTextField: UITextField = {
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
    private lazy var button: UIButton = ViewModel.shared.makeButtonForWidgetHandler(
        target: self, action: #selector(addButtonTapped), title: "추가하기")
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewUI()
    }
    
    //MARK: - Selectors
    @objc private func addButtonTapped(sender: UIButton) {
        
        if let name = nameTextField.text, let deeplink = self.urlTextField.text {
            
            
            var alert = UIAlertController()
            let action = UIAlertAction(title: "확인", style: .default)
            
            if name == "" {
                alert = makeAlert(alertTitle: "입력 확인", alertMessage: "이름을 확인해 주세요.", actions: [action])
                present(alert, animated: true)

                return
            }
            
            if deeplink == "" {
                alert = makeAlert(alertTitle: "입력 확인", alertMessage: "딥링크 주소를 확인해 주세요.", actions: [action])
                present(alert, animated: true)

                return
            }

            guard let image = iconImageView.image else {
                alert = makeAlert(alertTitle: "아이콘 확인", alertMessage: "아이콘을 선택해 주세요.", actions: [action])
                present(alert, animated: true)
                return
            }
            
            let img: Data = {
                let img = image
                let dataImage = img.pngData()
                print(dataImage!)
                return dataImage!
            }()
            
            let item = DeepLink(context: coredataContext)
            item.id = UUID()
            item.name = name
            item.image = img
            item.deepLink = deeplink
            
            delegate?.addDeepLinkWidget(widget: item)
            self.navigationController?.popViewController(animated: true)
            
        } else {
            print("데이터 없음")
            fatalError("데이터없음")
        }
        
 
    }

    
    private func makeAlert(alertTitle: String, alertMessage: String, actions: [UIAlertAction]? ) -> UIAlertController {
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        
        return alert
    }

    
    @objc private func pickerButtonTapped() {
        print("Picker Button Tapped")
        let alert = UIAlertController(title: "이미지 선택", message: "아이콘으로 사용할 이미지를 가져옵니다.", preferredStyle: .alert)
        let albumImageAction = UIAlertAction(title: "앨범 이미지", style: .default)  { _ in
            print("앨범 이미지")
        }
        let appImageAction = UIAlertAction(title: "기본 이미지", style: .default) { _ in
            print("기본 이미지")
            
            let vc = IconCollectionViewController()
            vc.delegate = self
            self.present(vc, animated: true)
            
        }
        alert.addAction(albumImageAction)
        alert.addAction(appImageAction)
        present(alert, animated: true)
        
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = AppColors.buttonPurple
        
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


    
    //MARK: - Methods
    
    private func configureViewUI() {

        // Layout Values
        let insets: (top: CGFloat, leadingTrailing: CGFloat) = (16, 16)
        let spacing: CGFloat = -8
        let labelHeight: CGFloat = 30
        let textFieldHeight: CGFloat = 40
        let buttonHeight: CGFloat = 35
        
        
        contentView.backgroundColor = AppColors.blackDarkGrey
        
        let iconImageViewHeight: CGFloat = UIScreen.main.bounds.width / 4

        contentView.addSubview(iconImageView)
        contentView.addSubview(iconImageViewButton)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(insets.top)
            make.centerX.equalTo(contentView)
            make.height.equalTo(iconImageViewHeight)
            make.width.equalTo(iconImageViewHeight)

        }
        
        ViewModel.shared.cropCornerRadius(view: iconImageView, radius: iconImageViewHeight / 2)

        
        iconImageViewButton.snp.makeConstraints { make in
            make.edges.equalTo(iconImageView)
        }
        
        
        
        
        // 위젯이름 (Label, TextField)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        ViewModel.shared.makeLayerShadow(to: nameLabel.layer)
        ViewModel.shared.makeLayerShadow(to: nameTextField.layer)

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).inset(spacing)
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

extension AddWidgetViewController: IconCollectionViewControllerDelegate {
    func iconSelected(icon: UIImage) {
        self.iconImageView.image = icon
    }
}
