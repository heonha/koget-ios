//
//  PhotoEditMenu.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/29.
//

import SwiftUI
import SFSafeSymbols

struct PhotoEditMenu: View {
    
    @Binding var isEditingMode: Bool
    @Binding var isPhotoViewPresent: Bool
    @StateObject var viewModel: DetailWidgetViewModel
    
    var body: some View {

        Menu {
            Button(action: {
                isPhotoViewPresent.toggle()
            }) {
                Label("이미지 선택", systemSymbol: .photo)
            }
        } label: {
            ZStack {
                Color.white

                Image(uiImage: viewModel.image ?? UIImage(named: "plus.circle")!)
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 90, height: 90)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.3, y: 0.3)
            .shadow(color: .black.opacity(0.1), radius: 0.5, x: -0.3, y: -0.3)
            .shadow(color: isEditingMode ? .blue : .clear, radius: 3)
        }
        .sheet(isPresented: $isPhotoViewPresent) {
            PhotoPicker(detailModel: viewModel)
        }
        .disabled(!isEditingMode)
    }
}

struct PhotoEditMenu_Previews: PreviewProvider {
    static var previews: some View {
        PhotoEditMenu(isEditingMode: .constant(false), isPhotoViewPresent: .constant(false), viewModel: DetailWidgetViewModel())
    }
}
