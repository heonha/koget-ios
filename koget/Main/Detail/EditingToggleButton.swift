//
//  EditToggleButton.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//
//
// import SwiftUI
// import WidgetKit
// import SwiftEntryKit
//
// struct EditingToggleButton: View {
//     var selectedWidget: DeepLink
//     var size: CGSize = .init(width: 200, height: 35)
//
//     @StateObject var viewModel: DetailWidgetViewModel
//
//     var body: some View {
//             Button {
//                 viewModel.editingAction(widget: selectedWidget)
//             } label: {
//                 ZStack {
//                 RoundedRectangle(cornerRadius: 8)
//                         .fill(viewModel.isEditingMode ? Color.init(uiColor: .systemBlue) : Color.init(uiColor: .darkGray))
//                         .frame(width: size.width, height: size.height)
//                 Text(viewModel.isEditingMode ? "저장 후 닫기" : "위젯 편집")
//                     .foregroundColor(.white)
//                     .fontWeight(.bold)
//                     .font(.system(size: 17))
//                     .frame(width: size.width, height: size.height)
//                 }
//             }
//         }
//
// }
//
// struct EditToggleButton_Previews: PreviewProvider {
//     static var previews: some View {
//         EditingToggleButton(
//             selectedWidget: DeepLink.example,
//             viewModel: .init()
//         )
//     }
// }
