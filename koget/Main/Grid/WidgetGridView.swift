//
//  WidgetGridView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

// 딥링크 위젯 리스트 뷰
struct WidgetGridView: View {
    
    var backgroundColor = AppColors.secondaryBackgroundColor
    
    @State var isPresent = false
    @StateObject var coredata = WidgetCoreData.shared
    @StateObject var viewModel = MainWidgetViewModel.shared
    
    var body: some View {
                //MARK: - Grid View
                
                ZStack {
                    VStack {

                    //MARK: 위젯이 있을 때.
                    if !$coredata.linkWidgets.wrappedValue.isEmpty {
                        
                        
                        WidgetGrid(title: "나의 잠금화면 위젯")
     

                        
                    } else {
                        //MARK: 만든 위젯이 0개일 때.

                        Spacer()
                        
                        EmptyGrid()
                        
                    }
                }
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
//             WidgetGridView(title: "링크 위젯", widgetCoreData: StorageProvider.preview.persistentContainer)
//             Spacer()
//         }
//
//     }
// }
