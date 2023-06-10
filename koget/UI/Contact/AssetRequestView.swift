//
//  AssetRequestView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/19.
//

import SwiftUI

struct AssetRequestView: View {
    @StateObject var viewModel = AssetRequestViewModel()
    @Environment(\.dismiss) var dismiss

    // strings
    let title = S.AppRequest.title
    let appName = S.AppRequest.appName
    let appNamePlaceholder = S.AppRequest.appNamePlaceholder
    let textBody = S.AppRequest.textBody
    let textBodyPlaceholder = S.AppRequest.textBodyPlaceholder
    let description = S.AppRequest.description
    let send = S.AppRequest.send

    var body: some View {
        VStack {
            Text(title)
                .font(.custom(.robotoLight, size: 20))
                .fontWeight(.bold)
            Divider()
            // MARK: 앱 이름
            HStack {
                Spacer()
                Text(appName)
                    .bold()
                    .frame(width: 100)
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.init(uiColor: .secondarySystemFill))
                        .opacity(0.8)
                    TextField(appNamePlaceholder, text: $viewModel.appName)
                        .font(.custom(.robotoLight, size: 16))
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
                
                Text(textBody)
                    .font(.custom(.robotoBold, size: 16))
                    .frame(width: 100)
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.init(uiColor: .secondarySystemFill))
                        .opacity(0.8)
                    TextField(textBodyPlaceholder, text: $viewModel.body)
                        .font(.custom(.robotoLight, size: 16))
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

            Text(description)
                .font(.custom(.robotoMedium, size: 13))
                .padding()

            TextButton(title: send, titleColor: .white, backgroundColor: AppColor.kogetBlue) {
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
