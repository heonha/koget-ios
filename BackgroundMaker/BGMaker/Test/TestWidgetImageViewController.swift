//
//  TestImageViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/04.
//

import UIKit
import SnapKit
import WidgetKit

class TestWidgetImageViewController: UIViewController {
    
    //MARK: - Properties
    
    let imageViewer: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let appImage: UIImage!
    
    init(appImage: UIImage!) {
        self.appImage = appImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemTeal
        
        view.addSubview(imageViewer)
        imageViewer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageViewer.image = appImage
    }
    
    /// 현재 이 앱이 구성한 위젯의 데이터를 확인합니다.
    func widgetGetData() {
        WidgetCenter.shared.getCurrentConfigurations { (result) in
            switch result {
            case .success(let widgets):
                for info in widgets {
                    print("---- Widget Information ----")

                    print("info Kind : \(info.kind)")
                    print("info Family : \(info.family)")
                    print("info Config : \(String(describing: info.configuration))")
                    
                }
            case.failure(let error):
                print(" Widget get current Conf. Error: \(error.localizedDescription)")
            }
        }
    }
    
}
