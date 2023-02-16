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
    var viewModel: MainWidgetViewModel
    var coreData: WidgetCoreData
    
    init(widget: DeepLink, cellWidth: CGFloat, viewModel: MainWidgetViewModel, coreData: WidgetCoreData) {
        self.widget = widget
        self.cellWidth = cellWidth
        self.viewModel = viewModel
        self.coreData = coreData
    }
    

    
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    
    var body: some View {
        if let data = widget.image, let name = widget.name, let url = widget.url {
            if let widgetImage = UIImage(data: data) {
                
                
                Menu {
                    Button {
                        if let url = widget.url, let id = widget.id {
                            viewModel.maybeOpenedFromWidget(urlString: "\(SCHEME_LINK)\(url)\(ID_SEPARATOR)\(id.uuidString)")
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
                    WidgetButton(name: name, url: url, widgetImage: widgetImage, cellWidth: cellWidth, imageSize: CGSize(width: cellWidth * 0.63, height: cellWidth * 0.63), textSize: CGSize(width: cellWidth, height: cellWidth * 0.40), viewModel: viewModel)
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
            WidgetIconCell(widget: DeepLink.example, cellWidth: CELL_WIDTH, viewModel: MainWidgetViewModel.shared, coreData: WidgetCoreData.shared)
        }
        .environmentObject(StorageProvider())
    }
}



