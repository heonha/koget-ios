//
//  WidgetIconCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import CoreData

struct WidgetIconCell: View {
    
    var widget: DeepLink
    let titleColor: Color = AppColors.label
    
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    
    var body: some View {
        
        // 버튼
        
        VStack {
            Button {
                self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                    DetailWidgetView(selectedWidget: widget)
                })
            } label: {
                VStack {
                    Image(uiImage: .init(data:(widget.image!))!)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 55, height: 55)
                        .shadow(color: .gray, radius: 0.5, x: 0.2, y: 0.3)
                    Text(widget.name ?? "위젯이름")
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


struct DeepLinkWidgetIconView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            // 배경
            AppColors.secondaryBackgroundColor
                .ignoresSafeArea()
            
            // 컨텐츠
            WidgetIconCell(widget: DeepLink.example)
        }
    }
}


