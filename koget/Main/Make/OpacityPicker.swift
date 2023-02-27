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
                    print(viewModel.opacityValue)
                    
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
                    Text("100% - 기본값")
                    if viewModel.opacityValue == 1.0 {
                        Image(systemName: "checkmark")
                    }
                }
                .tag(100)
                
                
                
            } label: {
                ZStack {
                    // RoundedRectangle(cornerRadius: 8)
                    //     .stroke(lineWidth: 1)
                    //     .frame(height: 30)
                    //     .foregroundStyle(.gray)
                    //     .opacity(1.0)
                    //
                    if let opacity = viewModel.opacityValue {
                        Text("\(Int(opacity * 100))%")
                            .foregroundColor(.init(uiColor: .secondaryLabel))
                            .bold()
                    } else {
                        HStack {
                            Text("선택하세요")
                            Image(systemName: "hand.point.up")
                        }
                            .foregroundColor(.black)
                    }
                }
                .frame(width: DEVICE_SIZE.width * widthRatio)
                .shadow(radius: 1)
                .animation(.none, value: viewModel.opacityValue)
            }
            Spacer()
            
           
        }
        .onAppear {
            
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

