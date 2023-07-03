//
//  Image+Extestion.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/10.
//

import SwiftUI

extension Image {

    static func uiImage(_ uiImage: UIImage) -> Image {
        return Image(uiImage: uiImage)
    }
    
    
    init?(data: Data) {
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        
        self.init(uiImage: uiImage)
    }


}
