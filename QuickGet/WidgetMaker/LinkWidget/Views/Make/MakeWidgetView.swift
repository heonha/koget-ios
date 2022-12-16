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
            AppColors.normalDarkGrey
                .ignoresSafeArea()
            VStack {
                Text("위젯 만들기")
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .background(Color("choco"))
                
                
                // 이미지 선택 메뉴
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
                    Image(uiImage: viewModel.image ?? UIImage(named: "plus.circle")!)
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
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    ButtonLabel(title: "만들기", type: .apply)
                        .background(Color("choco"))
                }
                .cornerRadius(10)
                .padding(.horizontal,16)
                .padding(.bottom, 8)
                .alert(alertMessage, isPresented: $isAlertPresent) { }
                
                // 돌아가기 버튼
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    ButtonLabel(title: "돌아가기")
                }
                .padding(.horizontal,16)
                
                
                Spacer()
            }
        }
        
        
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
        MakeWidgetView()
    }
}


enum ButtonColor: String {
    case apply = "choco"
    case destroy = "destroy"
    case normal = "darkGray"
}


struct ButtonLabel: View {
    
    var title: String
    var buttonSize: CGFloat = Constants.deviceSize.width - 32
    var type: ButtonColor = .normal
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: buttonSize, height: 40)
                .foregroundColor(Color(type.rawValue))
                .clipped()
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.system(size: 18))
            .frame(width: buttonSize, height: 40)
        }
        
        
    }
}
