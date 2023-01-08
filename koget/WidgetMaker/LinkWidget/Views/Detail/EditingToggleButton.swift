//
//  EditToggleButton.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct EditingToggleButton: View {
    
    
    var selectedWidget: DeepLink
    var size: CGSize = .init(width: 200, height: 35)
    
    @State var alertMessage: LocalizedStringKey = "알수 없는 오류 발생"
    @State var isAlertPresent: Bool = false
    @Binding var isEditingMode: Bool
    @ObservedObject var viewModel: MakeWidgetViewModel
    
    var body: some View {
        ZStack {
            if isEditingMode {
                Text("편집 완료")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 17))
                    .frame(width: size.width, height: size.height)
                    .background(Color.init(uiColor: .systemBlue))
            } else {
                Text("위젯 편집")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 17))
                    .frame(width: size.width, height: size.height)
                    .background(Color.init(uiColor: .darkGray))
            }
        }
        .onTapGesture {
            if isEditingMode {
                if viewModel.name == "" || viewModel.url == "" {
                    alertMessage = "빈칸을 채워주세요."
                    isAlertPresent.toggle()
                    return
                }
                
                if viewModel.image == nil {
                    alertMessage = "사진을 추가해주세요."
                    isAlertPresent.toggle()
                    return
                }
            }
            editWidget()
            isEditingMode.toggle()
        }
        .cornerRadius(8)
        .alert(alertMessage, isPresented: $isAlertPresent) { }
        
    }
    
    func editWidget() {
        
        self.selectedWidget.name = viewModel.name
        if self.selectedWidget.image != viewModel.image?.pngData() {
            self.selectedWidget.image = viewModel.image?.pngData()
        }
        self.selectedWidget.url = viewModel.url
        
        WidgetCoreData.shared.saveData()
    }
    
    
}


struct EditToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        EditingToggleButton(
            selectedWidget: DeepLink.example,
            isEditingMode: .constant(false),
            viewModel: .init()
        )
    }
}
