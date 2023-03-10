//
//  MakeOpacitySlider.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/10.
//

import SwiftUI

struct MakeOpacitySlider: View {

    @StateObject var viewModel: MakeWidgetViewModel

    var widthRatio: CGFloat
    var body: some View {
            Slider(
                value: $viewModel.opacityValue,
                in: 0.0...1.0,
                step: 0.1
            ) {
                Text("Speed")
            } minimumValueLabel: {
                Text("투명")
                    .font(.system(size: 13))
                    .foregroundColor(AppColor.Label.second)
            } maximumValueLabel: {
                Text("불투명")
                    .font(.system(size: 13))
                    .foregroundColor(AppColor.Label.second)

            } onEditingChanged: { editing in
                viewModel.isOpacitySliderEditing = editing
            }
            .tint(AppColor.kogetBlue)
            .padding(.horizontal, 4)
            .padding(.vertical, 4)

        .background(AppColor.Background.second)
        .cornerRadius(8)
    }
}
struct MakeOpacitySlider_Previews: PreviewProvider {
    static var previews: some View {
        MakeOpacitySlider(viewModel: MakeWidgetViewModel(), widthRatio: 0.3)
    }
}
