//
//  WidgetGrid.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/10.
//

import SwiftUI

struct WidgetGrid: View {
    
    var title: String
    var gridItem = [GridItem(), GridItem(), GridItem(), GridItem()]
    let offColor = Color.init(red: 225/255, green: 225/255, blue: 235/255)
    var width = DEVICE_SIZE.width / 4.3
    @StateObject var coredata = WidgetCoreData.shared

    var body: some View {
        ZStack {
            
            VStack {
                HStack {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .opacity(0.9)
                    
                    Spacer()
                    
                }
                .padding([.horizontal, .top])
                
                
                LazyVGrid(columns: gridItem, alignment: .center, spacing: 4) {
                    
                    //MARK: 위젯 Cell
                    ForEach($coredata.linkWidgets.wrappedValue, id: \.id) { widget in
                        WidgetIconCell(widget: widget, cellWidth: width)
                            .padding()
                        
                    }
                }
                .background(RoundedRectangle(cornerRadius: 25)
                    .fill(offColor)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 3, y: 3)
                )
                .frame(width: DEVICE_SIZE.width - 32)
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
