//
//  WidgetViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/11.
//

import UIKit
import SnapKit

class WidgetViewController: UIViewController {
    
    //MARK: - Properties
    
    let lockWidgets = AppList.shared.app
    
    let deepLinkTitle: UILabel = ViewModel.shared.makeLabel(
        text: "딥링크 위젯",
        color: .white,
        fontSize: 20,
        fontWeight: .medium,
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
        
        configureNavigation()
        configureUI()
        configureDeepLinkWidget()
    }
    
    //MARK: - Selectors
    @objc func addBarButtonTapped(sender: UIBarButtonItem) {
        print("Bar")
        let vc = AddWidgetViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Helpers
    
    private func configureNavigation() {
        navigationItem.title = "Widget VC"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItems = [addBarButton]

    }
    
    private func configureUI() {
        view.backgroundColor = .black
    }

}

//MARK: - CollectionView
extension WidgetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    private func configureDeepLinkWidget() {
        
        // title
        view.addSubview(deepLinkTitle)
        deepLinkTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalTo(view).inset(8)
            make.height.equalTo(30)
        }
        
        
        // collection View
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(deepLinkTitle.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lockWidgets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WidgetIconCell.reuseID, for: indexPath) as? WidgetIconCell else {return UICollectionViewCell()}
        
        let data = lockWidgets[indexPath.item]
        
        let image = UIImage(named: data.imageName) ?? UIImage(named: "questionmark.circle")!
        
        cell.makeIcon(image: image)
        cell.makeLabel(text: data.name, height: 12)
        cell.remakeAlpha(view: cell.imgView, alpha: 0.8)
        
        return cell
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
