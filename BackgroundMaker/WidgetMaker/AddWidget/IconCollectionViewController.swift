//
//  IconCollectionViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/14.
//

import UIKit
import SnapKit

protocol IconCollectionViewControllerDelegate {
    func iconSelected(icon: UIImage)
}

class IconCollectionViewController: UIViewController {

    var delegate: IconCollectionViewControllerDelegate?
    
    var icons: [UIImage] = [
        UIImage(named: "swift")!,
        UIImage(named: "swift")!,
        UIImage(named: "swift")!,
        UIImage(named: "swift")!,
        UIImage(named: "youtube")!,
        UIImage(named: "facebook")!,
        UIImage(named: "swift")!,
    ]
    
    
    //MARK: - Properties
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(WidgetIconCell.self, forCellWithReuseIdentifier: WidgetIconCell.reuseID)
        return cv
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .black
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.bottom.equalTo(view).inset(20)
        }
        
    }
    
}


extension IconCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.item)
        
        let selectedItem = icons[indexPath.item]
        delegate?.iconSelected(icon: selectedItem)
        
        dismiss(animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WidgetIconCell.reuseID, for: indexPath) as? WidgetIconCell else {return UICollectionViewCell()}
        
        let icon = icons[indexPath.item]
        cell.makeIcon(image: icon)
        
        return cell
    }
    
    
    
    
    
    
}
