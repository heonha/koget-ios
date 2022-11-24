//
//  EditWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI

struct EditWidgetView: View {
    
    let selectedWidget: DeepLink
    let deviceSize = UIScreen.main.bounds
    
    @StateObject var viewModel = WidgetModels()
    
    @State var alertMessage: LocalizedStringKey = "오류 발생"
    
    //Present Views
    @State var isPresent: Bool = false
    @State var isAlertPresent: Bool = false
    @State var isPhotoViewPresent: Bool = false
    @State var isShowingPicker: Bool = false
    @State var isEditingMode: Bool = false
    @State var isDeleteAlertPresent: Bool = false
    
    
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
                Button {
                    isPhotoViewPresent = true
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
                Spacer()
                
                EditTextFieldView(title: "위젯 이름", placeHolder: "위젯 이름", isEditingMode: $isEditingMode, text: $viewModel.widgetName)
                EditTextFieldView(title: "URL", placeHolder: "예시: youtube://", isEditingMode: $isEditingMode, text: $viewModel.widgetURL)
                Spacer()
                
                VStack(alignment: .leading) {
                    // 위젯생성 버튼
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
                            
                            editWidget()
                        } else {
                            
                        }
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
                    .padding(.horizontal,16)
                    .padding(.bottom, 4)
                    .alert(alertMessage, isPresented: $isAlertPresent) { }
                    // 삭제 버튼
                    Button {
                        isDeleteAlertPresent = true
                    } label: {
                        Text("삭제")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 17))
                            .frame(width: 200, height: 30)
                    }
                    .alert("삭제 확인", isPresented: $isDeleteAlertPresent, actions: {
                        Button("삭제", role: .destructive) {
                            WidgetCoreData.shared.deleteData(data: selectedWidget)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Button("취소", role: .cancel) { }
                    }, message: {
                        Text("정말 삭제 하시겠습니까?")
                    })
                    .background(Color("DeleteColor"))
                    .cornerRadius(8)
                    .padding(.horizontal,16)
                    .padding(.bottom, 4)
                    
                    // 돌아가기 버튼
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("돌아가기")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 17))
                            .frame(width: 200, height: 30)
                    }
                    .background(Color.init(uiColor: .darkGray))
                    .cornerRadius(8)
                    .padding(.horizontal,16)
                    
                    
                }
                
                Spacer()
                
            }
        }.onAppear {
            viewModel.widgetImage = UIImage(data: selectedWidget.image!)
            viewModel.widgetName = selectedWidget.name!
            viewModel.widgetURL = selectedWidget.deepLink!
        }
        .frame(width: 300, height: 450)
        .background(Color.init(uiColor: .clear))
        .cornerRadius(10)
        
    }
    
    func editWidget() {
        
        let item = self.selectedWidget
        item.name = viewModel.widgetName
        item.image = viewModel.widgetImage?.pngData()
        item.deepLink = viewModel.widgetURL
        
        WidgetCoreData.shared.saveData()
        
    }
}

// struct EditWidgetView_Previews: PreviewProvider {
//     
//     
//     static var previews: some View {
//         EditWidgetView(widget: TestCoreData().deepLinkWidgets.first!)
//     }
// }


struct EditTextFieldView: View {
    
    let title: String
    let placeHolder: String
    let deviceSize = UIScreen.main.bounds
    @Binding var isEditingMode: Bool
    @Binding var text: String
    let padding: CGFloat = 32
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 18))
                .lineLimit(1)
                .frame(height: 40)
                .padding(.horizontal, 16)
                .padding(.bottom, -12)
            if isEditingMode {
                TextField(placeHolder, text: $text)
                    .frame(height: 35)
                    .background(Color.init(uiColor: .darkGray))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .disabled(!isEditingMode)
            } else {
                TextField(placeHolder, text: $text)
                    .frame(height: 35)
                    .background(Color.init(uiColor: AppColors.blackDarkGrey))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .disabled(!isEditingMode)
            }
            
        }
    }
}
