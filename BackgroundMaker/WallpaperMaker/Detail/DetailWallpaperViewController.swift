//
//  DetailWallpaperViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/31.
//

import UIKit
import SnapKit
import CoreData
import Lottie

protocol DetailWallpaperViewControllerDelegate {
    func detailViewWillDisappear()
}

class DetailWallpaperViewController: UIViewController {
    
    let coredataContext = CoreData.shared.persistentContainer.viewContext
    
    private var selectedWallpaper: Wallpaper
    
    var delegate: DetailWallpaperViewControllerDelegate?
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    var backgroundAnimationDuration: CGFloat = 1
    
    let downArrowAnimation = LottieAnimationView(name: "downArrow.json")
    
    //MARK: - Init
    
    init(selected: Wallpaper) {
        self.selectedWallpaper = selected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    
    
    
    private let viewTitle: UILabel = ViewModelForCocoa.shared.makeLabel(
        text: "미리보기",
        color: .white,
        fontSize: 20,
        fontWeight: .bold,
        alignment: .center
    )
    
    private let wallpaperView: UIImageView = {
        let iv = ViewModelForCocoa.shared.makeImageView(
            image: UIImage(named: "plus.circle"), contentMode: .scaleAspectFit
        )
        ViewModelForCocoa.shared.cropCornerRadius(view: iv)
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private let placeHolderView: UILabel = {
        let iv = ViewModelForCocoa.shared.makeLabel(
            text: "이미지를 가져오는 중...", fontSize: 18, fontWeight: .bold)
        return iv
    }()
    
    lazy var lockScreenView: UIView = {

        
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.contentMode = .center
        sv.distribution = .equalCentering
        sv.spacing = 0
        
        self.view.addSubview(sv)

        let clock = ViewModelForCocoa.shared.makeLabel(text: "12:30", fontSize: 105, fontWeight: .bold)
        let date = ViewModelForCocoa.shared.makeLabel(text: "12월 30일 금요일", fontSize: 25, fontWeight: .medium)
        
        let deviceSize = UIDevice.current.isiPhoneWithNotch

        
        sv.addArrangedSubview(date)
        sv.addArrangedSubview(clock)
        sv.alpha = 0.9
        
        return sv
    }()
    
    private lazy var showButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(showMenuAction), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var buttonBlurView = UIView()
    
    lazy var saveButton: UIButton = {
        let button = ViewModelForCocoa.shared.makeButtonWithTitleAndTarget(title: "앨범에 저장", action: #selector(saveImage), target: self, backgroundColor: .clear)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        ViewModelForCocoa.shared.cropCornerRadius(view: button)
        button.alpha = 0
        
        return button
    }()
    
    lazy var guideLabel: UILabel = {
        let label = ViewModelForCocoa.shared.makeLabel(text: "아래로 내려서 닫기", fontSize: 19, fontWeight: .semibold)
        ViewModelForCocoa.shared.makeLayerShadow(to: label.layer)
        label.alpha = 0
        
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let action = UIAction { _ in
            self.deleteButtonPressed()
        }
        
        let redColor = UIColor(red: 0.914, green: 0.243, blue: 0.208, alpha: 1.000)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(named: "trash.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.addAction(action, for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        button.alpha = 0
        ViewModelForCocoa.shared.makeLayerShadow(to: button.layer, radius: 1)

        
        return button
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainView()
        configureWallpaperView()
        configureShowButton()
        configureDownArrow()
        configureSaveButton()
        setBlurButtonView()
        addPanGesture(selector: #selector(panGestureRecognizerHandler))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showMenuAction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.detailViewWillDisappear()
    }
    
    /// 사진을 디바이스에 저장하는 메소드입니다.
    private func saveImageToAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaveHandler), nil)
    }
    
    /// 사진 저장 처리결과를 Alert로 Present합니다.
    @objc func imageSaveHandler(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        /// 앨범에 사진 저장이 성공 / 실패 했을 때 알럿을 띄웁니다.
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let apply = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        if let error = error {
            /// 사진 접근권한 확인을 위해 앱의 설정 화면으로 가는 딥링크를 만듭니다.
            let setting = UIAlertAction(title: "설정하기", style: .default) { _ in
                self.openUserAppSettings()
            }
            alert.addAction(setting)
            print("ERROR: \(error)")
            alert.title = "저장 실패"
            alert.message = "사진 저장이 실패했습니다. 아래 설정버튼을 눌러 사진 접근 권한을 확인해주세요."
            return
        } else {
            alert.title = "저장 성공"
            alert.message = "앨범에서 저장된 사진을 확인하세요."
            
        }
        alert.addAction(apply)
        present(alert, animated: true)
    }
    
    /// 앱의 접근권한 확인을 위해 앱의 설정 화면으로 가는 딥링크를 만듭니다.
    func openUserAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func configureSaveButton() {
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        view.addSubview(buttonBlurView)
        buttonBlurView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(guideLabel.snp.top).inset(-16)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.edges.equalTo(buttonBlurView)
        }
        
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(30)
        }
        
        
        view.addSubview(lockScreenView)
        lockScreenView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(44)
            make.centerX.equalTo(view)
        }
    }
    
    
    @objc private func saveImage() {
        if saveButton.alpha == 1 {
            saveImageToAlbum(image: self.wallpaperView.image!)
        } else {
            return
        }
    }
    
    
    @objc private func showMenuAction() {
        print("show Menu Action Tapped...")
        // self.view.layoutIfNeeded()
        
        if self.saveButton.alpha == 0 {
            UIView.animateKeyframes(withDuration: 0.1, delay: 0) {
                self.saveButton.alpha = 1
                self.buttonBlurView.alpha = 1
                self.deleteButton.alpha = 1
                self.guideLabel.alpha = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                if self.saveButton.alpha == 1 {
                    UIView.animate(withDuration: 0.2) {
                        self.saveButton.alpha = 0
                        self.buttonBlurView.alpha = 0
                        self.deleteButton.alpha = 0
                        self.guideLabel.alpha = 0


                    }
                }
            }
            
        } else {
            UIView.animateKeyframes(withDuration: 0.1, delay: 0) {
                self.saveButton.alpha = 0
                self.buttonBlurView.alpha = 0
                self.deleteButton.alpha = 0
                self.guideLabel.alpha = 0

            }
        }
        
    }
    
    
    
    private func configureShowButton() {
        view.addSubview(showButton)
        showButton.snp.makeConstraints { make in
            make.edges.equalTo(wallpaperView)
        }
        
    }
    
    
    private func configureMainView() {
        view.backgroundColor = .clear
    }
    
    private func configureWallpaperView() {
        view.addSubview(wallpaperView)
        wallpaperView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let image = UIImage(data: selectedWallpaper.wallpaper!) ?? UIImage(named: "questionmark.circle")!
        wallpaperView.image = image
    }
    

    @objc func deleteButtonPressed() {
        WallpaperCoreData.shared.deleteData(data: self.selectedWallpaper)
        self.dismiss(animated: true)
    }
    
    func configureDownArrow() {
        view.addSubview(downArrowAnimation)
        downArrowAnimation.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(60)

            make.centerX.equalToSuperview()
            make.bottom.equalTo(view).inset(8)
        }
        
        downArrowAnimation.contentMode = .scaleAspectFit
        downArrowAnimation.loopMode = .loop
        downArrowAnimation.animationSpeed = 1
        downArrowAnimation.play()

    }
    
    func setBlurButtonView() {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0.5
        buttonBlurView.insertSubview(blurView, at: 0)
        blurView.snp.makeConstraints { make in
            make.edges.equalTo(buttonBlurView)
        }
        
        blurView.layer.cornerRadius = 10.0
        blurView.clipsToBounds = true
        

    }
    
    
    
}


extension DetailWallpaperViewController {
    
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


