//
//  SVGManager.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/04.
//

import SVGKit
import SwiftUI

class SVGManager {

    init() { }

    func getSVGImage(url: URL, name: String = "", size: CGSize = CGSize(width: 256, height: 256),
                             completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }

            // TODO: Combine으로 처리하도록 변경하시오
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    if let data = data {
                        if let svgImage = SVGKImage(data: data) {
                            svgImage.size = size
                            if let uiImage = svgImage.uiImage {
                                uiImage.metadata = name
                                completion(uiImage)
                            }
                        }
                    }
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }
}
