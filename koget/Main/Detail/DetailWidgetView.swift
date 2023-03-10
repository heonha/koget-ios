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
                ZStack {
                    // 제목
                    AppColor.Background.third
                    HStack(alignment: .center) {
                        Text(viewModel.name)
                            .frame(maxWidth: .infinity, maxHeight: 45, alignment: .center)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColor.Label.first)
                            .padding(.horizontal, 35)
                    }

                    // MARK: - 상단 바
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
                .frame(height: 45)

                Spacer()

                // MARK: - 아이콘
                PhotoEditMenu(isEditingMode: $viewModel.isEditingMode,
                              viewModel: viewModel)
                .shadow(radius: 1, x: 0.2, y: 0.3)
                .padding(4)

                Spacer()

                // MARK: - 이름, URL
                VStack(spacing: 16) {
                    EditTextField(systemSymbol: .tag, placeHolder: "위젯 이름", viewModel: viewModel, text: $viewModel.name)
                    
                    EditTextField(systemSymbol: .link, placeHolder: "예시: youtube://", viewModel: viewModel, text: $viewModel.url)
                    // MARK: - 투명도
                    HStack(alignment: .center) {
                        Image(systemSymbol: .circleDashed)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColor.Label.second)
                            .padding(.trailing, 8)

                        Button {
                            isPresentQustionmark.toggle()
                        } label: {
                            Image(systemSymbol: .questionmarkCircle)
                                .foregroundColor(AppColor.Label.third)
                        }
                        .overlay(
                            ZStack(content: {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColor.Background.third)
                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)

                                Text("잠금화면 위젯의 불투명도입니다.")
                                    .font(.custom(CustomFont.NotoSansKR.light, size: 13))
                                    .foregroundColor(AppColor.Label.first)
                            })
                            .frame(width: deviceSize.width * 0.5, height: 30)
                            .offset(x: 80, y: -40)
                            .opacity( isPresentQustionmark ? 1.0 : 0.0 )
                            .animation(.linear(duration: 0.2), value: isPresentQustionmark)
                        )
                        Spacer()

                        ZStack {
                            Text("\(Int(viewModel.opacityValue * 100))%")
                                .font(.custom(viewModel.isOpacitySliderEditing ? CustomFont.NotoSansKR.medium : CustomFont.NotoSansKR.bold, size: 18))
                                .foregroundColor(viewModel.isOpacitySliderEditing ? AppColor.kogetBlue : AppColor.Label.first)
                        }

                        Spacer()
                    }
                    .frame(height: 40)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.isEditingMode ? AppColor.Background.third : AppColor.Background.second)
                        OpacitySlider(viewModel: viewModel, widthRatio: 0.3)
                            .offset(x: 0, y: viewModel.isEditingMode ? 0 : -15)
                            .opacity(viewModel.isEditingMode ? 1 : 0)
                    }
                    .frame(height: 40)

                }
                .padding(.horizontal)

                Spacer()
                toggleButton
                // 닫기 버튼
                DetailWidgetButton(text: "닫기", buttonColor: AppColor.Background.third.opacity(0.8)) {
                    dismiss()
                }

                Text("편집 후 실제 위젯에 반영되기까지 약 15분 이내의 시간이 소요됩니다.")
                    .font(.custom(CustomFont.NotoSansKR.regular, size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .frame(height: 45)
                    .padding(.vertical)
            }

        }.onAppear {
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
        .frame(width: size.width, height: size.height)
        .background(Color.init(uiColor: .clear))
        .cornerRadius(10)
        .shadow(radius: 1)
        .onTapGesture {
            isPresentQustionmark = false
        }
        .animation(.linear(duration: 0.3), value: viewModel.isEditingMode)
        .onDisappear {
            coreData.loadData()
        }

    }
    var toggleButton: some View {
        Button {
            viewModel.editingAction(widget: selectedWidget)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(viewModel.isEditingMode ? AppColor.kogetBlue : AppColor.Background.third)
                Text(viewModel.isEditingMode ? "편집 완료" : "위젯 편집")
                    .foregroundColor(viewModel.isEditingMode
                                     ? (constant.isDarkMode ? AppColor.Label.first : AppColor.Background.first)
                                     : AppColor.Label.first )
                    .fontWeight(.bold)
                    .font(.system(size: 17))
            }
        }
        .cornerRadius(8)
        .frame(width: 200, height: 35)
    }
}

struct EditWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailWidgetView(selectedWidget: DeepLink.example)
        }
    }
}
