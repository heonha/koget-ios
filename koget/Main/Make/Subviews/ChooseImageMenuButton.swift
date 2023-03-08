//
//  ImageButton.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2023/01/01.
//

import SwiftUI

struct ChooseImageMenuButton: View {
    
    @ObservedObject var viewModel: MakeWidgetViewModel
    @Binding var appPicker: WidgetAssetList?
    @State var isAppPickerPresent: Bool = false
    @State var isPhotoPickerPresent: Bool = false
    @Binding var widgetType: WidgetType

    var body: some View {
        ZStack {
            Menu {
                Button(action: {
                    isPhotoPickerPresent.toggle()
                }) {
                    Label("이미지 선택", systemImage: "photo")
                }
                
            } label: {
                
                switch widgetType {
                case .image:
                    if let image = viewModel.image {
                        ZStack {
                            AppColor.Background.first
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.3, y: 0.3)
                        .shadow(color: .black.opacity(0.1), radius: 0.5, x: -0.3, y: -0.3)
                    } else {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .opacity(Constants.shared.isDarkMode ? 0.3 : 1.0)
                            Image("Koget")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .opacity(Constants.shared.isDarkMode ? 0.3 : 0.5)
                            Text("이미지\n선택")
                                .foregroundColor(AppColor.Label.second)
                                .shadow(radius: 1)
                                .font(.system(size: 16, weight: .bold))
                        }
                        .frame(width: 100, height: 100)
                    }
                }
            }.sheet(isPresented: $isAppPickerPresent) {
                appPicker
            }
            .sheet(isPresented: $isPhotoPickerPresent) {
                PhotoPicker(makeModel: viewModel)
            }
        }
    }
}

struct ImageButton_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MakeWidgetViewModel()
        ChooseImageMenuButton(viewModel: viewModel, appPicker: .constant(WidgetAssetList(viewModel: viewModel)), widgetType: .constant(.image))
    }
}
