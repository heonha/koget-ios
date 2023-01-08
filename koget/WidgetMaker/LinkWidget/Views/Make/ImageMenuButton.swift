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
    
    var body: some View {
        ZStack {
            Menu {
                Button(action: {
                    isAppPickerPresent.toggle()
                }) {
                    Label("앱 가져오기", systemImage: "plus.circle.fill")
                }
                Button(action: {
                    isPhotoPickerPresent.toggle()
                }) {
                    Label("사진 변경", systemImage: "photo")
                }
            } label: {
                
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding()
                } else {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 100))
                        .foregroundColor(.init(uiColor: .secondaryLabel))
                        .clipShape(Circle())
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
        ImageMenuButton(viewModel: viewModel, appPicker: .constant(WidgetAssetList(viewModel: viewModel)))
    }
}
