//
//  OpacityPicker.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/25.
//

import SwiftUI

struct OpacityPicker: View {
    
    @StateObject var viewModel: MakeWidgetViewModel
    var proxy: GeometryProxy
    @State var checkedMenu = 0
    
    var body: some View {
        
        
        Menu {
            Button {
                viewModel.opacityValue = 0.0
                print(viewModel.opacityValue)

            } label: {
                HStack {
                    Text("안보이게(0%)")
                    Spacer()
                    if viewModel.opacityValue == 0.0 {
                    Image(systemName: "checkmark")
                    }
                }
            }
            .tag(0)
            
            Button {
                viewModel.opacityValue = 0.25
                print(viewModel.opacityValue)

            } label: {
                HStack {
                    Text("25%")
                    Spacer()
                    if viewModel.opacityValue == 0.25 {
                    Image(systemName: "checkmark")
                    }
                }
            }
            .tag(25)

            
            Button {
                viewModel.opacityValue = 0.5
                print(viewModel.opacityValue)

            } label: {
                HStack {
                    Text("50%")
                    Spacer()
                    if viewModel.opacityValue == 0.5 {
                    Image(systemName: "checkmark")
                    }
                }
            }
            .tag(50)

            
            Button {
                viewModel.opacityValue = 0.75
                print(viewModel.opacityValue)
            } label: {
                Text("75%")
                if viewModel.opacityValue == 0.75 {
                Image(systemName: "checkmark")
                }
            }
            .tag(75)

            
            Button {
                viewModel.opacityValue = 1.0
            } label: {
                Text("100%")
                if viewModel.opacityValue == 1.0 {
                Image(systemName: "checkmark")
                }
            }
            .tag(100)

            
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .frame(height: 30)
                    .foregroundStyle(.gray)
                    .opacity(1.0)
                
                if viewModel.opacityValue == 1.1 {
                    Text("선택하세요")
                        .foregroundColor(.black)
                } else {
                    Text("\(Int(viewModel.opacityValue * 100))%")
                        .foregroundColor(.black)
                }
                
            }
            .frame(width: proxy.size.width * 0.5)
            .animation(.none, value: viewModel.opacityValue)
        }
        
        
        
    }
}
//
//
// struct CheckablePopupMenuView: View {
//     let menuItems = ["Item 1", "Item 2", "Item 3", "Item 4"]
//     @State private var selectedItems: Set<String> = []
//
//     var body: some View {
//         Menu("Select Items") {
//             ForEach(menuItems, id: \.self) { menuItem in
//                 Button(action: {
//                     if selectedItems.contains(menuItem) {
//                         selectedItems.remove(menuItem)
//                     } else {
//                         selectedItems.insert(menuItem)
//                     }
//                 }) {
//                     HStack {
//                         Text(menuItem)
//                         Spacer()
//                         if selectedItems.contains(menuItem) {
//                             Image(systemName: "checkmark")
//                         }
//                     }
//                 }
//             }
//         }
//     }
// }


struct OpacityPicker_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            OpacityPicker(viewModel: MakeWidgetViewModel(), proxy: proxy)
        }
    }
}
