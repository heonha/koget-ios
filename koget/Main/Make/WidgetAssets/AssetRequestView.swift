//
//  AssetRequestView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/19.
//

import SwiftUI
import Localize_Swift
import SwiftEntryKit

struct AssetRequestView: View {
    @StateObject var viewModel = AssetRequestViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("앱/웹 추가 요청")
                .font(.custom(CustomFont.NotoSansKR.light, size: 20))
                .fontWeight(.bold)
            Divider()
            // MARK: 앱 이름
            HStack {
                Spacer()
                Text("앱/웹 이름")
                    .bold()
                    .frame(width: 100)
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.init(uiColor: .secondarySystemFill))
                        .opacity(0.8)
                    TextField("요청할 앱/웹 이름", text: $viewModel.appName)
                        .font(.custom(CustomFont.NotoSansKR.light, size: 16))
                        .padding(.horizontal, 4)
                        .background(Color.clear)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textCase(.none)
                }
                .padding(.trailing, 16)
                .padding(.vertical, 4)
            }
            .frame(height: 50)
            
            // MARK: 앱 이름
            HStack {
                Spacer()
                
                Text("내용")
                    .font(.custom(CustomFont.NotoSansKR.bold, size: 16))
                    .frame(width: 100)
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.init(uiColor: .secondarySystemFill))
                        .opacity(0.8)
                    TextField("선택사항", text: $viewModel.body)
                        .font(.custom(CustomFont.NotoSansKR.light, size: 16))
                        .padding(.horizontal, 4)
                        .background(Color.clear)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textCase(.none)
                }
                .padding(.trailing, 16)
                .padding(.vertical, 4)
            }
            .frame(height: 50)

            Text("요청하신 앱/웹은 검토 결과에 따라 앱에 추가 될 예정입니다.")
                .font(.custom(CustomFont.NotoSansKR.medium, size: 13))
                .padding()

            TextButton(title: "보내기", titleColor: .white, backgroundColor: AppColor.kogetBlue) {
                viewModel.checkTheField { result in
                    switch result {
                    case .success:
                        self.dismiss()
                        viewModel.alertHandelr(type: result)
                    default:
                        viewModel.alertHandelr(type: result)
                        return
                    }
                }
            }
            .padding(.horizontal, 24)
            Spacer()
        }
        .padding(.vertical)
        .presentationDetents([.medium])
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct AssetRequestView_Previews: PreviewProvider {
    static var previews: some View {
        AssetRequestView()
    }
}
