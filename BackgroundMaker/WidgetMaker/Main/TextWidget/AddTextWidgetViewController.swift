//
//  AddTextWidgetViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/17.
//

import UIKit
import SnapKit
import Photos



protocol AddTextWidgetViewControllerDelegate {
    func addTextWidget(widget: TextWidget)
}

class AddTextWidgetViewController: UIViewController {
    
    private let coredataContext = CoreData.shared.persistentContainer.viewContext

    var delegate: AddTextWidgetViewControllerDelegate?
    
    //MARK: - View Properties
    
    private lazy var contentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()


    private let previewImageView: UIImageView = {
        let iv = ViewModel.shared.makeImageView(
            image: nil, contentMode: .scaleAspectFit
        )
        ViewModel.shared.makeLayerShadow(to: iv.layer)

        
        return iv
    }()
    
    private let segment: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["텍스트 위젯"])
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.setTitleTextAttributes(
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .semibold)],
            for: .normal
        )
        seg.selectedSegmentIndex = 0
        
        return seg
    }()
    
    private let sampleIconTitle: UILabel = ViewModel.shared.makeLabel(
        text: "텍스트 위젯 추가",
        color: .white,
        fontSize: 20,
        fontWeight: .bold,
        alignment: .center
    )
    
    
    //MARK: - AddView
    
    private var name: String?
    private var nameLabel: UILabel = ViewModel.shared.makeLabel(
        text: "위젯 텍스트", color: .white, fontSize: 20, fontWeight: .bold, alignment: .left)
    private var nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "잠금화면에 표시할 텍스트"
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

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewUI()
        previewImageView.image = UIColor.white.image()
        previewImageView.contentMode = .scaleAspectFill
        
        nameTextField.delegate = self
    }
    
    //MARK: - Selectors

    
    @objc private func closeButtonTapped(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func addButtonTapped(sender: UIButton) {
        
        if let name = nameTextField.text {
            
            var alert = UIAlertController()
            let action = UIAlertAction(title: "확인", style: .default)
            
            if name == "" {
                alert = ViewModel.shared.makeAlert(alertTitle: "입력 확인", alertMessage: "텍스트를 입력해 주세요.", actions: [action])
                present(alert, animated: true)

                return
            }
            
            let item = TextWidget(context: coredataContext)
            item.id = UUID()
            item.text = name
            item.addedDate = Date()
            
            delegate?.addTextWidget(widget: item)
            self.navigationController?.popViewController(animated: true)
            
        } else {
            print("데이터 없음")
            fatalError("데이터없음")
        } 
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
        
        contentView.backgroundColor = AppColors.blackDarkGrey
        
        let iconImageViewHeight: CGFloat = UIScreen.main.bounds.width / 4

        contentView.addSubview(previewImageView)
        

        
        ViewModel.shared.cropCornerRadius(view: previewImageView)
        
        let labelHeight: CGFloat = 30
        let textFieldHeight: CGFloat = 40
        
        // 위젯이름 (Label, TextField)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        ViewModel.shared.makeLayerShadow(to: nameLabel.layer)
        ViewModel.shared.makeLayerShadow(to: nameTextField.layer)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(previewImageView.snp.bottom).inset(-spacing)
            make.leading.trailing.equalTo(contentView).inset(insets.leadingTrailing)
            make.height.equalTo(labelHeight)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).inset(-spacing)
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(textFieldHeight)
        }
        let previewImageViewHeight: CGFloat = 70
        let previewImageViewWidth: CGFloat = 140

        previewImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(insets.top)
            make.centerX.equalTo(view)
            make.height.equalTo(previewImageViewHeight)
            make.width.equalTo(previewImageViewWidth)
        }

        // Button Layout
        let contentAndButtonSpacing: CGFloat = -36
        let buttonSpacing: CGFloat = 12
        let buttonHeight: CGFloat = 40
        
        contentView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).inset(contentAndButtonSpacing)
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(buttonHeight)
        }
        
        contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).inset(-buttonSpacing)
            make.leading.trailing.equalTo(nameLabel)
            make.height.equalTo(buttonHeight)
        }
        
    }
}

extension AddTextWidgetViewController: IconCollectionViewControllerDelegate {
    func iconSelected(icon: UIImage) {
        self.previewImageView.image = icon
    }
}

extension AddTextWidgetViewController: UITextFieldDelegate {
    
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

