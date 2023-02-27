//
//  LinkWidgetOpacityPicker.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/27.
//

import SwiftUI

struct LinkWidgetOpacityPicker: View {
    
    @StateObject var viewModel: MakeWidgetViewModel
    var pickerWidthRatio: CGFloat = 0.5
    @Binding var isPresentQustionmark: Bool

    
    var body: some View {
        
        
        HStack {
            Text("투명도")
                .font(.system(size: 20, weight: .bold))
            Button {
                isPresentQustionmark.toggle()
            } label: {
                Image(systemName: "questionmark.circle")
                    .foregroundColor(.gray)
            }
            .overlay(
                    ZStack(content: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)

                        Text("잠금화면 위젯의 불투명도입니다.")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                    })
                    .frame(width: DEVICE_SIZE.width * 0.5, height: 30)
                    .offset(x: 50, y: -40)
                    .opacity( isPresentQustionmark ? 0.7 : 0.0 )
                    .animation(.linear(duration: 0.2), value: isPresentQustionmark)
            )
            
           
            Spacer()
            OpacityPicker(viewModel: viewModel, widthRatio: pickerWidthRatio, type: .make)
            Spacer()
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .grayscale(1)
                    .clipShape(Circle())
                    .opacity(viewModel.opacityValue ?? 1.0)
                    .opacity(0.7)
            }
            
            
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        
        .padding(.bottom, 16)
    }
}


struct LinkWidgetOpcityPicker_Previews: PreviewProvider {
    static var previews: some View {
        LinkWidgetOpacityPicker(viewModel: MakeWidgetViewModel(), isPresentQustionmark: .constant(false))
    }
}
