//
//  WidgetViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/11.
//

import UIKit
import SnapKit
import CoreData
import SwiftUI
import WidgetKit

class WidgetViewController: UIViewController {
    
    let coredataContext = CoreData.shared.persistentContainer.viewContext
    
    
    //MARK: - CoreData Properties
    var deepLinkWidgets: [DeepLink] = []
    
    //MARK: - Properties
    
    let safeNaviBG: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = AppColors.buttonPurple.image()
        iv.contentMode = .scaleAspectFill
        iv.alpha = 1
        
        return iv
    }()
    

    
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
    
    let deepLinkTitle: UILabel = ViewModel.shared.makeLabel(
        text: "내 위젯",
        color: .white,
        fontSize: 18,
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
    
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // isFirstRunning()
        
        view.backgroundColor = AppColors.blackDarkGrey
        
        view.addSubview(safeNaviBG)
        safeNaviBG.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        
        loadData()
        configureNavigation()
        configureUI()
        configureDeepLinkWidget()
        
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
        navigationItem.title = "위젯"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItems = [addBarButton]
        navigationController?.navigationBar.backgroundColor = AppColors.buttonPurple
        navigationController?.navigationBar.tintColor = .white
        // view.backgroundColor = AppColors.buttonPurple
    }
    
    private func configureUI() {
        
        ViewModel.shared.makeLayerShadow(to: deepLinkTitle.layer)
    }
    
 
    
    /// 위젯의 타임라인을 재설정합니다. (리프레쉬와 같은 효과)
    func widgetRefreshTimeLine() {
        WidgetCenter.shared.reloadTimelines(ofKind: "DeepLinkWidget")
    } // END - widgetRefreshTimeLine
    
    
}

//MARK: - CollectionView
extension WidgetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    private func configureDeepLinkWidget() {
        
        // title
        view.addSubview(deepLinkTitle)
        deepLinkTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.leading.trailing.equalTo(view).inset(16)
            make.height.equalTo(50)
        }
        
        
        // collection View
        deepLinkCollectionView.delegate = self
        deepLinkCollectionView.dataSource = self
        
        self.view.addSubview(deepLinkCollectionView)
        ViewModel.shared.cropCornerRadius(view: deepLinkCollectionView, radius: 8)
        deepLinkCollectionView.snp.makeConstraints { make in
            make.top.equalTo(deepLinkTitle.snp.bottom).inset(-8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == deepLinkCollectionView {
            if deepLinkWidgets.count == 0 {
                return 1
            }
            
            return deepLinkWidgets.count
        }
        
        return 0
    }
    
    // CellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
            cell.makeLabel(text: data.name!, height: 30)
            cell.remakeAlpha(view: cell.imgView, alpha: 0.8)
            
            return cell
            
        }
        
        return UICollectionViewCell()
    }
    
    // didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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


// MARK: FlowLayout Delegate
extension WidgetViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
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


// MARK: Update Widget Data (Delegate : Edit VC -> Self)
extension WidgetViewController: EditWidgetViewControllerDelegate {
    func deleteDeepLink(data: DeepLink) {
        self.deleteData(data: data)
    }
    
    func editingSucessful(data: DeepLink) {
        saveData()
        loadData()
        self.deepLinkCollectionView.reloadData()
    }
    
}



// MARK: Preview Providers


struct WidgetViewController_Previews: PreviewProvider {
    static var previews: some View {
        WidgetViewControllerRepresentable().edgesIgnoringSafeArea(.all).previewInterfaceOrientation(.portrait)
    }
}

struct WidgetViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: WidgetViewController())
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}
