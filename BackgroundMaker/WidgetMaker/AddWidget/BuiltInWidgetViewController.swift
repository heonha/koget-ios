//
//  BuiltInWidgetViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/16.
//

import UIKit
import SnapKit

protocol BuiltInWidgetViewControllerDelegate {
    func selectedBuiltInApp(data: BuiltInDeepLink)
}

class BuiltInWidgetViewController: UIViewController {
    
    //MARK: - Properties
    
    var delegate: BuiltInWidgetViewControllerDelegate?
    
    private let viewTitle: UILabel = ViewModel.shared.makeLabel(
        text: "앱 리스트에서 불러오기",
        color: .white,
        fontSize: 20,
        fontWeight: .bold,
        alignment: .center
    )
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .black
        return tv
    }()
    
    // var builtInWidgets = ["1", "2", "3"]
    let builtInWidgets = WidgetModel.shared.builtInApps

    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        print("빌트인 위젯 : \(builtInWidgets)")
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .black
    }
    
    private func configureTableView() {
        view.addSubview(viewTitle)
        ViewModel.shared.makeLayerShadow(to: viewTitle.layer)
        viewTitle.backgroundColor = AppColors.buttonPurple

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BuiltInAppCell.self, forCellReuseIdentifier: BuiltInAppCell.reuseID)

        // Title
        let viewTitleHeight: CGFloat = 50
        viewTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(viewTitleHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(viewTitle.snp.bottom).inset(-8)
            make.leading.trailing.equalTo(view).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)

        }
        
    }
    
}

extension BuiltInWidgetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = builtInWidgets[indexPath.row]
        delegate?.selectedBuiltInApp(data: item)
        dismiss(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BuiltInAppCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return builtInWidgets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BuiltInAppCell.reuseID, for: indexPath) as? BuiltInAppCell else {return UITableViewCell()}
        
        let item = builtInWidgets[indexPath.row]

        cell.iconImageView.image = UIImage(named: item.imageName) ?? UIImage(systemName: "questionmark.circle")
        cell.appNameLabel.text = item.name
        
        return cell
    }
    
    
}
