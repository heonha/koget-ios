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


    }
}


struct PhotoEditMenu_Previews: PreviewProvider {
    static var previews: some View {
        PhotoEditMenu(isEditingMode: .constant(false), isPhotoViewPresent: .constant(false), viewModel: MakeWidgetViewModel())
    }
}
