//
//  ToggleButton.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import CoreData

struct ToggleButton: View {

    @ObservedObject var viewModel: DetailWidgetViewModel
    @ObservedObject var constant = AppStateConstant.shared

    let editLabel = S.Button.edit
    let saveLabel = S.Button.save

    var widget: DeepLink
    let font: Font = .custom(.robotoMedium, size: 18)

    var body: some View {
        Button {
            viewModel.editingAction(widget: widget)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(viewModel.isEditingMode
                          ? AppColor.kogetBlue
                          : AppColor.Fill.first)
                Text(viewModel.isEditingMode ? saveLabel : editLabel)
                    .foregroundColor(viewModel.isEditingMode
                                     ? (constant.isDarkMode ? AppColor.Label.first : AppColor.Background.first)
                                     : AppColor.Label.first )
                    .font(font)
            }
        }
        .cornerRadius(8)
        .frame(width: 200, height: 35)
    }
}

struct ToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        ToggleButton(viewModel: DetailWidgetViewModel(), widget: DeepLink.example)
            .environmentObject(WidgetCoreData.shared)
    }
}
