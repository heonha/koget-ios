//
//  WidgetIconCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct WidgetIconCell: View {
    
    var widget: DeepLink
    var cellWidth: CGFloat
    
    init(widget: DeepLink, cellWidth: CGFloat) {
        self.widget = widget
        self.cellWidth = cellWidth
    }
    
    
    @ObservedObject var viewModel = MainWidgetViewModel.shared
    @ObservedObject var coredata = WidgetCoreData.shared
    
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    
    var body: some View {
        if let data = widget.image, let name = widget.name, let url = widget.url {
            if let widgetImage = UIImage(data: data) {
                
                
                Menu {
                    Button {
                        if let url = widget.url {
                            viewModel.openURL(urlString: url)
                        } else {
                            print("CoreData url Error")
                        }
                    } label: {
                        Label("실행하기", systemImage: "arrow.up.left.square.fill")
                    }
                    Button {
                        self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                            DetailWidgetView(selectedWidget: widget)
                        })
                    } label: {
                        Label("편집", systemImage: "slider.horizontal.3")
                    }
                    Divider()
                    Button(role: .destructive) {
                        WidgetCoreData.shared.deleteData(data: widget)
                        MainWidgetViewModel.shared.deleteSuccessful = true
                    } label: {
                        Label("삭제", systemImage: "trash.fill")
                    }
                    
                } label: {
                    WidgetButton(name: name, url: url, widgetImage: widgetImage, cellWidth: cellWidth)
                }
                // 버튼
                
                
                
            }
        }
    }
}


struct DeepLinkWidgetIconView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            // 배경
            AppColors.secondaryBackgroundColor
                .ignoresSafeArea()
            
            // 컨텐츠
            WidgetIconCell(widget: DeepLink.example, cellWidth: DEVICE_SIZE.width / 5)
        }
        .environmentObject(StorageProvider())
    }
}



