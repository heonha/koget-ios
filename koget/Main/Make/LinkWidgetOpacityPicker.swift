//
//  LinkWidgetOpacityPicker.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/27.
//

import SwiftUI
import SFSafeSymbols

struct LinkWidgetOpacityPicker: View {
    
    @StateObject var viewModel: MakeWidgetViewModel
    var pickerWidthRatio: CGFloat = 0.5
    @Binding var isPresentQustionmark: Bool

    var body: some View {
        VStack {

            if !viewModel.moreOptionOn {
                HStack {
                    Spacer()
                    Button {
                        viewModel.moreOptionOn.toggle()
                    } label: {
                        ZStack {
                            Text("투명도 조절")
                                .font(.custom(CustomFont.NotoSansKR.medium, size: 14))
                                .foregroundColor(AppColor.Label.second)
                                .padding(4)
                        }
                        .background(AppColor.Background.second)
                        .cornerRadius(5)
                    }
                }

            } else {
                HStack {
                    Image(systemSymbol: .circleDashed)
                        .font(.custom(CustomFont.NotoSansKR.bold, size: 20))
                        .foregroundColor(.init(uiColor: .lightGray))
                        .frame(width: 40, height: 40)
                    Spacer()
                    Text("\(Int(viewModel.opacityValue * 100))%")
                        .font(.custom(viewModel.isOpacitySliderEditing ? CustomFont.NotoSansKR.medium : CustomFont.NotoSansKR.bold, size: 18))
                        .foregroundColor(viewModel.isOpacitySliderEditing ? AppColor.kogetBlue : AppColor.Label.first)
                    Spacer()
                    Button {
                        isPresentQustionmark.toggle()
                    } label: {
                        Image(systemSymbol: .questionmarkCircle)
                            .foregroundColor(.gray)
                    }
                    .overlay(
                        ZStack(content: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColor.Background.second)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)

                            Text("잠금화면 위젯의 불투명도입니다.")
                                .font(.custom(CustomFont.NotoSansKR.light, size: 14))
                                .foregroundColor(AppColor.Label.first)
                        })
                        .frame(width: deviceSize.width * 0.7, height: 30)
                        .offset(x: -130, y: -40)
                        .opacity( isPresentQustionmark ? 0.9 : 0.0 )
                        .animation(.linear(duration: 0.2), value: isPresentQustionmark)
                    )
                }
                HStack {
                    Spacer()
                    VStack {
                        MakeOpacitySlider(viewModel: viewModel, widthRatio: pickerWidthRatio)
                    }
                    Spacer()
                }
            }

        }
        .animation(.easeOut(duration: 0.2), value: viewModel.moreOptionOn)
    }
}

struct LinkWidgetOpcityPicker_Previews: PreviewProvider {
    static var previews: some View {
        LinkWidgetOpacityPicker(viewModel: MakeWidgetViewModel(), isPresentQustionmark: .constant(false))
    }
}
