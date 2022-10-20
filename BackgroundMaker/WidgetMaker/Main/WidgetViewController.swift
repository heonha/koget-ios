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
    var textWidgets: [TextWidget] = []
    
    //MARK: - Properties
        
    let safeNaviBG: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = AppColors.buttonPurple.image()
        iv.contentMode = .scaleAspectFill
        iv.alpha = 1
    
        return iv
    }()
    

    let textWidgetTitle: UILabel = ViewModel.shared.makeLabel(
        text: "텍스트 위젯",
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
    
    /// 위젯 추가 버튼을 초기화합니다.
    lazy var addTextWidgetButton: UIButton = {
        let btnImg = UIImage(named: "plus")!
        let button = ViewModel.shared.makeButtonWithImageWithTarget(
            image: btnImg, action: #selector(addTextWidgetButtonTapped), target: self)
        return button
    }()
    
    let deepLinkTitle: UILabel = ViewModel.shared.makeLabel(
        text: "딥링크 위젯",
        color: .white,
        fontSize: 20,
        fontWeight: .bold,
        alignment: .left
    )
    
    
    let deepLinkCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // 스크롤 방향
        let sectionInset: CGFloat = 16
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset,
                                           bottom: sectionInset, right: sectionInset)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(WidgetIconCell.self, forCellWithReuseIdentifier: WidgetIconCell.reuseID)
        cv.register(PlaceHolderCell.self, forCellWithReuseIdentifier: "PlaceHolderCell")

        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .black
        
        return cv
    }()
    
    let textWidgetCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 스크롤 방향
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PlaceHolderCell.self, forCellWithReuseIdentifier: "PlaceHolderCell")
        cv.register(TextWidgetCell.self, forCellWithReuseIdentifier: TextWidgetCell.reuseID)

        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .black
        
        return cv
    }()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isFirstRunning()
        
        view.backgroundColor = AppColors.blackDarkGrey
        
        view.addSubview(safeNaviBG)
        safeNaviBG.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        
        loadData()
        textWidgetLoadData()
        configureNavigation()
        configureUI()
        configureDeepLinkWidget()
        configureTextWidget() 
        
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
    
    @objc func addTextWidgetButtonTapped(sender: UIBarButtonItem) {
        let vc = AddTextWidgetViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - Helpers
    
    private func configureNavigation() {
        navigationItem.title = "내 위젯"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItems = [addBarButton]
        navigationController?.navigationBar.backgroundColor = AppColors.buttonPurple
        navigationController?.navigationBar.tintColor = .white
        // view.backgroundColor = AppColors.buttonPurple
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
            make.leading.trailing.equalTo(view).inset(16)
            make.height.equalTo(30)
        }
        
        
        // collection View
        deepLinkCollectionView.delegate = self
        deepLinkCollectionView.dataSource = self
        
        self.view.addSubview(deepLinkCollectionView)
        ViewModel.shared.cropCornerRadius(view: deepLinkCollectionView, radius: 8)
        deepLinkCollectionView.snp.makeConstraints { make in
            make.top.equalTo(deepLinkTitle.snp.bottom).inset(-8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(250)
        }
    }
    
    private func configureTextWidget() {
        // 
        // // title
        // view.addSubview(textWidgetTitle)
        // textWidgetTitle.snp.makeConstraints { make in
        //     make.top.equalTo(deepLinkCollectionView.snp.bottom).inset(-16)
        //     make.leading.trailing.equalTo(view).inset(8)
        //     make.height.equalTo(30)
        // }
        //
        //
        // // collection View
        // textWidgetCollectionView.delegate = self
        // textWidgetCollectionView.dataSource = self
        //
        // self.view.addSubview(textWidgetCollectionView)
        // ViewModel.shared.cropCornerRadius(view: textWidgetCollectionView, radius: 8)
        // textWidgetCollectionView.snp.makeConstraints { make in
        //     make.top.equalTo(textWidgetTitle.snp.bottom).inset(-16)
        //     make.leading.trailing.equalToSuperview().inset(8)
        //     make.height.equalTo(120)
        // }
        //
        // // title
        // view.addSubview(addTextWidgetButton)
        // addTextWidgetButton.snp.makeConstraints { make in
        //     make.top.equalTo(textWidgetTitle).inset(8)
        //     make.trailing.equalTo(textWidgetCollectionView).inset(8)
        //     make.height.equalTo(textWidgetTitle).inset(6)
        //     make.width.equalTo(textWidgetTitle.snp.height).inset(6)
        //
        // }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == textWidgetCollectionView {
            print("textWidgetCollectionView count")
            return 1
        }
        
        if collectionView == deepLinkCollectionView {
            if deepLinkWidgets.count == 0 {
                return 1
            }
            
            return deepLinkWidgets.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == textWidgetCollectionView {

            if textWidgets.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceHolderCell", for: indexPath) as! PlaceHolderCell
                cell.label.text = "아직 추가한 위젯이 없어요 \n첫 텍스트 위젯을 추가해보세요."

                return cell
            } else {
                let item = textWidgets[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextWidgetCell.reuseID, for: indexPath) as! TextWidgetCell
                cell.label.text = item.text

                return cell
            }

        }
        
        if collectionView == deepLinkCollectionView {
        
            if deepLinkWidgets.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceHolderCell", for: indexPath) as! PlaceHolderCell
                
                cell.label.text = "아직 추가한 위젯이 없어요 \n첫 바로가기 위젯을 추가해보세요."

                return cell
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WidgetIconCell.reuseID, for: indexPath) as? WidgetIconCell else {return UICollectionViewCell()}
            
            let data = deepLinkWidgets[indexPath.item]
            
            let image = UIImage(data: data.image!) ?? UIImage(named: "questionmark.circle")!
            
            cell.makeIcon(image: image)
            cell.makeLabel(text: data.name!, height: 12)
            cell.remakeAlpha(view: cell.imgView, alpha: 0.8)
            
            print("DEBUG: cell -> \(cell.label)")
            
            
            return cell
            
        }

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == textWidgetCollectionView {
            if textWidgets.count == 0 {
                print("텍스트위젯 탭함")
                let vc = AddTextWidgetViewController()
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
                
                return
            } else {
                
                return
            }
        }
        
        if deepLinkWidgets.count == 0 {
            addBarButtonTapped(sender: addBarButton)
            return
        }
        
        
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
        
        if collectionView == textWidgetCollectionView {
            if textWidgets.count == 0 {
                return CGSize(width: UIScreen.main.bounds.width, height: 120)
            } else {
                let height: CGFloat = 70
                let width: CGFloat = height * 2
                return CGSize(width: width, height: height)
            }
        }
        

        if collectionView == deepLinkCollectionView {
        
        if deepLinkWidgets.count == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: 120)
        }
        
        let width: CGFloat = 70
        let height: CGFloat = width * 1.42
        
        return CGSize(width: width, height: height)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
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
            setDefaultWidgets {
                IS_FIRST_RUN = false
                UserDefaults.standard.set(IS_FIRST_RUN, forKey: "IS_FIRST_RUN")
            }

        }
    }
    
    func setDefaultWidgets(completion: @escaping () -> ()) {

        print("setDefaultWidgets")
        
        var icons: [DeepLink] = []
        
        let defaultApps = WidgetModel.shared.builtInApps
        
        for appInfo in defaultApps {
            let item = DeepLink(context: coredataContext)
            item.id = UUID()
            item.name = appInfo.displayAppName ?? "이름없음"
            item.image = appInfo.image?.pngData()
            item.deepLink = appInfo.deepLink
            item.addedDate = Date()
            
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



extension WidgetViewController: EditWidgetViewControllerDelegate, AddTextWidgetViewControllerDelegate {
    func addTextWidget(widget: TextWidget) {
        saveData()
        textWidgetLoadData()
        self.textWidgetCollectionView.reloadData()
    }
    
    func deleteDeepLink(data: DeepLink) {
        self.deleteData(data: data)
    }
    
    
    func editingSucessful(data: DeepLink) {
        saveData()
        loadData()
        self.deepLinkCollectionView.reloadData()
    }
    
}
