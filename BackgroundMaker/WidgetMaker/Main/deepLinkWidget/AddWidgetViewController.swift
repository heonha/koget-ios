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
// [v] Data Model 만들기
// [v] CoreData 메소드 만들기
// [진행중] 커스텀 이미지, 일반 아이콘 이미지 로 설정할 수 있도록 선택지 추가.

protocol AddWidgetViewControllerDelegate {
    func addDeepLinkWidget(widget: DeepLink)
}

class AddWidgetViewController: UIViewController {
    
    private let coredataContext = CoreData.shared.persistentContainer.viewContext

    var delegate: AddWidgetViewControllerDelegate?
    
    //MARK: - View Properties
    
    private lazy var contentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    
    private let iconPlaceHolderImageView: UIImageView = {
        let iv = ViewModel.shared.makeImageView(
            image: UIImage(named: "plus.circle"), contentMode: .scaleAspectFit
        )
        ViewModel.shared.makeLayerShadow(to: iv.layer)

        
        return iv
    }()
    
    private let iconImageView: UIImageView = {
        let iv = ViewModel.shared.makeImageView(
            image: nil, contentMode: .scaleAspectFit
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
        let seg = UISegmentedControl(items: ["커스텀 위젯"])
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.setTitleTextAttributes(
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .semibold)],
            for: .normal
        )
        seg.selectedSegmentIndex = 0
        
        return seg
    }()
    
    private let sampleIconTitle: UILabel = ViewModel.shared.makeLabel(
        text: "위젯 추가하기",
        color: .white,
        fontSize: 20,
        fontWeight: .bold,
        alignment: .center
    )
    
    
    //MARK: - AddView
    
    private var name: String?
    private var nameLabel: UILabel = ViewModel.shared.makeLabel(
        text: "위젯 이름", color: .white, fontSize: 20, fontWeight: .bold, alignment: .left)
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
    private var deepLinkURL: String?
    private var deepLinkLabel: UILabel = ViewModel.shared.makeLabel(text: "딥링크 URL", color: .white, fontSize: 20, fontWeight: .bold, alignment: .left)
    private var deepLinkTextField: UITextField = {
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
    private lazy var addButton: UIButton = ViewModel.shared.makeButtonForWidgetHandler(
        target: self, action: #selector(addButtonTapped), title: "추가하기")
    
    // - 취소 버튼
    private lazy var closeButton: UIButton = ViewModel.shared.makeButtonForWidgetHandler(
        target: self, action: #selector(closeButtonTapped),
        title: "돌아가기", backgroundColor: .darkGray)
    
    private lazy var builtInAppButton: UIButton = ViewModel.shared.makeButtonForWidgetHandler(
        target: self, action: #selector(showBuiltInList), title: "앱 리스트에서 불러오기")

    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewUI()
        
        nameTextField.delegate = self
        deepLinkTextField.delegate = self
    }
    
    //MARK: - Selectors
    @objc private func showBuiltInList(sender: UIButton) {
        let vc = BuiltInWidgetViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    @objc private func closeButtonTapped(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func addButtonTapped(sender: UIButton) {
        
        if let name = nameTextField.text, var deeplink = self.deepLinkTextField.text {
            
            
            var alert = UIAlertController()
            let action = UIAlertAction(title: "확인", style: .default)
            
            if name == "" {
                alert = ViewModel.shared.makeAlert(alertTitle: "입력 확인", alertMessage: "이름을 확인해 주세요.", actions: [action])
                present(alert, animated: true)

                return
            }
            
            if deeplink == "" {
                alert = ViewModel.shared.makeAlert(alertTitle: "입력 확인", alertMessage: "딥링크 주소를 확인해 주세요.", actions: [action])
                present(alert, animated: true)

                return
            }

            guard let image = iconImageView.image else {
                alert = ViewModel.shared.makeAlert(alertTitle: "아이콘 이미지 확인", alertMessage: " + 를 눌러 이미지를 선택해 주세요.", actions: [action])
                present(alert, animated: true)
                return
            }
            
            let img: Data = {
                let img = image
                let dataImage = img.pngData()
                print(dataImage!)
                return dataImage!
            }()
            
            if !deeplink.contains("://") {
                deeplink += "://"
            }
            
            let item = DeepLink(context: coredataContext)
            item.id = UUID()
            item.name = name
            item.image = img
            item.deepLink = deeplink
            item.addedDate = Date()
            
            delegate?.addDeepLinkWidget(widget: item)
            self.dismiss(animated: true)
            
        } else {
            print("데이터 없음")
            fatalError("데이터없음")
        }
        
 
    }

    private func presentPhotoPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true)
    }
    
    @objc private func pickerButtonTapped() {
        print("Picker Button Tapped")
        let alert = UIAlertController(title: "아이콘 이미지 선택", message: "아이콘으로 사용할 이미지를 가져옵니다.", preferredStyle: .alert)
        let albumImageAction = UIAlertAction(title: "앨범에서 가져오기", style: .default)  { _ in
            print("앨범 이미지")
            self.presentPhotoPicker()
        }
        let appImageAction = UIAlertAction(title: "아이콘 목록보기", style: .default) { _ in
            print("기본 이미지")
            
            let vc = IconCollectionViewController()
            vc.delegate = self
            self.present(vc, animated: true)
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .default)  { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(albumImageAction)
        alert.addAction(appImageAction)
        alert.addAction(cancelAction)

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
        let spacing: CGFloat = 8

        
        
        contentView.backgroundColor = AppColors.deepDarkGrey
        
        let iconImageViewHeight: CGFloat = UIScreen.main.bounds.width / 4

        contentView.addSubview(iconPlaceHolderImageView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(iconImageViewButton)
        
        iconPlaceHolderImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(insets.top)
            make.centerX.equalTo(contentView)
            make.height.equalTo(iconImageViewHeight)
            make.width.equalTo(iconImageViewHeight)
        }
        
        
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
        
        
        let labelHeight: CGFloat = 30
        let textFieldHeight: CGFloat = 40
        
        
        // 위젯이름 (Label, TextField)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        ViewModel.shared.makeLayerShadow(to: nameLabel.layer)
        ViewModel.shared.makeLayerShadow(to: nameTextField.layer)

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).inset(-spacing)
            make.leading.trailing.equalTo(contentView).inset(insets.leadingTrailing)
            make.height.equalTo(labelHeight)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).inset(-spacing)
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(textFieldHeight)
        }
        
        // URL (Label, TextField)
        contentView.addSubview(deepLinkLabel)
        contentView.addSubview(deepLinkTextField)
        ViewModel.shared.makeLayerShadow(to: deepLinkLabel.layer)
        ViewModel.shared.makeLayerShadow(to: deepLinkTextField.layer)


        deepLinkLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).inset(-spacing)
            make.leading.trailing.equalTo(contentView).inset(insets.leadingTrailing)
            make.height.equalTo(labelHeight)
        }
        
        deepLinkTextField.snp.makeConstraints { make in
            make.top.equalTo(deepLinkLabel.snp.bottom).inset(-spacing)
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(textFieldHeight)
        }
        
        // Button Layout
        let contentAndButtonSpacing: CGFloat = -36
        let buttonSpacing: CGFloat = 12
        let buttonHeight: CGFloat = 40
        
        contentView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(deepLinkTextField.snp.bottom).inset(contentAndButtonSpacing)
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(buttonHeight)
        }
        
        contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).inset(-buttonSpacing)
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(buttonHeight)
        }
        
        contentView.addSubview(builtInAppButton)
        builtInAppButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(insets.leadingTrailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(-contentAndButtonSpacing)
            make.height.equalTo(buttonHeight)
        }
        
    }
}

extension AddWidgetViewController: IconCollectionViewControllerDelegate {
    func iconSelected(icon: UIImage) {
        self.iconImageView.image = icon
    }
}

extension AddWidgetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[.editedImage] as? UIImage {
            self.iconImageView.image = image
            dismiss(animated: true)
        } else {
            print("에러")
            dismiss(animated: true)
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("선택한 이미지 없음")

    }
}


extension AddWidgetViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // textField 편집후 Return키를 눌렀을 때 동작.
        textField.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}


extension AddWidgetViewController: BuiltInWidgetViewControllerDelegate {
    func selectedBuiltInApp(data: BuiltInDeepLink) {
        print("데이터 받음 : \(data)")
        
        self.iconImageView.image = data.image
        self.nameTextField.text = data.appNameGlobal
        self.deepLinkTextField.text = data.deepLink
        
    }
    
    
}
