//
//  DetailWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI
import ToastUI

struct DetailWidgetView: View {
    
    
    var size: CGSize = .init(width: 300, height: 410)
    
    @State var selectedWidget: DeepLink
    
    @ObservedObject var viewModel = MakeWidgetViewModel()
    
    //Present Views
    @State var isPresent: Bool = false
    @State var isPhotoViewPresent: Bool = false
    @State var isShowingPicker: Bool = false
    @State var isDeleteAlertPresent: Bool = false
    @State var isEditingMode: Bool = false
    @State var isDelete: Bool = false
    
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            AppColors.backgroundColor
            VStack {
                ZStack {
                    
                    // 제목
                    HStack(alignment: .center) {
                        Text(viewModel.name)
                            .frame(maxWidth: .infinity, maxHeight: 45, alignment: .center)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.init(uiColor: .white))
                            .padding(.horizontal, 35)
                    }
                    .background(Color.init(uiColor: .darkGray))
                    
                    HStack {
                        // 상단 바 아이템
                        Button {
                            isDeleteAlertPresent.toggle()
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                            
                        }
                        .alert("삭제 확인", isPresented: $isDeleteAlertPresent, actions: {
                            Button("삭제", role: .destructive) {
                                WidgetCoreData.shared.deleteData(data: selectedWidget)
                                self.dismiss()
                                MainWidgetViewModel.shared.deleteSuccessful = true
                            }
                            Button("취소", role: .cancel) {}
                        }, message: { Text("정말 삭제 하시겠습니까?") })
                        
                        
                        Spacer()
                        
                        Button {
                            self.dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 8)
                }
                
                
                // 위젯 이미지
                Spacer()
                PhotoEditMenu(isEditingMode: $isEditingMode,
                              isPhotoViewPresent: $isPhotoViewPresent,
                              viewModel: viewModel)
                .shadow(radius: 1, x: 0.2, y: 0.3)
                
                
                Spacer()
                
                // 위젯 정보
                EditTextField(title: "위젯 이름", placeHolder: "위젯 이름", viewModel: viewModel, isEditingMode: $isEditingMode, text: $viewModel.name)
                EditTextField(title: "URL", placeHolder: "예시: youtube://", viewModel: viewModel, isEditingMode: $isEditingMode, text: $viewModel.url)
                Spacer()
                
                
                
                VStack(alignment: .center, spacing: 12) {
                    // 편집 버튼
                    EditingToggleButton(selectedWidget: selectedWidget, isEditingMode: $isEditingMode, viewModel: viewModel)
                    
                    // 닫기 버튼
                    DetailWidgetButton(text: "닫기", buttonColor: .init(uiColor: .systemFill)) {
                        self.dismiss()
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
        .shadow(radius: 1)
    }
    
    
    
}

struct EditWidgetView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        NavigationView {
            DetailWidgetView(selectedWidget: DeepLink.example)
        }
    }
    
}

