//
//  EKMakerTester.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/05.
//

import SwiftUI
import SwiftEntryKit

struct EKMakerTester: View {

    @StateObject var viewModel = MakeWidgetViewModel()

    @State var toastUIView = UIView()

    @Environment(\.dismiss) var dismiss

    var body: some View {

        //MARK: - Contents
        VStack(spacing: 16) {
            // 이미지 선택 메뉴

            Button {
                displayToast()
                // isAppPickerPresent.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(Constants.kogetGradient)
                    Text("앱 리스트에서 가져오기")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            .onAppear {
                toastUIView = AlertFactory.setPopupView(title: "타이틀", subtitle: "서브타이틀", named: "success")
            }
        }
    }

    private func saveWidget() {
        viewModel.addWidget()
        self.dismiss()
    }

    func displayToast() {
        SwiftEntryKit.display(entry: toastUIView, using: AlertFactory.makeBaseAlertAttribute())
    }
}
