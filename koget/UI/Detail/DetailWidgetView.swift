//
//  DetailWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI
import SFSafeSymbols

struct DetailWidgetView: View {
    
    var size: CGSize = .init(width: 350, height: 600)
    var selectedWidget: DeepLink

    // Present Views
    @State var isPresent = false
    @State var isPhotoViewPresent = false
    @State var isShowingPicker = false
    @State var isDeleteAlertPresent = false
    @State var isDelete = false
    @State var isPresentQustionmark = false

    @EnvironmentObject var target: HomeWidgetViewModel
    @EnvironmentObject var constant: AppStateConstant
    @EnvironmentObject var coreData: WidgetCoreData
    @StateObject var viewModel = DetailWidgetViewModel()

    var body: some View {
        ZStack {
            Rectangle()
                .fill(constant.isDarkMode ? .thinMaterial : .regularMaterial)

            VStack {
                titleBar
                    .frame(height: 45)

                Spacer()

                // MARK: - 아이콘
                HStack(spacing: 8) {
                    PhotoEditMenu(isEditingMode: $viewModel.isEditingMode,
                                  viewModel: viewModel)
                }
                .shadow(radius: 1, x: 0.2, y: 0.3)
                .padding(4)

                Spacer()

                // MARK: - 이름, URL
                VStack(spacing: 12) {
                    EditTextField(systemSymbol: .tag,
                                  placeHolder: S.Textfield.Placeholder.widgetName,
                                  viewModel: viewModel,
                                  text: $viewModel.name)

                    EditTextField(systemSymbol: .link,
                                  placeHolder: S.Textfield.Placeholder.widgetUrlShort,
                                  viewModel: viewModel,
                                  text: $viewModel.url)

                    OpacityPickerContainer(viewModel: viewModel,
                                           isPresentQustionmark: $isPresentQustionmark)
                }
                .padding(.horizontal)

                Spacer()
                // 편집버튼
                ToggleButton(viewModel: viewModel, widget: selectedWidget)
                
                // 닫기 버튼
                TextButton(title: S.Button.close, backgroundColor: AppColor.Fill.third, size: (width: 200, height: 40)) {
                    withAnimation {
                        DispatchQueue.main.async {
                            target.showDetail = false
                        }
                    }
                }

                // 하단 텍스트: 반영까지 15분 걸립니다.
                Text(S.DetailWidgetView.bottomText)
                    .font(.custom(.robotoRegular, size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .padding(.horizontal)
                Spacer()

            }
            .animation(.linear(duration: 0.3), value: viewModel.isEditingMode)

        }
        .frame(width: size.width, height: size.height)
        .background(Color.init(uiColor: .clear))
        .cornerRadius(10)
        .shadow(radius: 1)
        .onTapGesture {
            isPresentQustionmark = false
            hideKeyboard()
        }
        .onAppear {
            setupView()
        }

    }

    // MARK: - Setup
    // onAppear
    private func setupView() {
        viewModel.name = selectedWidget.name ?? S.unknown
        viewModel.url = selectedWidget.url ?? S.unknown
        viewModel.image = UIImage(data: selectedWidget.image!)!
        
        if selectedWidget.opacity == nil {
            selectedWidget.opacity = 1.0
            viewModel.opacityValue = 1.0
            coreData.saveData()
            coreData.loadData()
        } else {
            viewModel.opacityValue = selectedWidget.opacity as? Double ?? 1.0
        }
    }

    // MARK: - Views
    var titleBar: some View {
        ZStack {
            // TitleBar
            AppColor.Fill.first
                .background(.thinMaterial)
            
            HStack(alignment: .center) {
                Text(viewModel.name)
                    .frame(maxWidth: .infinity, maxHeight: 45, alignment: .center)
                    .font(.custom(.robotoBold, size: 20))
                    .foregroundColor(AppColor.Label.first)
                    .padding(.horizontal, 35)
            }

            // TitleBar Item
            HStack {
                //MARK: 삭제 버튼
                Button {
                    isDeleteAlertPresent.toggle()
                } label: {
                    Image(systemSymbol: .trash)
                        .font(.custom(.robotoMedium, size: 18))
                        .foregroundColor(AppColor.kogetRed)
                        .fontWeight(.bold)
                }
                .alert(S.Alert.checkDelete, isPresented: $isDeleteAlertPresent, actions: {
                    Button(S.Button.delete, role: .destructive) {
                        coreData.deleteData(data: selectedWidget)
                    }
                    Button(S.Button.cancel, role: .cancel) {}
                }, message: { Text(S.Alert.Message.checkWidgetDelete) })
                
                Spacer()
                
                // MARK: 닫기버튼
                Button {
                    coreData.loadData()
                    target.fetchAllWidgets()
                    target.showDetail.toggle()
                } label: {
                    Image(systemSymbol: .xmark)
                        .font(.custom(.robotoMedium, size: 18))
                        .foregroundColor(AppColor.Label.second)

                }
            }
            .padding(.horizontal, 8)
        }
    }

}
//
//struct EditWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            DetailWidgetView(selectedWidget: DeepLink.example, target: MainWidgetViewModel())
//        }
//    }
//}
