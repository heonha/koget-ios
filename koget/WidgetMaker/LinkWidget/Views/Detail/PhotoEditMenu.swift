//
//  PhotoEditMenu.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/29.
//

import SwiftUI

struct PhotoEditMenu: View {
    
    @Binding var isEditingMode: Bool
    @Binding var isPhotoViewPresent: Bool
    @StateObject var viewModel: MakeWidgetViewModel
    
    var body: some View {
        Menu {
            // 앱 선택 이미지
            if isEditingMode {
                Button(action: {
                    isPhotoViewPresent.toggle()
                }) {
                    Label("사진 바꾸기", systemImage: "photo")
                }
            }
            
        } label: {
            Image(uiImage: viewModel.image ?? UIImage(named: "plus.circle")!)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
                .clipShape(Circle())
            
        }
        .sheet(isPresented: $isPhotoViewPresent) {
            PhotoPicker(widgetModel: viewModel)
        }
        .disabled(!isEditingMode)
    }
}


struct PhotoEditMenu_Previews: PreviewProvider {
    static var previews: some View {
        PhotoEditMenu(isEditingMode: .constant(false), isPhotoViewPresent: .constant(false), viewModel: MakeWidgetViewModel())
    }
}
