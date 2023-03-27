//
//  SUIViewController.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/04.
//

import SwiftUI

struct SUIViewController: UIViewControllerRepresentable {

    let rootVC: UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = rootVC
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }

    typealias UIViewControllerType = UIViewController

}
