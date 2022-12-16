//
//  DetailWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI

struct DetailWidgetView: View {
    
    
    var size: CGSize = .init(width: 300, height: 410)
    
    @State var selectedWidget: DeepLink
    
    @StateObject var viewModel = LinkWidgetModel()
    
    //Present Views
    @State var isPresent: Bool = false
    @State var isPhotoViewPresent: Bool = false
    @State var isShowingPicker: Bool = false
    @State var isDeleteAlertPresent: Bool = false
    @State var isEditingMode: Bool = false
    
    
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            
            AppColors.blackDarkGrey

            VStack {
                ZStack {
                    HStack(alignment: .center) {
                        Text(viewModel.name)
                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                    }.background(Color("choco"))
                    HStack {
                        Button {
                            isDeleteAlertPresent.toggle()
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.white)
                        }
                        .alert("삭제 확인", isPresented: $isDeleteAlertPresent, actions: {
                            Button("삭제", role: .destructive) {
                                WidgetCoreData.shared.deleteData(data: selectedWidget)
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            Button("취소", role: .cancel) {}
                        }, message: { Text("정말 삭제 하시겠습니까?") })
                        
                        
                        Spacer()
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 8)
                }
                
                Spacer()
                // 앱 선택 이미지
                PhotoEditMenu(isEditingMode: $isEditingMode,
                              isPhotoViewPresent: $isPhotoViewPresent,
                              viewModel: viewModel)
                
                
                Spacer()
                
                EditTextField(title: "위젯 이름", placeHolder: "위젯 이름", isEditingMode: $isEditingMode, text: $viewModel.name)
                EditTextField(title: "URL", placeHolder: "예시: youtube://", isEditingMode: $isEditingMode, text: $viewModel.url)
                Spacer()
                
                
                
                VStack(alignment: .center, spacing: 12) {
                    // 편집 버튼
                    EditingToggleButton(selectedWidget: selectedWidget, isEditingMode: $isEditingMode, viewModel: viewModel)
                    
                    // 닫기 버튼
                    DetailWidgetButton(text: "닫기", buttonColor: .init(uiColor: .darkGray)) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    
                }
                
                Spacer()
                
            }
        }.onAppear {
            viewModel.name = selectedWidget.name!
            viewModel.url = selectedWidget.url!
            viewModel.image = UIImage(data: selectedWidget.image ?? UIColor.white.image().pngData()!)
        }
        .frame(width: size.width, height: size.height)
        .background(Color.init(uiColor: .clear))
        .cornerRadius(10)
    }
    
    
    
}

struct EditWidgetView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        NavigationView {
            DetailWidgetView(selectedWidget: DeepLink.example)
        }
    }
    
}


