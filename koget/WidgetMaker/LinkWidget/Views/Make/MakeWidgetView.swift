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
    
    @StateObject var viewModel = MakeWidgetViewModel()
    
    @State var iconImage: UIImage = UIImage(named: "plus.circle")!
    @State var alertTitle: LocalizedStringKey = "오류"
    @State var alertMessage: LocalizedStringKey = ""
    
    //Present Views
    @State var isPresent: Bool = false
    @State var isAlertPresent: Bool = false
    @State var isAddAlertPresent: Bool = false
    
    @State var isShowingPicker: Bool = false
    var callURL: Bool = false
    
    @State var canOpenResult: Bool?
    
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
                    .shadow(radius: 0.7, x: 0.1, y: 0.1)
                    .padding()
                
                VStack(alignment: .leading) {
                    
                    Text("위젯이름")
                        .font(.system(size: 20, weight: .bold))
                        .lineLimit(1)
                        .frame(height: 40)
                        .padding(.leading, 8)
                    
                    TextFieldView(placeHolder: "위젯 이름", text: $viewModel.name)
                        .padding([.bottom, .horizontal], 16)
                }
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("URL")
                                .font(.system(size: 20, weight: .bold))
                                .lineLimit(1)
                                .frame(height: 40)
                                .padding(.leading, 8)
                            
                            Spacer()
                            if let canOpen = canOpenResult {
                                if canOpen {
                                    Text("실행성공")
                                        .foregroundColor(.green)
                                        .font(.system(size: 14))
                                } else {
                                    Text("실행실패")
                                        .foregroundColor(.red)
                                        .font(.system(size: 14))
                                }
                            }
                            
                            
                            //MARK: 테스트 버튼
                            Button {
                                
                                if viewModel.url.contains("://") {
                                    if let url = URL(string: viewModel.url) {
                                        UIApplication.shared.open(url) { bool in
                                            self.canOpenResult = bool
                                        }
                                    } else {
                                        self.canOpenResult = false
                                    }
                                } else {
                                    alertTitle = "URL 확인"
                                    alertMessage = "문자열 :// 이 반드시 들어가야합니다. \n(앱이름:// 또는 https://주소)"
                                    isAlertPresent.toggle()
                                    self.canOpenResult = false
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                                    self.canOpenResult = nil
                                }
                                
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .tint(.init(uiColor: .secondarySystemFill))
                                    Text("URL 실행 테스트")
                                        .foregroundColor(.black)
                                        .font(.system(size: 16))
                                }
                            }
                            .frame(width: 120, height: 25)
                            .padding(.trailing)
                            
                            
                        }
                        
                        TextFieldView(placeHolder: "예시: youtube://", text: $viewModel.url)
                            .padding([.bottom, .horizontal], 16)
                    }
                    
                    
                    Spacer()
                }
                
                
                // 위젯생성 버튼
                
                
                Button {
                    if viewModel.name == "" || viewModel.url == "" {
                        alertTitle = "오류"
                        alertMessage = "빈칸을 채워주세요."
                        isAlertPresent.toggle()
                        return
                    }
                    
                    if viewModel.image == nil {
                        alertTitle = "오류"
                        alertMessage = "사진을 추가해주세요."
                        isAlertPresent.toggle()
                        return
                    }
                    
                    if !viewModel.checkURLSyntex() {
                        alertTitle = "URL 확인"
                        alertMessage = "문자열 :// 이 반드시 들어가야합니다. \n(앱이름:// 또는 https://주소)"
                        isAlertPresent.toggle()
                        return
                    }
                    
                    addWidget()
                    self.dismiss()
                } label: {
                    ButtonWithText(title: "완료", titleColor: .white, color: .secondary)
                }
                .alert(alertTitle, isPresented: $isAlertPresent) {
                    
                } message: {
                    Text(alertMessage)
                }
                .cornerRadius(5)
                .padding(.horizontal,16)
                .padding(.bottom, 8)
                
                
                
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
    
    func canOpenURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {return false}
        return UIApplication.shared.canOpenURL(url)
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
    
    
    func testing() {
    }
    
    
    
}

struct AddWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MakeWidgetView()
        }
    }
}



