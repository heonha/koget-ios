//
//  ToggleButton.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import CoreData

struct ToggleButton: View {

    @StateObject var viewModel: DetailWidgetViewModel
    @StateObject var constant = Constants.shared

    var widget: DeepLink

    var body: some View {
        Button {
            viewModel.editingAction(widget: widget)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(viewModel.isEditingMode ? AppColor.kogetBlue : AppColor.Fill.first)
                Text(viewModel.isEditingMode ? "편집 완료" : "편집 하기")
                    .foregroundColor(viewModel.isEditingMode
                                     ? (constant.isDarkMode ? AppColor.Label.first : AppColor.Background.first)
                                     : AppColor.Label.first )
                    .fontWeight(.bold)
                    .font(.system(size: 17))
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
