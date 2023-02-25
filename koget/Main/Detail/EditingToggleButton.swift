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
            Text(isEditingMode ? "편집 완료" : "위젯 편집")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.system(size: 17))
                .frame(width: size.width, height: size.height)
                .background(isEditingMode
                            ? Color.init(uiColor: .systemBlue)
                            : Color.init(uiColor: .darkGray)
                )
        }
        .onTapGesture {
            if isEditingMode {
                if viewModel.name == "" || viewModel.url == "" {
                    alertMessage = "빈칸을 채워주세요."
                    isAlertPresent.toggle()
                    return
                } else if viewModel.image == nil {
                    alertMessage = "사진을 추가해주세요."
                    isAlertPresent.toggle()
                    return
                } else {
                    viewModel.editWidgetData(widget: selectedWidget)
                }
            } 
            withAnimation {
                isEditingMode.toggle()
            }

        }
        .cornerRadius(8)
        .alert(alertMessage, isPresented: $isAlertPresent) { }
        
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
