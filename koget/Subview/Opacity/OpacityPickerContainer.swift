//
//  OpacityPickerContainer.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/27.
//

import SwiftUI
import SFSafeSymbols

struct OpacityPickerContainer<V: VMOpacityProtocol>: View {
    
    @StateObject var viewModel: V
    @Binding var isPresentQustionmark: Bool
    @StateObject var constant = Constants.shared

    var body: some View {
        VStack {
            opacityPicker
                .frame(height: 40)

            opacitySliderContainer
                .frame(height: 40)
        }
    }

    var opacityPicker: some View {
        HStack(alignment: .center) {
            
            // Icon
            Image(systemSymbol: .circleDashed)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColor.Label.second)
                .frame(width: 40)
            // Opacity Value
            ZStack {
                Text("\(Int(viewModel.opacityValue * 100))%")
                    .font(.custom(viewModel.isOpacitySliderEditing
                                  ? CustomFont.NotoSansKR.bold
                                  : CustomFont.NotoSansKR.medium,
                                  size: 18))
                    .padding(.horizontal, 4)
                    .foregroundColor(viewModel.isOpacitySliderEditing
                                     ? AppColor.kogetBlue
                                     : AppColor.Label.first)
            }

            // Popup
            Button {
                isPresentQustionmark.toggle()
            } label: {
                Image(systemSymbol: .questionmarkCircle)
                    .foregroundColor(AppColor.Label.third)
            }
            .overlay(
                ZStack(content: {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(AppColor.Background.third)
                        .opacity(0.95)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                    Text("잠금화면 위젯의 불투명도입니다.")
                        .font(.custom(CustomFont.NotoSansKR.light, size: 13))
                        .foregroundColor(AppColor.Label.first)
                })
                .frame(width: deviceSize.width * 0.5, height: 30)
                .offset(x: 80, y: -40)
                .opacity( isPresentQustionmark ? 1.0 : 0.0 )
                .animation(.linear(duration: 0.15), value: isPresentQustionmark)
            )
            Spacer()
        }
        .frame(height: 40)

    }

    var opacitySliderContainer: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(viewModel.isEditingMode
                      ? AppColor.Fill.second
                      : (constant.isDarkMode ? AppColor.Background.second : AppColor.Background.first))
            OpacitySlider(viewModel: viewModel, widthRatio: 0.3)
                .offset(x: 0, y: viewModel.isEditingMode ? 0 : -15)
                .opacity(viewModel.isEditingMode ? 1 : 0)
        }
    }

}

struct LinkWidgetOpcityPicker_Previews: PreviewProvider {
    static var previews: some View {
        OpacityPickerContainer(viewModel: MakeWidgetViewModel(), isPresentQustionmark: .constant(false))
    }
}
