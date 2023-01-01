//
//  AddWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/22.
//

import SwiftUI
import CoreData

struct MakeWidgetView: View {
    
    
    let navigationBarColor = AppColors.secondaryBackgroundColor
    
    @StateObject var viewModel = LinkWidgetModel()
    
    @State var iconImage: UIImage = UIImage(named: "plus.circle")!
    @State var alertMessage: LocalizedStringKey = "오류 발생"
    
    //Present Views
    @State var isPresent: Bool = false
    @State var isAlertPresent: Bool = false
    @State var isAddAlertPresent: Bool = false

    @State var isShowingPicker: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack {
            AppColors.secondaryBackgroundColor
                .ignoresSafeArea()
            Rectangle()
                .foregroundColor(AppColors.backgroundColor)

            VStack {
                // 이미지 선택 메뉴
                
                ImageMenuButton(viewModel: viewModel)
                    .padding()
                
                
                TextFieldView(title: "위젯 이름", placeHolder: "위젯 이름", text: $viewModel.name)
                    .padding([.bottom, .horizontal], 16)
                
                
                TextFieldView(title: "URL", placeHolder: "예시: youtube://", text: $viewModel.url)
                    .padding([.bottom, .horizontal], 16)
                

                // 위젯생성 버튼

                
                Button {
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
                    
                    addWidget()
                    self.dismiss()
                } label: {
                    ButtonWithText(title: "완료", titleColor: .white, color: .secondary)
                }
                .cornerRadius(5)
                .padding(.horizontal,16)
                .padding(.bottom, 8)
                .alert(alertMessage, isPresented: $isAlertPresent) { }
                
                // 돌아가기 버튼
                Button {
                    self.dismiss()
                } label: {
                    ButtonWithText(title: "돌아가기")
                }
                .padding(.horizontal,16)
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                ZStack {
                    Text("위젯 만들기")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                    .foregroundColor(AppColors.label)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        
        
        
        
    }
    
    func addWidget() {
        
        let item = DeepLink(context: WidgetCoreData.shared.coredataContext)
        item.id = UUID()
        item.name = viewModel.name
        item.image = viewModel.image?.pngData()
        item.url = viewModel.url
        item.addedDate = Date()
        
        WidgetCoreData.shared.addDeepLinkWidget(widget: item)
    }
    
}

struct AddWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MakeWidgetView()
        }
    }
}



