//
//  WidgetViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/30.
//

import UIKit
import SnapKit
import WidgetKit


struct Icon {
    let imageName: String
    lazy var image: UIImage = {
        let img = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal).grayscaled
        ?? UIImage(systemName:  imageName)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        ?? UIColor.blue.image()
        return img
    }()
}

class WidgetViewController: UIViewController {
    
    //MARK: - Properties
    
    var icons: [Icon] = [
        Icon(imageName: "mainBG"),
        Icon(imageName: "Test2"),
        Icon(imageName: "crop"),
        Icon(imageName: "youtube")

    ]
    
    let linkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "딥 링크 주소"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    let linkTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " 딥링크 입력 (예시 youtube:// )"
        textField.backgroundColor = .darkGray
        textField.textColor = .white
        ViewModel.shared.cropCornerRadius(view: textField)
        
        return textField
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        button.setTitle("만들기", for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchDown)
        
        ViewModel.shared.cropCornerRadius(view: button)
        
        return button
        
    }()
    
    let iconCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal // 스크롤 방향
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(WidgetIconCell.self, forCellWithReuseIdentifier: WidgetIconCell.reuseID)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .brown
        
        return cv
    }()
    
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "위젯 만들기"
        self.navigationItem.largeTitleDisplayMode = .always
        
        configureUI()
        
    }
    
    //MARK: - Selectors
    @objc func sendButtonTapped(sender: UIButton) {
        print("Send Button Tapped")
        widgetGetData()
    }
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .black
        
        view.addSubview(linkLabel)
        view.addSubview(linkTextField)
        view.addSubview(iconCollectionView)
        view.addSubview(addButton)
        
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        
        linkLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(40)
        }
        
        linkTextField.snp.makeConstraints { make in
            make.top.equalTo(linkLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(45)
            make.width.equalToSuperview().inset(20)
        }
        
        iconCollectionView.snp.makeConstraints { make in
            make.top.equalTo(linkTextField.snp.bottom).inset(-16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(iconCollectionView.snp.bottom).inset(-16)
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
    }
    
    
    
    //MARK:  - AppGroup Utils
    
    func setPreferenceValue(_ value: Any?, forKey key: String, in appGroup: String) {
        
        if let groupUserDefaults = UserDefaults(suiteName: appGroup) {
            
            groupUserDefaults.set(value, forKey: key)
            print("SAVE.")
        }
    }
    
    @objc func loadPreferenceValue() {
        if let groupUserDefaults = UserDefaults(suiteName: APP_GROUP_ID) {
            
            // 3c) Write the value for the given key
            // to our shared container.
            let data = groupUserDefaults.object(forKey: "TEST") as! String
            print("LOAD : \(data)")
        }
    }
    
    
    
    /** 공유 컨테이너의 공통 리소스 또는 자산을 관리 및 액세스하려는 경우 "작업(예: 파일 로드 또는 디렉토리 생성)을 시도하고 오류를 확인하고 해당 오류를 처리하는 것이 훨씬 낫다는 점을 기억하십시오. 수술의 성공 여부를 미리 파악하는 것보다 우아하게."
     
     - returns: True if plist exists; false if it doesn't exist // plist가 있으면 true이고, 그렇지 않으면 true입니다. 존재하지 않으면 false
     */
    func sharedPreferencesPlistExists() -> Bool {
        
        var containerExists = false
        
        let sharedFileManager = FileManager.default
        
        /* 4b) "In macOS, a URL of the expected form is always returned, even if the app group is invalid, so be sure to test that you can access the underlying directory before attempting to use it." */
        let sharedContainerFolderURL = sharedFileManager.containerURL(forSecurityApplicationGroupIdentifier: APP_GROUP_ID)
        // 4c) Now we build a standard path ("Library/Preferences/")
        // to the preferences data store file (plist). Note
        // the format of the plist's name.
        let sharedContainerPrefsPlistURL = (sharedContainerFolderURL?.appendingPathComponent("Library/Preferences/\(APP_GROUP_ID).plist"))!
        // 4d) Try to read data from the preferences
        // plist file.
        let sharedContainerPrefsPlistData = NSData(contentsOf: sharedContainerPrefsPlistURL)
        // 4e) If the file exists...
        if let fileData = sharedContainerPrefsPlistData {
            
            // 4f) if the plist file has contents (bytes)...
            if fileData.length > 0 {
                
                // 4g) We know that the plist is valid.
                print(".plist file size: \(fileData.length)")
                containerExists = true
                
            }
            
        }
        return containerExists
    } // func sharedContainerExists()
    
    
    @objc func deeplinkAction() {
        let url = URL(string: "youtube://")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}


extension WidgetViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    //MARK: - DataSources
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WidgetIconCell.reuseID, for: indexPath) as? WidgetIconCell else {return UICollectionViewCell()}
        
        var items = icons[indexPath.item]
        cell.makeIcon(image: items.image)
        
        return cell
    }
    
    //MARK: - Delegates

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: CollectionView Index : \(indexPath)")

        
    }
    
    
}

