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

    @ObservedObject var constant = Constants.shared
    @ObservedObject var coreData = WidgetCoreData.shared
    @StateObject var viewModel = DetailWidgetViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            if constant.isDarkMode {
                AppColor.Background.second
            } else {
                AppColor.Background.second
            }
            VStack {
                titleBar
                    .frame(height: 45)

                Spacer()

                // MARK: - 아이콘
                HStack(spacing: 8) {
                    PhotoEditMenu(isEditingMode: $viewModel.isEditingMode,
                                  viewModel: viewModel)
                    // 투명도 Preview
                }
                .shadow(radius: 1, x: 0.2, y: 0.3)
                .padding(4)

                Spacer()

                // MARK: - 이름, URL
                VStack(spacing: 12) {

                    EditTextField(systemSymbol: .tag,
                                  placeHolder: "위젯 이름",
                                  viewModel: viewModel,
                                  text: $viewModel.name)

                    EditTextField(systemSymbol: .link,
                                  placeHolder: "예시: youtube://",
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
                TextButton(title: "닫기", backgroundColor: AppColor.Fill.third, size: (width: 200, height: 40)) {
                    dismiss()
                }

                Text("편집 후 실제 위젯에 반영되기까지 약 15분 이내의 시간이 소요됩니다. (iOS 위젯 업데이트시간)")
                    .font(.custom(CustomFont.NotoSansKR.regular, size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .frame(height: 45)
                    .padding()
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
        .onDisappear {
            coreData.loadData()
        }

    }

    // MARK: - Setup
    // onAppear
    private func setupView() {
        viewModel.name = selectedWidget.name ?? "unknown"
        viewModel.url = selectedWidget.url ?? "unknown"
        viewModel.image = UIImage(data: selectedWidget.image!)!
        if selectedWidget.opacity == nil {
            selectedWidget.opacity = 1.0
            viewModel.opacityValue = 1.0
            coreData.saveData()
        } else {
            viewModel.opacityValue = selectedWidget.opacity as? Double ?? 1.0
        }
    }

    // MARK: - Views
    var titleBar: some View {
        ZStack {
            // TitleBar
            AppColor.Fill.first
            HStack(alignment: .center) {
                Text(viewModel.name)
                    .frame(maxWidth: .infinity, maxHeight: 45, alignment: .center)
                    .font(.system(size: 20, weight: .bold))
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
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColor.kogetRed)
                        .fontWeight(.bold)
                }
                .alert("삭제 확인", isPresented: $isDeleteAlertPresent, actions: {
                    Button("삭제", role: .destructive) {
                        WidgetCoreData.shared.deleteData(data: selectedWidget)
                        self.dismiss()
                    }
                    Button("취소", role: .cancel) {}
                }, message: { Text("정말 삭제 하시겠습니까?") })
                Spacer()
                // MARK: 닫기버튼
                Button {
                    dismiss()
                } label: {
                    Image(systemSymbol: .xmark)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColor.Label.second)

                }
            }
            .padding(.horizontal, 8)
        }
    }

}

struct EditWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailWidgetView(selectedWidget: DeepLink.example)
        }
    }
}
