//
//  OpacityPicker.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/25.
//

import SwiftUI

struct OpacityPicker: View {
    
    enum OpacityPickerType {
        case make
        case detail
    }

    @StateObject var viewModel: MakeWidgetViewModel
    var widthRatio: CGFloat
    var type: OpacityPickerType
    @State var checkedMenu = 0
    
    var body: some View {
        
        HStack {
            Spacer()
            
            Menu {
                Button {
                    viewModel.opacityValue = 0.0
                    // print(viewModel.opacityValue)
                } label: {
                    HStack {
                        Text("0% - 보이지 않음")
                        if viewModel.opacityValue == 0.0 {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .tag(0)
                
                Button {
                    viewModel.opacityValue = 0.25
                    // print(viewModel.opacityValue)
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
                    // print(viewModel.opacityValue)

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
                    // print(viewModel.opacityValue)
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
                    Text("100% - 기본값")
                    if viewModel.opacityValue == 1.0 {
                        Image(systemName: "checkmark")
                    }
                }
                .tag(100)
            } label: {
                ZStack {
                    Text("\(Int(viewModel.opacityValue * 100))%")
                        .foregroundColor(.init(uiColor: .secondaryLabel))
                        .bold()
                }
                .frame(width: deviceSize.width * widthRatio)
                .shadow(radius: 1)
                .animation(.none, value: viewModel.opacityValue)
            }
            Spacer()
        }
    }
}

struct OpacityPicker_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            OpacityPicker(viewModel: MakeWidgetViewModel(), widthRatio: 0.5, type: .make)
        }
    }
}
