//
//  WidgetGridView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

// 딥링크 위젯 리스트 뷰
struct WidgetGridView: View {
    
    var title: String = ""
    
    var gridItem = [GridItem(), GridItem(), GridItem(), GridItem()]
    var width = Constants.deviceSize.width / 4
    
    @State var isPresent = false
    @ObservedObject var widgetCoreData: WidgetCoreData
    
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    var body: some View {
        
        VStack {
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            
            
            // 그리드뷰
            LazyVGrid(columns: gridItem, alignment: .leading, spacing: 16 ) {
                
                
                ForEach(widgetCoreData.linkWidgets, id: \.id) { widget in
                    
                    // 버튼
                    Button {
                        self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                            DetailWidgetView(selectedWidget: widget)
                        })
                    } label: {
                        WidgetIconView(selectedObject: widget)
                            .tint(.white)
                            .frame(width: width, height: width)
                            .clipped()
                    }
                    .frame(width: width, height: width)
                }
            }
            .background(AppColors.normalDarkGrey)
            .cornerRadius(10)
            .shadow(radius: 3)
            Spacer()
        }
    }
    
    
    
}

// 
// struct WidgetGridView_Previews: PreviewProvider {
//     
//     
//     static var previews: some View {
//         
//         NavigationView {
//             WidgetGridView(title: "링크 위젯", widgetCoreData: StorageProvider.preview)
//             Spacer()
//         }
// 
//     }
// }
