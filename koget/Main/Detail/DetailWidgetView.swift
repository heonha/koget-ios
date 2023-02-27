//
//  DetailWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI
import ToastUI

struct DetailWidgetView: View {
    
    
    var size: CGSize = .init(width: 300, height: 500)
    
    @State var selectedWidget: DeepLink
    
    @ObservedObject var viewModel = DetailWidgetViewModel()
    
    //Present Views
    @State var isPresent: Bool = false
    @State var isPhotoViewPresent: Bool = false
    @State var isShowingPicker: Bool = false
    @State var isDeleteAlertPresent: Bool = false
    @State var isEditingMode: Bool = false
    @State var isDelete: Bool = false
    @State var isPresentQustionmark: Bool = false
    
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
                    
                    
                    
                    //MARK: - 상단 바

                    HStack {
                        
                        //MARK: 삭제 버튼
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
                        
                        //MARK: 닫기버튼
                        
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
                
                
                //MARK: - 아이콘
                
                Group {
                    
                    PhotoEditMenu(isEditingMode: $isEditingMode,
                                  isPhotoViewPresent: $isPhotoViewPresent,
                                  viewModel: viewModel)
                    .shadow(radius: 1, x: 0.2, y: 0.3)
                    
                }

                //MARK: - 이름, URL
                
                    
               
                VStack {
                    
                    EditTextField(title: "위젯 이름", placeHolder: "위젯 이름", viewModel: viewModel, isEditingMode: $isEditingMode, text: $viewModel.name)
                    
                    EditTextField(title: "URL", placeHolder: "예시: youtube://", viewModel: viewModel, isEditingMode: $isEditingMode, text: $viewModel.url)
                    //MARK: - 투명도

                HStack {
                    Text("투명도")
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Text("\(Int(viewModel.opacityValue * 100))%")
                        .bold()
                    Spacer()
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .grayscale(1)
                            .clipShape(Circle())
                            .opacity(viewModel.opacityValue)
                            .opacity(0.7)
                            .animation(.easeInOut(duration: 0.4), value: viewModel.opacityValue)
                    }

                }
                    
                }
                .padding(.horizontal)

                if isEditingMode {
                    OpacitySlider(viewModel: viewModel, widthRatio: 0.3, type: .detail)
                        .padding(.horizontal)
                }
          

                
                
              
                
                VStack(alignment: .center, spacing: 12) {
                    // 편집 버튼
                    EditingToggleButton(selectedWidget: selectedWidget, isEditingMode: $isEditingMode, viewModel: viewModel)
                    
                    // 닫기 버튼
                    DetailWidgetButton(text: "닫기", buttonColor: .init(uiColor: .systemFill)) {
                        self.dismiss()
                    }
                    
                    
                }
                .padding(.top, 16)
                
                
                Spacer()
                
            }
        }.onAppear {
            viewModel.name = selectedWidget.name!
            viewModel.url = selectedWidget.url!
            viewModel.image = UIImage(data: selectedWidget.image ?? UIColor.white.image().pngData()!)
            if selectedWidget.opacity == nil {
                selectedWidget.opacity = 1.0
                viewModel.opacityValue = 1.0
                WidgetCoreData.shared.saveData()
                WidgetCoreData.shared.loadData()
            } else {
                viewModel.opacityValue = selectedWidget.opacity as? Double ?? 1.0
            }
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


