//
//  WidgetViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/11.
//

import UIKit
import SnapKit
import CoreData

class WidgetViewController: UIViewController {
    
    let coredataContext = CoreData.shared.persistentContainer.viewContext

    
    //MARK: - CoreData Properties
    var deepLinkWidgets: [DeepLink] = []
    
    //MARK: - Properties
        
    let gradientBG: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = AppColors.blackDarkGrey.image()
        iv.contentMode = .scaleAspectFill
        iv.alpha = 1
    
        return iv
    }()
    
    let deepLinkTitle: UILabel = ViewModel.shared.makeLabel(
        text: "나의 딥링크 위젯",
        color: .white,
        fontSize: 20,
        fontWeight: .bold,
        alignment: .left
    )
    
    /// 위젯 추가 버튼을 초기화합니다.
    lazy var addBarButton: UIBarButtonItem = {
        let btnImg = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let barBtn = UIBarButtonItem(
            image: btnImg,
            style: .plain,
            target: self,
            action: #selector(addBarButtonTapped)
        )
        return barBtn
    }()
    
    let collectionView: UICollectionView = {
        
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
        
        isFirstRunning()
        
        view.backgroundColor = AppColors.blackDarkGrey
        
        view.addSubview(gradientBG)
        gradientBG.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        
        loadData()
        configureNavigation()
        configureUI()
        configureDeepLinkWidget()
        
        print("DEBUG: widgets \(deepLinkWidgets)")


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    //MARK: - Selectors
    @objc func addBarButtonTapped(sender: UIBarButtonItem) {
        let vc = AddWidgetViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Helpers
    
    private func configureNavigation() {
        navigationItem.title = "Widgets"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItems = [addBarButton]
        navigationController?.navigationBar.backgroundColor = AppColors.buttonPurple
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = AppColors.buttonPurple

    }
    
    private func configureUI() {
        
        ViewModel.shared.makeLayerShadow(to: deepLinkTitle.layer)
    }

}

//MARK: - CollectionView
extension WidgetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    private func configureDeepLinkWidget() {
        
        // title
        view.addSubview(deepLinkTitle)
        deepLinkTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.leading.trailing.equalTo(view).inset(8)
            make.height.equalTo(30)
        }
        
        
        // collection View
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(deepLinkTitle.snp.bottom).inset(-8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deepLinkWidgets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WidgetIconCell.reuseID, for: indexPath) as? WidgetIconCell else {return UICollectionViewCell()}
        
        let data = deepLinkWidgets[indexPath.item]
        
        let image = UIImage(data: data.image!) ?? UIImage(named: "questionmark.circle")!
        
        cell.makeIcon(image: image)
        cell.makeLabel(text: data.name!, height: 12)
        cell.remakeAlpha(view: cell.imgView, alpha: 0.8)
        
        print("DEBUG: cell -> \(cell.label)")

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = deepLinkWidgets[indexPath.item]
        
        let vc = EditWidgetViewController(selectedWidget: item)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        vc.delegate = self
        self.present(vc, animated: true)
    }
}

extension WidgetViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = 70
        let height: CGFloat = width * 1.42
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}


extension WidgetViewController {
    // MARK: - 기본 위젯 DB에 추가
    
    func isFirstRunning() {
        
        let getDefaults = UserDefaults.standard.object(forKey: "IS_FIRST_RUN") as? Bool
        
        if let getDefaults = getDefaults {
            
            print("DEBUG: getDefaults : \(getDefaults)")

            IS_FIRST_RUN = getDefaults
        } else {
            print(getDefaults)

            setDefaultWidgets {
                IS_FIRST_RUN = false
                let defaults = UserDefaults.standard.set(IS_FIRST_RUN, forKey: "IS_FIRST_RUN")
            }

        }
    }
    
    func setDefaultWidgets(completion: @escaping () -> ()) {

        print("setDefaultWidgets")
        
        var icons: [DeepLink] = []
        
        var defaultApps = WidgetModel.shared.app
        
        for appInfo in defaultApps {
            let item = DeepLink(context: coredataContext)
            item.id = UUID()
            item.name = appInfo.name
            item.image = UIImage(named: appInfo.imageName)?.pngData()
            item.deepLink = appInfo.deepLink
            
            icons.append(item)
        }
        
        print(icons)
        
        do {
            try coredataContext.save() // 이 부분이 persistent store에 저장하는 코드
            completion()
        } catch {
            print("context 저장중 에러 발생 : \(error)")
        }
    }
}



extension WidgetViewController: EditWidgetViewControllerDelegate {
    func deleteDeepLink(data: DeepLink) {
        let dataName = data.name ?? "딥 링크"
        self.deleteData(data: data)
        let apply = UIAlertAction(title: "확인", style: .default) { _ in
            self.collectionView.reloadData()
            self.dismiss(animated: true)
        }
        let alert = ViewModel.shared.makeAlert(alertTitle: "\(dataName) \n위젯이 삭제되었습니다.", alertMessage: "", actions: [apply])
        self.present(alert, animated: true)

    }
    
    
    func editingSucessful(data: DeepLink) {
        saveData()
        loadData()
        self.collectionView.reloadData()
    }
    
}
