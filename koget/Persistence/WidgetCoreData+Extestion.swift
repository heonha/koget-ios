//
//  WidgetCoreData+Extestion.swift
//  koget
//
//  Created by Heonjin Ha on 2023/05/23.
//

import SwiftUI

extension DeepLinkManager {

    func addLinkWidget(name: String, image: UIImage?, url: String, opacity: Double = 0.7) {
        let widget = DeepLink(context: container.viewContext)
        widget.id = UUID()
        widget.name = name
        widget.image = compressPNGData(with: image)
        widget.url = url
        widget.updatedDate = Date()
        widget.opacity = (opacity) as NSNumber

        linkWidgets.append(widget)
        saveData()
        loadData()
    }

    func compressPNGData(with image: UIImage?) -> Data {

        // 새로운 이미지 크기 설정
        let newSize = CGSize(width: 128, height: 128)

        // 그래픽 컨텍스트 생성
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // PNG 데이터 생성
        if let imageData = newImage?.pngData() {
            return imageData
        } else {
            return Data()
        }
    }

    func editLinkWidget(name: String, image: UIImage?, url: String, opacity: Double, widget: DeepLink) {

        widget.name = name
        if widget.image != image?.pngData() {
            widget.image = compressPNGData(with: image)
        }
        widget.url = url
        widget.updatedDate = Date()
        widget.opacity = NSNumber(floatLiteral: opacity)
        saveData()
        loadData()
    }
    
}
