//
//  EditToggleButton.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct EditingToggleButton: View {
    
    @State var alertMessage: LocalizedStringKey = "알수 없는 오류 발생"
    @State var isAlertPresent: Bool = false
    @Binding var isEditingMode: Bool
    @ObservedObject var viewModel: LinkWidgetModel
    var selectedWidget: DeepLink
    
    var body: some View {
        Button {
            if isEditingMode {
                if viewModel.widgetName == "" || viewModel.widgetURL == "" {
                    alertMessage = "빈칸을 채워주세요."
                    isAlertPresent.toggle()
                    return
                }
                
                if viewModel.widgetImage == nil {
                    alertMessage = "사진을 추가해주세요."
                    isAlertPresent.toggle()
                    return
                }
            }
            editWidget()
            isEditingMode.toggle()
            
        } label: {
            if isEditingMode {
                Text("편집 완료")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 17))
                    .frame(width: 200, height: 30)
                    .background(Color.init(uiColor: .systemPink))
            } else {
                Text("위젯 편집")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 17))
                    .frame(width: 200, height: 30)
                    .background(Color.init(uiColor: AppColors.buttonPurple))
            }
        }
        .cornerRadius(8)
        .alert(alertMessage, isPresented: $isAlertPresent) { }
    }
    
    func editWidget() {
        
        self.selectedWidget.name = viewModel.widgetName
        if self.selectedWidget.image != viewModel.widgetImage?.pngData() {
            self.selectedWidget.image = viewModel.widgetImage?.pngData()
        }
        self.selectedWidget.deepLink = viewModel.widgetURL
        
        WidgetCoreData.shared.saveData()
    }
    
 
}


struct EditToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        EditingToggleButton(
            isEditingMode: .constant(false),
            viewModel: .init(),
            selectedWidget: DeepLink.example
        )
    }
}
