//
//  ImageButton.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2023/01/01.
//

import SwiftUI

struct ImageMenuButton: View {
    
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
                    Label("사진 변경", systemImage: "photo")
                }
                
            } label: {
                
                switch widgetType {
                case .none:
                    ZStack {
                        Text("위젯 타입을 선택하세요.")
                    }
                case .image:
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding()
                    } else {
                        ZStack {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 100))
                                .foregroundStyle(LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .clipShape(Circle())
                        }
                    }
                }
                
            }.sheet(isPresented: $isAppPickerPresent) {
                appPicker
            }
            .sheet(isPresented: $isPhotoPickerPresent) {
                PhotoPicker(widgetModel: viewModel)
            }
        }
    }
}

struct ImageButton_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MakeWidgetViewModel()
        ImageMenuButton(viewModel: viewModel, appPicker: .constant(WidgetAssetList(viewModel: viewModel)), widgetType: .constant(.image))
    }
}
