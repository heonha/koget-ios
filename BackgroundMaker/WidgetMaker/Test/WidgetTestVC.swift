//
//  WidgetTestVC.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/04.
//


import UIKit
import SnapKit

class WidgetTestVC: UIViewController {
    
    //MARK: - Properties
    let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SEND", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        
        button.addTarget(self, action: #selector(setSharedValueButtonPressed), for: .touchDown)
        
        return button
    }()
    
    let loadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("LOAD", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemPink

        
        button.addTarget(self, action: #selector(loadPreferenceValue), for: .touchDown)
        
        return button
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Deep", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGreen

        
        button.addTarget(self, action: #selector(deeplinkAction), for: .touchDown)
        
        return button
    }()
    
    let plistCheckLabel: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .black
        textField.textColor = .white
        
        return textField
    }()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK: - Selectors
    @objc func sendButtonTapped(sender: UIButton) {
        print("Send Button Tapped")
    }
    
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .black
        
        // sendButton
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        view.addSubview(loadButton)
        loadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(40)

            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        view.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(80)

            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        view.addSubview(plistCheckLabel)
        plistCheckLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(120)

            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        
    }
    
    @objc func setSharedValueButtonPressed(_ sender: Any) {
        
        // 2) Make sure that the user picks one of the
        // possible view background colors (theme?)...
            
            // 3) Write the user preference for view
            // "BackgroundColor" to the shared container.
            // See 3a below...
        let testStr = "Testing"
            self.setPreferenceValue(testStr, forKey: "TEST", in: APP_GROUP_ID )
            print("TEST : \(testStr) ")
        
    } // end func setSharedValueButtonPressed
    
    @objc func checkForPlistButtonPushed(_ sender: Any) {
        
        if self.sharedPreferencesPlistExists() {
            self.plistCheckLabel.text = ".plist exists"
            print("App share plist가 생성되어 있습니다.")
        }
        else {
            self.plistCheckLabel.text = ".plist missing"
            print("App share plist가 생성되지 않았습니다.")
        }
        
    } // end func checkForPlistButtonPushed
    
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