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
    var opacityValue: Double { get set }
    var isOpacitySliderEditing: Bool { get set }
}

struct PhotoEditMenu<V: VMPhotoEditProtocol>: View {
    
    @Binding var isEditingMode: Bool
    @State var isPhotoViewPresent: Bool = false
    @ObservedObject var viewModel: V
    @ObservedObject var constant = AppStateConstant.shared

    let selectImageLabel = S.PhotoEditMenu.selectWidget
    
    var body: some View {

        HStack(spacing: 16) {

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
                                .fill(constant.isDarkMode ? .black : .white)
                                .opacity(constant.isDarkMode ? 0.3 : 1.0)
                            Image("KogetClear")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .opacity(constant.isDarkMode ? 0.3 : 0.5)
                            Text(selectImageLabel)
                                .foregroundColor(AppColor.Label.second)
                                .shadow(radius: 1)
                                .font(.system(size: 16, weight: .bold))
                        }
                    }

                }
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.3, y: 0.3)
                .shadow(color: .black.opacity(0.1), radius: 0.5, x: -0.3, y: -0.3)
            }
            .frame(width: 90, height: 90)
            .sheet(isPresented: $isPhotoViewPresent) {
                PhotoPicker(viewModel: viewModel)
            }
            .disabled(!isEditingMode)
            if viewModel.isOpacitySliderEditing {
                if let image = viewModel.image {
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .grayscale(0.99)
                    }
                    .frame(width: 90, height: 90)
                    .opacity(viewModel.opacityValue * 0.7)
                    .clipShape(Circle())
                }
            }
        }
        .animation(.linear(duration: 0.2), value: viewModel.isOpacitySliderEditing)

    }

    func whiteRender(image: UIImage) -> UIImage {
        let size = image.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))

        image.draw(at: CGPoint.zero, blendMode: .normal, alpha: 1.0)

        if let maskedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return maskedImage
        } else {
            return UIImage()
        }
    }
}
// 
// struct PhotoEditMenu_Previews: PreviewProvider {
//     static var previews: some View {
//         PhotoEditMenu(isEditingMode: .constant(false), isPhotoViewPresent: .constant(false), viewModel: DetailWidgetViewModel())
//     }
// // }
// extension Image {
//     func whitescale(_ amount: Double) -> some View {
//         self.color(Color.white.opacity(amount))
//     }
// }
