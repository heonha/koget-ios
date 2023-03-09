//
//  EditToggleButton.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import WidgetKit
import SwiftEntryKit

struct EditingToggleButton: View {
    var selectedWidget: DeepLink
    var size: CGSize = .init(width: 200, height: 35)

    @State var alertMessage: LocalizedStringKey = "알수 없는 오류 발생"
    @ObservedObject var viewModel: DetailWidgetViewModel

    @State var successAlert = UIView()

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            Button {
                if viewModel.isEditingMode {
                    if viewModel.name == "" || viewModel.url == "" {
                        alertMessage = "빈칸을 채워주세요."
                    } else if viewModel.image == nil {
                        alertMessage = "사진을 추가해주세요."
                    } else {
                        viewModel.editWidgetData(widget: selectedWidget)
                        dismiss()
                        displayToast()
                    }
                } else {
                    viewModel.isEditingMode = true
                }
            } label: {
                ZStack {
                RoundedRectangle(cornerRadius: 8)
                        .fill(viewModel.isEditingMode ? Color.init(uiColor: .systemBlue) : Color.init(uiColor: .darkGray))
                        .frame(width: size.width, height: size.height)
                Text(viewModel.isEditingMode ? "저장 후 닫기" : "위젯 편집")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 17))
                    .frame(width: size.width, height: size.height)
                }
            }
            .onAppear {
                successAlert = setAlertView()
            }
        }

    private func setAlertView() -> UIView {
        return EKMaker.setToastView(title: "위젯 편집 성공", subtitle: "편집된 내용은 15분 내 반영됩니다.", named: "success")
    }

    private func displayToast() {
        SwiftEntryKit.display(entry: successAlert, using: EKMaker.whiteAlertAttribute)
    }
}

struct EditToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        EditingToggleButton(
            selectedWidget: DeepLink.example,
            viewModel: .init()
        )
    }
}
