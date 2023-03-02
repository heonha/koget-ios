//
//  OpacitySlider.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/27.
//

import SwiftUI

struct OpacitySlider: View {
    
    enum OpacityPickerType {
        case make
        case detail
    }
    
    @StateObject var viewModel: DetailWidgetViewModel
    var widthRatio: CGFloat
    var type: OpacityPickerType
    @State var checkedMenu = 0
    
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
                    .foregroundColor(.gray)
            } maximumValueLabel: {
                Text("불투명")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)

            } onEditingChanged: { editing in
                viewModel.isEditing = editing
            }
            .tint(.pink)
            .padding(.horizontal)
            .padding(.vertical, 4)

        .background(Color.init(uiColor: .secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct OpacitySlider_Previews: PreviewProvider {
    static var previews: some View {
        OpacitySlider(viewModel: DetailWidgetViewModel(), widthRatio: 1, type: .detail)
    }
}
