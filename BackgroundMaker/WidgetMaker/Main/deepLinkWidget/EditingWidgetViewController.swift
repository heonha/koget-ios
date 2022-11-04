//
//  EditWidgetViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/15.
//

import UIKit
import SnapKit
import CoreData

protocol EditWidgetViewControllerDelegate {
    func editingSucessful(data: DeepLink)
    func deleteDeepLink(data: DeepLink)
}

class EditWidgetViewController: UIViewController {
    
    let coredataContext = CoreData.shared.persistentContainer.viewContext
    
    private var selectedWidget: DeepLink
    
    var delegate: EditWidgetViewControllerDelegate?
    
    var textFieldMode: TextFieldMode = .viewMode
    var textFieldEnableAnimationDuration: CGFloat = 1
    
    
    //MARK: - Blur Properties
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)

    var backgroundAnimationDuration: CGFloat = 1
    
    lazy var blurredView: UIView = {
        // 1. create container view
        let containerView = UIView()
        // 2. create custom blur view
        let blurEffect = UIBlurEffect(style: .light)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
        customBlurEffectView.frame = self.view.bounds
        // 3. create semi-transparent black view
        let dimmedView = UIView()
        dimmedView.backgroundColor = .black.withAlphaComponent(0.6)
        dimmedView.frame = self.view.bounds
        
        // 4. add both as subviews
        containerView.addSubview(customBlurEffectView)
        containerView.addSubview(dimmedView)
        return containerView
    }()
    
    //MARK: - Properties
    
    private let imageEditEnableImageView: UIImageView = {
        let iv = ViewModel.shared.makeImageView(
            image: UIImage(named: "plus.circle.fill.purple"), contentMode: .scaleAspectFit
        )
        iv.backgroundColor = .white
        return iv
    }()
    
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
        btn.isUserInteractionEnabled = false

        return btn
    }()
    
    private let viewTitle: UILabel = ViewModel.shared.makeLabel(
        text: "딥 링크 위젯",
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
    private lazy var editHandlerButton: UIButton = ViewModel.shared.makeButtonForWidgetHandler(
        target: self, action: #selector(editHandlerButtonTapped),
        title: "편집하기")
   
    // - 취소 버튼
    private lazy var closeButton: UIButton = ViewModel.shared.makeButtonForWidgetHandler(
        target: self, action: #selector(closeButtonTapped),
        title: "돌아가기", backgroundColor: .darkGray)

    // - 삭제 버튼
    private lazy var deleteButton: UIButton = ViewModel.shared.makeButtonForWidgetHandler(
        target: self, action: #selector(deleteButtonTapped),
        title: "삭제", backgroundColor: .red)


    
    //MARK: - Initialize
    
    init(selectedWidget: DeepLink) {
        self.selectedWidget = selectedWidget
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurredView.isHidden = true
        // 6. add blur view and send it to back
        view.addSubview(blurredView)
        view.sendSubviewToBack(blurredView)
        addPanGesture(selector: #selector(panGestureRecognizerHandler))
        configureUI()
        disableEditingMode(animatedDuration: 0)
        viewTitle.text = selectedWidget.name!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureViewUI()
        setSelectedWidget()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setbackgroundAnimation()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: backgroundAnimationDuration) {
            self.blurredView.isHidden = true
        }
    }
    
    func setbackgroundAnimation() {
        UIView.animate(withDuration: backgroundAnimationDuration) {
            self.blurredView.isHidden = false
        }
    }
    
    func setSelectedWidget() {
        self.iconImageView.image = UIImage(data: selectedWidget.image!)!
        self.nameTextField.text = selectedWidget.name!
        self.urlTextField.text = selectedWidget.deepLink!
    }
    
    //MARK: - Selectors
    
    enum TextFieldMode {
        case editing
        case viewMode
    }
    

    @objc private func deleteButtonTapped(sender: UIButton) {
        
        let delete = UIAlertAction(title: "삭제하기", style: .default) { _ in
            self.dismiss(animated: true)
            self.delegate?.deleteDeepLink(data: self.selectedWidget)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        let appName = selectedWidget.name ?? "딥 링크"
        let alert = ViewModel.shared.makeAlert(alertTitle: "\(appName) 위젯 삭제", alertMessage: " 위젯을 정말 삭제하시겠습니까? \n(앱은 삭제되지 않습니다.)", actions: [delete, cancel])
        present(alert, animated: true)

    }
    
    @objc private func closeButtonTapped(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    /// 편집하기 / 수정완료의 액션을 수행합니다.
    @objc private func editHandlerButtonTapped(sender: UIButton) {
        
        // 현재 편집할수 없는 모드(view)라면
        // 현재 TextField 모드를 편집모드로 바꿉니다.
        // 텍스트필드를 편집가능하게 합니다.
        // 버튼을 재구성합니다. (색상, 이름변경)
        if textFieldMode == .viewMode {
            self.textFieldMode = .editing
            ViewModel.shared.setAttibuteTitleForButton(title: "수정완료", button: editHandlerButton)
            editHandlerButton.backgroundColor = .systemPink
            self.enableEditingButtonTapped(animationDuration: textFieldEnableAnimationDuration)
            return
        }
                
        if let name = nameTextField.text, let deeplink = self.urlTextField.text {
            
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
                alert = ViewModel.shared.makeAlert(alertTitle: "아이콘 확인", alertMessage: "아이콘을 선택해 주세요.", actions: [action])
                present(alert, animated: true)
                return
            }
            
            let img: Data = {
                let img = image
                let dataImage = img.pngData()
                print(dataImage!)
                return dataImage!
            }()
            
            let item = selectedWidget
            item.name = name
            item.image = img
            item.deepLink = deeplink
            
            delegate?.editingSucessful(data: item)
            
            textFieldMode = .viewMode
            editHandlerButton.backgroundColor = AppColors.buttonPurple
            ViewModel.shared.setAttibuteTitleForButton(
                title: "편집하기", button: editHandlerButton)
            disableEditingMode(animatedDuration: textFieldEnableAnimationDuration)
            viewWillAppear(false)
            
        } else {
            let action = UIAlertAction(title: "확인", style: .default) { _ in
                self.dismiss(animated: true)
            }
            let alert = ViewModel.shared.makeAlert(alertTitle: "편집 오류", alertMessage: "알 수 없는 오류가 발생했습니다. \n 사유: 데이터없음", actions: [action])
            present(alert, animated: true)
        }
        
        
    }
    
    private func disableEditingMode(animatedDuration: CGFloat = 2) {
        UIView.animate(withDuration: animatedDuration) {
            self.imageEditEnableImageView.isHidden = true
            self.imageEditEnableImageView.isHidden = true

        }
        UIView.animate(withDuration: animatedDuration / 2) {
            self.nameTextField.backgroundColor = self.contentView.backgroundColor
            self.urlTextField.backgroundColor = self.contentView.backgroundColor
        }
        self.nameTextField.isEnabled = false
        self.urlTextField.isEnabled = false
        self.iconImageViewButton.isUserInteractionEnabled = false
    }


    
    
    
    private func enableEditingButtonTapped(animationDuration: CGFloat = 2) {
        
        UIView.animate(withDuration: animationDuration) {
            self.imageEditEnableImageView.isHidden = false
            self.imageEditEnableImageView.isHidden = false
        }
        
        UIView.animate(withDuration: animationDuration / 2) {
            self.nameTextField.backgroundColor = .darkGray
            self.urlTextField.backgroundColor = .darkGray
        }
        
        self.nameTextField.isEnabled = true
        self.urlTextField.isEnabled = true
        self.iconImageViewButton.isUserInteractionEnabled = true
   
    }
    
    

    
    @objc private func pickerButtonTapped() {
        print("Picker Button Tapped")
        let alert = UIAlertController(title: "아이콘 이미지 편집", message: "아이콘으로 사용할 이미지를 가져옵니다.", preferredStyle: .alert)
        let albumImageAction = UIAlertAction(title: "앨범 이미지", style: .default)  { _ in
            print("앨범 이미지")
            self.presentPhotoPicker()
        }
        let appImageAction = UIAlertAction(title: "기본 이미지", style: .default) { _ in
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
        view.backgroundColor = .clear
        
    }
    
    
    
    //MARK: - Methods
    
    private func configureViewUI() {
        
        nameTextField.delegate = self
        urlTextField.delegate = self
        
        let contentViewSize = CGSize(width: 350, height: 430)
        ViewModel.shared.cropCornerRadius(view: contentView, radius: 12)
        ViewModel.shared.makeLayerShadow(to: contentView.layer)

        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(contentViewSize.height)
            make.width.equalTo(contentViewSize.width)
        }
        
        contentView.addSubview(viewTitle)
        ViewModel.shared.makeLayerShadow(to: viewTitle.layer)
        viewTitle.backgroundColor = AppColors.buttonPurple
        // Title
        let viewTitleHeight: CGFloat = 40
        viewTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(viewTitleHeight)
        }
        
        // Layout Values
        let insets: (top: CGFloat, leadingTrailing: CGFloat) = (16, 16)
        let spacing: CGFloat = -8
        let labelHeight: CGFloat = 20
        let textFieldHeight: CGFloat = 30
        let buttonHeight: CGFloat = 35
        
        
        contentView.backgroundColor = AppColors.blackDarkGrey
        ViewModel.shared.makeLayerShadow(to: contentView.layer, offset: 3, opacity: 5)

        let iconImageViewHeight: CGFloat = contentViewSize.height * 0.22
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(imageEditEnableImageView)
        contentView.addSubview(iconImageViewButton)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(viewTitle.snp.bottom).inset(spacing)
            make.centerX.equalTo(contentView)
            make.height.equalTo(iconImageViewHeight)
            make.width.equalTo(iconImageViewHeight)
        }
        ViewModel.shared.cropCornerRadius(view: iconImageView, radius: iconImageViewHeight / 2)

        
        let imageEditEnableImageViewHeight: CGFloat = iconImageViewHeight / 4
        imageEditEnableImageView.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(iconImageView).inset(-8)
            make.width.height.equalTo(imageEditEnableImageViewHeight)
        }
        ViewModel.shared.cropCornerRadius(view: imageEditEnableImageView, radius: imageEditEnableImageViewHeight / 2)

        
        
        
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
        contentView.addSubview(editHandlerButton)
        
        editHandlerButton.snp.makeConstraints { make in
            make.top.equalTo(urlTextField.snp.bottom).inset(-20)
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(buttonHeight)
        }
        
        contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(editHandlerButton.snp.bottom).inset(spacing)
            make.leading.trailing.equalTo(editHandlerButton)
            make.height.equalTo(buttonHeight)
        }
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).inset(spacing)
            make.leading.trailing.equalTo(editHandlerButton)
            make.height.equalTo(buttonHeight)
        }
    }
}
extension EditWidgetViewController: IconCollectionViewControllerDelegate {
    func iconSelected(icon: UIImage) {
        self.iconImageView.image = icon
    }
}



// MARK: - background Blur Methods
extension EditWidgetViewController {
    
    private func showDetailAction(sender: Any?){
        if let infoViewController = storyboard?.instantiateViewController(identifier: "InfoViewController") {
            infoViewController.modalPresentationStyle = .overCurrentContext
            infoViewController.modalTransitionStyle = .crossDissolve
            present(infoViewController, animated: true)
        }
    }
    
    private func addPanGesture(selector: Selector) {
        let gesture = UIPanGestureRecognizer(target: self, action: selector)
        self.view.addGestureRecognizer(gesture)
    }
    

    @objc private func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        // 시작점
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed { // 이동함
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
   

}
extension EditWidgetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func presentPhotoPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true)
    }
    
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


extension EditWidgetViewController: UITextFieldDelegate {
    
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
