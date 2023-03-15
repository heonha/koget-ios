//
//  ContactView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI
import SwiftEntryKit
import Localize_Swift

enum ContectType: String {
    case app
    case addApp
    case feedback
    case etc
    case none

    var localizedDescription: String {
        switch self {
        case .app:
            S.ContactType.problemApp
        case .addApp:
            S.ContactType.requestApp
        case .feedback:
            S.ContactType.feedback
        case .etc:
            S.ContactType.etc
        case .none:
            S.ContactType.select
        }
    }

}

struct ContactView: View {
    @State var titleText: String = ""
    @State var bodyText: String = ""
    @State var isSuccess: Bool = false
    @State var isFailure: Bool = false
    
    @State var isPresentSendAlert = false
    @StateObject var viewModel = ContactViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var successAlert = UIView()
    @State var errorAlert = UIView()
    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
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
                        
                        TextButton(title: S.ContactView.sendContact, backgroundColor: AppColor.kogetBlue) {
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
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .alert(S.ContactView.checkContents, isPresented: $isPresentSendAlert) {
                Button {
                    viewModel.checkTheField { result in
                        if result {
                            self.dismiss()
                            self.presentSuccessAlert()
                        } else {
                            self.presentErrorAlert()
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
            } message: {
                Text(S.ContactView.canYouSendContact)
            }
            .onAppear {
                successAlert = setAlertView()
                errorAlert = setErrorAlertView()
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
            .font(.system(size: 15))
        }
        .foregroundColor(.gray)
        
    }
    
    var contactTypeMenu: some View {
        Menu {
            Button {
                viewModel.contactType = .app
            } label: {
                Text(ContectType.app.rawValue.localized())
            }
            Button {
                viewModel.contactType = .addApp
                
            } label: {
                Text(ContectType.addApp.rawValue.localized())
            }
            Button {
                viewModel.contactType = .feedback
            } label: {
                Text(ContectType.feedback.rawValue.localized())
            }
            Button {
                viewModel.contactType = .etc
            } label: {
                Text(ContectType.etc.rawValue.localized())
            }
        } label: {
            ZStack {
                if viewModel.contactType == .none {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.init(uiColor: .secondarySystemFill))
                }
                Text(viewModel.contactType.rawValue.localized())
                    .bold()
                    .frame(width: deviceSize.width / 1.5, height: 35)
                    .foregroundColor(AppColor.Label.first)
            }
        }
    }
    
    private func setAlertView() -> UIView {
        return EKMaker.setToastView(title: S.ContactView.Alert.sendSuccess.localized(), subtitle: S.ContactView.Alert.sendSuccessSubtitle.localized(), named: "success")
    }
    
    private func presentSuccessAlert() {
        SwiftEntryKit.display(entry: successAlert, using: EKMaker.whiteAlertAttribute)
    }
    
    private func setErrorAlertView() -> UIView {
        return EKMaker.setToastView(title: S.ContactView.Alert.needCheck.localized(), subtitle: S.ContactView.Alert.checkEmptyCell.localized(), named: "failed")
    }
    
    private func presentErrorAlert() {
        SwiftEntryKit.display(entry: errorAlert, using: EKMaker.whiteAlertAttribute)
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactView()
        }
    }
}
