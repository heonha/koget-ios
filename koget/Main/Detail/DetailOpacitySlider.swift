//
//  DetailOpacitySlider.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/27.
//

import SwiftUI

struct DetailOpacitySlider: View {

    @StateObject var viewModel: DetailWidgetViewModel
    
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
                    .font(.system(size: 12))
                    .foregroundColor(AppColor.Label.second)
            } maximumValueLabel: {
                Text("불투명")
                    .font(.system(size: 12))
                    .foregroundColor(AppColor.Label.second)
            } onEditingChanged: { editing in
                viewModel.isOpacitySliderEditing = editing
            }
            .tint(AppColor.kogetBlue)
            .padding(.horizontal)
            .padding(.vertical, 2)
            .cornerRadius(8)
    }
}

struct OpacitySlider_Previews: PreviewProvider {
    static var previews: some View {
        DetailOpacitySlider(viewModel: DetailWidgetViewModel(), widthRatio: 1)
    }
}
