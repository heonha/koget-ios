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

    private let alertFactory = AlertFactory.shared

    @Environment(\.dismiss) var dismiss

    var body: some View {

        //MARK: - Contents
        VStack(spacing: 16) {
            // 이미지 선택 메뉴

            Button {
                displayToast()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(Constants.kogetGradient)
                    Text("앱 리스트에서 가져오기")
                        .font(.custom(.robotoMedium, size: 18))
                        .foregroundColor(.black)
                }
            }
            .onAppear {
                alertFactory.setAlertView(title: "타이틀", subtitle: "서브타이틀", imageName: "success")
            }
        }
    }

    private func saveWidget() {
        viewModel.addWidget()
        self.dismiss()
    }

    func displayToast() {
        alertFactory.showAlert()
    }
}
