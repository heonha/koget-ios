//
//  WidgetViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/11.
//

import UIKit
import SnapKit
import WidgetKit
import SwiftUI

import RxSwift
import RxCocoa

import CoreData


class WidgetViewController: UIViewController {
    
    lazy var widgetMakeButton: UIView = {
        var view = UIView()
        view = makeMenuView(
            title: "위젯 만들기",
            image: UIImage(named: "rectangle.stack.badge.plus")!,
            action: #selector(addBarButtonTapped)
        )
        return view
    }()
    
    var disposeBag = DisposeBag()
    
    //MARK: - CoreData Properties
    
    var deepLinkWidgets = [DeepLink]()
    
    lazy var deepLinkWidgetObserver = WidgetCoreData.shared.widgets
        .subscribe { (widgets) in
        self.deepLinkWidgets = widgets
    }


    
    //MARK: - Properties
    
    let safeNaviBG: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = AppColors.buttonPurple
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
        deepLinkWidgetObserver.disposed(by: disposeBag)
        // isFirstRunning()
        
        view.backgroundColor = AppColors.blackDarkGrey
        
        view.addSubview(safeNaviBG)
        safeNaviBG.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        
        WidgetCoreData.shared.loadData()
        configureNavigation()
        configureWidgetMakerButton()
        configureDeepLinkWidget()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View Will Appear")
        deepLinkCollectionView.reloadData()
    }
    
    //MARK: - Selectors
    @objc func addBarButtonTapped(sender: UIBarButtonItem) {
        let vc = AddWidgetViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
   

    
    
    //MARK: - Helpers
    
    private func configureWidgetMakerButton() {
        view.addSubview(widgetMakeButton)
        widgetMakeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(view.frame.width / 1.5)
        }
    }
    
    /// 메뉴버튼을 만들고 menuStackView에 추가합니다.
    private func makeMenuView(title: String, image: UIImage, action: Selector) -> UIView {
        
        let mainView = UIView()
        
        // 컨텐츠 사이즈 지정
        let screenSize = UIScreen.main.bounds
        let spacing: CGFloat = 6
        let padding: CGFloat = 12
        
        let buttonSize = CGSize(width: screenSize.width / 1.2, height: 65)
        
        // rootView
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        // 배경 뷰
        let bgView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .black
            view.alpha = 0.3
            view.layer.cornerRadius = 8
            ViewModelForCocoa.shared.makeLayerShadow(to: view.layer)
            return view
        }()
        
        let imageView: UIImageView = {
            let holderImage = image.withRenderingMode(.alwaysOriginal)
            let imageView = UIImageView() // 사진 추가하기를 의미하는 이미지
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.image = holderImage
            
            return imageView
        }()
        
        /// 메뉴제목 라벨 초기화
        let label: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = title
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 20, weight: .bold)
            ViewModelForCocoa.shared.makeLayerShadow(to: label.layer)
            
            return label
        }()
        
        /// 뷰를 감싸는 투명버튼 초기화
        let button: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: action, for: .touchDown)
            button.backgroundColor = .clear
            return button
        }()
        
        view.addSubview(mainView)
        
        mainView.addSubview(bgView)
        mainView.addSubview(imageView)
        mainView.addSubview(label)
        mainView.addSubview(button)
        
        mainView.snp.makeConstraints { make in
            make.width.equalTo(buttonSize.width)
            make.height.equalTo(buttonSize.height)
        }
        
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(mainView)
        }
        
        // MARK: Layouts
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(mainView).inset(padding)
            make.leading.equalTo(mainView).inset(padding)
        }
        
        label.snp.makeConstraints { make in
            make.top.bottom.equalTo(mainView).inset(padding)
            make.leading.equalTo(imageView.snp.trailing).inset(spacing)
            make.trailing.equalTo(mainView).inset(padding)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalTo(mainView)
        }
        
        return mainView
    }
    
    
    private func configureNavigation() {
        navigationItem.title = "위젯"
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItems = [addBarButton]
        navigationController?.navigationBar.backgroundColor = AppColors.buttonPurple
        navigationController?.navigationBar.tintColor = .white
        // view.backgroundColor = AppColors.buttonPurple
    }
    
 
    
    /// 위젯의 타임라인을 재설정합니다. (리프레쉬와 같은 효과)
    func widgetRefreshTimeLine() {
        WidgetCenter.shared.reloadTimelines(ofKind: "DeepLinkWidget")
    } // END - widgetRefreshTimeLine
    
    
}

//MARK: - CollectionView
extension WidgetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    private func configureDeepLinkWidget() {
        
        
        // collection View
        deepLinkCollectionView.delegate = self
        deepLinkCollectionView.dataSource = self
        
        self.view.addSubview(deepLinkCollectionView)
        ViewModelForCocoa.shared.cropCornerRadius(view: deepLinkCollectionView, radius: 8)
        deepLinkCollectionView.snp.makeConstraints { make in
            make.top.equalTo(widgetMakeButton.snp.bottom).inset(-16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(250)
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
                return CGSize(width: UIScreen.main.bounds.width, height: deepLinkCollectionView.frame.height - 44)
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
        WidgetCoreData.shared.deleteData(data: data)
        deepLinkCollectionView.reloadData()
    }
    
    func editingSucessful(data: DeepLink) {
        WidgetCoreData.shared.saveData()
        WidgetCoreData.shared.loadData()
        self.deepLinkCollectionView.reloadData()
    }
    
}

extension WidgetViewController: AddWidgetViewControllerDelegate {
    
        /// AddWidgetVC로 받은 Delegate 프로토콜 메소드입니다.
    func addDeepLinkWidget(widget: DeepLink) {
        self.deepLinkWidgets.append(widget)
        WidgetCoreData.shared.saveData()
        WidgetCoreData.shared.loadData()
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
