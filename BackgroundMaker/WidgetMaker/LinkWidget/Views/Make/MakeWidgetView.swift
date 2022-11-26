//
//  AddWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/22.
//

import SwiftUI
import CoreData

struct MakeWidgetView: View {
    
    
    @StateObject var viewModel = LinkWidgetModel()
    
    @State var iconImage: UIImage = UIImage(named: "plus.circle")!
    @State var alertMessage: LocalizedStringKey = "오류 발생"
    
    //Present Views
    @State var isPresent: Bool = false
    @State var isAlertPresent: Bool = false
    @State var isAddAlertPresent: Bool = false
    @State var isApplistPresent: Bool = false
    @State var isPhotoViewPresent: Bool = false
    @State var isShowingPicker: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Color.init(uiColor: AppColors.deepDarkGrey)
                .ignoresSafeArea()
            VStack {
                Text("위젯 추가하기")
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .background(Color(uiColor: AppColors.buttonPurple))
                
                // 앱 선택 이미지
                Menu {
                    Button(action: {
                        isApplistPresent = true
                    }) {
                        Label("앱 불러오기", systemImage: "plus.circle.fill")
                    }
                    Button(action: {
                        isPhotoViewPresent = true
                    }) {
                        Label("사진 바꾸기", systemImage: "photo")
                    }
                } label: {
                    Image(uiImage: viewModel.widgetImage ?? UIImage(named: "plus.circle")!)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding()
                    
                }.sheet(isPresented: $isApplistPresent) {
                    WidgetAssetList(viewModel: viewModel)
                }
                .sheet(isPresented: $isPhotoViewPresent) {
                    PhotoPicker(widgetModel: viewModel)
                }
                TextFieldView(title: "위젯 이름", placeHolder: "위젯 이름", text: $viewModel.widgetName)
                    .padding(.bottom, 16)
                TextFieldView(title: "URL", placeHolder: "예시: youtube://", text: $viewModel.widgetURL)
                    .padding(.bottom, 16)
                
                // 위젯생성 버튼
                Button {
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
                    
                    addWidget()
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("위젯 생성")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, maxHeight: 40)

                }
                .background(Color.init(uiColor: AppColors.buttonPurple))
                .cornerRadius(10)
                .padding(.horizontal,16)
                .padding(.bottom, 8)
                .alert(alertMessage, isPresented: $isAlertPresent) { }
                
                // 돌아가기 버튼
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("돌아가기")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                }
                .background(Color.init(uiColor: .darkGray))
                .cornerRadius(10)
                .padding(.horizontal,16)
                
                
                Spacer()
            }
        }
     

    }
    
    func addWidget() {
        
        let item = DeepLink(context: WidgetCoreData.shared.coredataContext)
        item.id = UUID()
        item.name = viewModel.widgetName
        item.image = viewModel.widgetImage?.pngData()
        item.deepLink = viewModel.widgetURL
        item.addedDate = Date()
        
        WidgetCoreData.shared.addDeepLinkWidget(widget: item)
    }
    
}

struct AddWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MakeWidgetView()
    }
}

struct TextFieldView: View {
    
    let title: String
    let placeHolder: String
    let padding: CGFloat = 32
    
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 20))
                .lineLimit(1)
                .frame(height: 40)
                .padding(.horizontal, 16)
            TextField(placeHolder, text: $text)
                .frame(height: 40)
                .background(Color.init(uiColor: .darkGray))
                .cornerRadius(10)
                .padding(.horizontal, 16)
        }
    }
}
