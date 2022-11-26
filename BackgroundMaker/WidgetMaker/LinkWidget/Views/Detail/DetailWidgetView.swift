//
//  DetailWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI

struct DetailWidgetView: View {
    
    var selectedWidget: DeepLink
    
    @StateObject var viewModel = LinkWidgetModel()
    
    //Present Views
    @State var isPresent: Bool = false
    @State var isPhotoViewPresent: Bool = false
    @State var isShowingPicker: Bool = false
    @State var isDeleteAlertPresent: Bool = false
    
    @State var isEditingMode: Bool = false

    
    init(widget: DeepLink) {
        selectedWidget = widget
    }
    
    
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Color(uiColor: AppColors.blackDarkGrey)
                .ignoresSafeArea()
            VStack {
                HStack(alignment: .center) {
                    Text(viewModel.widgetName)
                        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                }.background(Color(uiColor: AppColors.buttonPurple))
                
                Spacer()
                // 앱 선택 이미지
                Menu {
                    // 앱 선택 이미지
                    if isEditingMode {
                        Button(action: {
                            isPhotoViewPresent.toggle()
                        }) {
                            Label("사진 바꾸기", systemImage: "photo")
                        }
                    }
                    
                } label: {
                    Image(uiImage: viewModel.widgetImage ?? UIImage(named: "plus.circle")!)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                }
                .sheet(isPresented: $isPhotoViewPresent) {
                    PhotoPicker(widgetModel: viewModel)
                }
                .disabled(!isEditingMode)

                Spacer()
                
                EditTextField(title: "위젯 이름", placeHolder: "위젯 이름", isEditingMode: $isEditingMode, text: $viewModel.widgetName)
                EditTextField(title: "URL", placeHolder: "예시: youtube://", isEditingMode: $isEditingMode, text: $viewModel.widgetURL)
                Spacer()
                
                VStack(alignment: .center) {
                    // 편집 버튼
                    EditingToggleButton(isEditingMode: $isEditingMode, viewModel: viewModel, selectedWidget: selectedWidget)
                    
                    // 삭제 버튼
                    DetailWidgetButton(text: "삭제", buttonColor: Color("DeleteColor")) {
                        isDeleteAlertPresent.toggle()
                    }
                    .alert("삭제 확인", isPresented: $isDeleteAlertPresent, actions: {
                        Button("삭제", role: .destructive) {
                            WidgetCoreData.shared.deleteData(data: selectedWidget)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Button("취소", role: .cancel) {}
                    }, message: { Text("정말 삭제 하시겠습니까?") })
                    
                    // 닫기 버튼
                    DetailWidgetButton(text: "닫기", buttonColor: .init(uiColor: .darkGray)) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    
                }
                
                Spacer()
                
            }
        }.onAppear {
            viewModel.widgetImage = UIImage(data: selectedWidget.image ?? UIColor.white.image().pngData()!)
            viewModel.widgetName = selectedWidget.name!
            viewModel.widgetURL = selectedWidget.deepLink!
        }
        .frame(width: 300, height: 450)
        .background(Color.init(uiColor: .clear))
        .cornerRadius(10)
        
    }
    
  

}

struct EditWidgetView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        NavigationView {
            DetailWidgetView(widget: DeepLink.example)
        }
    }
        
}

