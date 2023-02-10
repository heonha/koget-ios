//
//  DetailViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/17.
//

import SwiftUI

class DetailViewModel: ObservableObject {
    
    
    @Published var name: String = ""
    @Published var url: String = ""
    @Published var image: UIImage?
    
    
}
