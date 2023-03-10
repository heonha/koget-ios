//
//  PhotoEditMenu.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/29.
//

import SwiftUI
import SFSafeSymbols

protocol VMPhotoEditProtocol: ObservableObject {
    var image: UIImage? { get set }
    var opacityValue: Double {get set}
    var isOpacitySliderEditing: Bool { get set }
}

struct PhotoEditMenu<V: VMPhotoEditProtocol>: View {
    
    @Binding var isEditingMode: Bool
    @State var isPhotoViewPresent: Bool = false
    @StateObject var viewModel: V

    @ObservedObject var constant = Constants.shared
    
    var body: some View {

        Menu {
            Button(action: {
                isPhotoViewPresent.toggle()
            }) {
                Label("이미지 선택", systemSymbol: .photo)
            }
        } label: {
            ZStack {
                if viewModel.isOpacitySliderEditing {
                    Color.clear
                } else {
                    Color.white
                }

                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .opacity(constant.isDarkMode ? 0.3 : 1.0)
                        Image("Koget")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .opacity(constant.isDarkMode ? 0.3 : 0.5)
                        Text("이미지\n선택")
                            .foregroundColor(AppColor.Label.second)
                            .shadow(radius: 1)
                            .font(.system(size: 16, weight: .bold))
                    }
                }

            }
            .clipShape(Circle())
            .grayscale(viewModel.isOpacitySliderEditing ? 1 : 0)
            .opacity(viewModel.isOpacitySliderEditing ? viewModel.opacityValue : 1)
            .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.3, y: 0.3)
            .shadow(color: .black.opacity(0.1), radius: 0.5, x: -0.3, y: -0.3)
        }
        .frame(width: 90, height: 90)
        .sheet(isPresented: $isPhotoViewPresent) {
            PhotoPicker(viewModel: viewModel)
        }
        .disabled(!isEditingMode)
    }
}
// 
// struct PhotoEditMenu_Previews: PreviewProvider {
//     static var previews: some View {
//         PhotoEditMenu(isEditingMode: .constant(false), isPhotoViewPresent: .constant(false), viewModel: DetailWidgetViewModel())
//     }
// }
