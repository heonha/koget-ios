//
//  OpacitySlider.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/27.
//

import SwiftUI

protocol VMOpacityProtocol: ObservableObject {
    var opacityValue: Double { get set }
    var isOpacitySliderEditing: Bool { get set }
    var isEditingMode: Bool { get set }
}

struct OpacitySlider<V: VMOpacityProtocol>: View {

    @ObservedObject var viewModel: V

    let opacityLabel = S.OpacitySlider.opacity
    let transparencyLabel = S.OpacitySlider.transparency
    var widthRatio: CGFloat

    var body: some View {

            Slider(
                value: $viewModel.opacityValue,
                in: 0.0...1.0,
                step: 0.1
            ) {

            } minimumValueLabel: {
                Text(transparencyLabel)
                    .font(.custom(.robotoRegular, size: 12))
                    .foregroundColor(AppColor.Label.second)
            } maximumValueLabel: {
                Text(opacityLabel)
                    .font(.custom(.robotoRegular, size: 12))
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
        OpacitySlider(viewModel: DetailWidgetViewModel(), widthRatio: 1)
    }
}
