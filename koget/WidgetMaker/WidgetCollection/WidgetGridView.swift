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
    var backgroundColor = AppColors.secondaryBackgroundColor
    var gridItem = [GridItem(), GridItem(), GridItem(), GridItem()]
    var width = DEVICE_SIZE.width / 4.2
    
    @State var isPresent = false
    @ObservedObject var widgetCoreData: WidgetCoreData
    
    var body: some View {
        
        VStack {
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            
            // 그리드뷰
            
            if !widgetCoreData.linkWidgets.isEmpty {
                
                LazyVGrid(columns: gridItem, alignment: .center, spacing: 8 ) {
                    
                    ForEach(widgetCoreData.linkWidgets, id: \.id) { widget in
                        
                        WidgetIconCell(widget: widget)
                            .frame(width: width, height: width)
                        
                    }
                    .padding(.top, 16)
                }
                
                .background(backgroundColor)
                .cornerRadius(8)
                .shadow(radius: 1)
                Spacer()
                
            } else {
                VStack {
                    Text("🤔")
                        .font(.system(size: 50))
                        .padding(.bottom, 8)
                    Text("아직 생성한 위젯이 없어요,")
                    Text("잠금화면 위젯을 생성해보세요!")
                }
                .foregroundColor(.gray)
                .frame(width: DEVICE_SIZE.width - 32, height: 300)
                .background(backgroundColor)
                .cornerRadius(8)
                .shadow(radius: 1)
                Spacer()
            }
            
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
//             WidgetGridView(title: "링크 위젯", widgetCoreData: StorageProvider.preview.persistentContainer)
//             Spacer()
//         }
// 
//     }
// }
