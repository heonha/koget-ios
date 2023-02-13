//
//  WidgetGrid.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/10.
//

import SwiftUI
import QGrid

struct WidgetGrid: View {
    
    var title: String
    var gridItem = [GridItem(), GridItem(), GridItem(), GridItem()]
    let offColor = Color.init(red: 225/255, green: 225/255, blue: 235/255)
    var width = DEVICE_SIZE.width / 4.3
    @StateObject var coredata = WidgetCoreData.shared
    @StateObject var viewModel = MainWidgetViewModel.shared

    var body: some View {
        ZStack {
            
            VStack {
                HStack {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .opacity(0.9)
                    
                    Text(viewModel.isEditingMode ? "편집모드" : "")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.init(uiColor: .systemBlue))
                        .animation(Animation.linear(duration: 0.2))

                    Spacer()
                    
                }
                .padding([.horizontal, .top])
                
                
                QGrid($coredata.linkWidgets.wrappedValue, columns: 4) { widget in
                    WidgetIconCell(widget: widget, cellWidth: width)
                }
                Spacer()


            }
        }
        }
}

struct WidgetGrid_Previews: PreviewProvider {
    static var previews: some View {
        WidgetGrid(title: "타이틀")
    }
}
