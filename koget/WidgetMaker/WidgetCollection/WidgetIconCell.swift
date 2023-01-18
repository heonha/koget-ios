//
//  WidgetIconCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct WidgetIconCell: View {
    
    var widget: DeepLink
    let titleColor: Color = AppColors.label
    
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    @ObservedObject var coredata = WidgetCoreData.shared

    var body: some View {
        
        // 버튼
        VStack {
            Button {
                self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                    DetailWidgetView(selectedWidget: widget)
                })
            } label: {
                
                if let data = widget.image {
                    if let widgetImage = UIImage(data: data) {
                        VStack {
                            Image(uiImage: widgetImage)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: 55, height: 55)
                                .shadow(color: .gray, radius: 0.1, x: 0.2, y: 0.3)
                            Text(widget.name ?? "알수없는 이름")
                                .lineLimit(2)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(titleColor)
                            Spacer()
                        }
                        .frame(width: 90, height: 100)
                        .padding(.top, 16)
                        .tint(.white)
                        .clipped()
                    }
                }
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
            WidgetIconCell(widget: DeepLink.example)
        }
        .environmentObject(StorageProvider())
    }
}


