//
//  ContactView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI

struct ContactView: View {

    let title = S.ContactView.contact
    let deviceSize = Constants.deviceSize

    @State var titleText: String = ""
    @State var bodyText: String = ""
    @State var isSuccess: Bool = false
    @State var isFailure: Bool = false
    
    @State var isPresentSendAlert = false
    @StateObject var viewModel = ContactViewModel()
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                VStack {
                    Text(title)
                        .font(.custom(.robotoBold, size: 18))
                        .padding(.vertical)
                    Divider()
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(S.ContactView.type)

                                Spacer()

                                contactTypeMenu
                                    .frame(width: deviceSize.width / 1.5, height: 35)
                                Spacer()
                            }

                            Divider()
                            TextFieldView(placeholder: S.ContactView.title,
                                          type: .title,
                                          text: $viewModel.title)
                            .padding([.top, .bottom], 8)

                            Divider()
                            CustomTextEditor(placeHolder: S.ContactView.titlePlaceholder,
                                             text: $viewModel.body)
                            .frame(height: geometryProxy.size.height / 2.5)
                            .padding([.top, .bottom], 8)

                            TextButton(title: S.ContactView.sendContact, titleColor: .white, backgroundColor: AppColor.kogetBlue) {
                                isPresentSendAlert.toggle()
                            }
                            .padding([.top, .bottom], 8)
                            Divider()

                            noticeMessage

                            Spacer()
                        }
                        .padding(16)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(S.ContactView.contact)
                        .bold()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text(S.kogetVersion)
                        Text("\(viewModel.version ?? "-")")
                            .bold()
                    }
                    .font(.custom(.robotoRegular, size: 14))
                    .foregroundColor(.gray)
                    
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .alert(S.ContactView.checkContents, isPresented: $isPresentSendAlert) {
                alertCheckAction
            } message: {
                Text(S.ContactView.canYouSendContact)
            }
        }
    }

    var alertCheckAction: some View {
        Group {
            Button {
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
            } label: {
                Text(S.ContactView.send)
                    .bold()
            }
            
            Button {
            } label: {
                Text(S.Button.cancel) // 취소
            }
        }
    }
    
    var noticeMessage: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(S.ContactView.descriptionTitle)
                .bold()
            
            VStack(alignment: .leading, spacing: 2) {
                Text(S.ContactView.description1)
                Text(S.ContactView.description2)
                Text(S.ContactView.description3)
                Text(S.ContactView.description4)
            }
            .font(.custom(.robotoRegular, size: 15))
        }
        .foregroundColor(.gray)
        
    }
    
    var contactTypeMenu: some View {
        Menu {
            Button {
                viewModel.contactType = .app
            } label: {
                Text(ContectType.app.localizedDescription)
            }
            Button {
                viewModel.contactType = .addApp
                
            } label: {
                Text(ContectType.addApp.localizedDescription)
            }
            Button {
                viewModel.contactType = .feedback
            } label: {
                Text(ContectType.feedback.localizedDescription)
            }
            Button {
                viewModel.contactType = .etc
            } label: {
                Text(ContectType.etc.localizedDescription)
            }
        } label: {
            ZStack {
                if viewModel.contactType == .none {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.init(uiColor: .secondarySystemFill))
                }
                Text(viewModel.contactType.localizedDescription)
                    .bold()
                    .frame(width: deviceSize.width / 1.5, height: 35)
                    .foregroundColor(AppColor.Label.first)
            }
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactView()
        }
    }
}
