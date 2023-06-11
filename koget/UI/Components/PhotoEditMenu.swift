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
    @State var isIconViewPresent: Bool = false

    @ObservedObject var viewModel: V
    @ObservedObject var constant = AppStateConstant.shared

    let selectImageLabel = S.PhotoEditMenu.selectWidget
    
    var body: some View {

        HStack(spacing: 16) {

            Menu {

                Button {
                    isIconViewPresent.toggle()
                } label: {
                    Label("아이콘 선택", systemImage: "square.grid.3x3.topleft.filled")
                }

                Button {
                    isPhotoViewPresent.toggle()
                } label: {
                    Label("앨범에서 가져오기", systemImage: "photo")
                }

            } label: {
                imageLabel()
            }
            .frame(width: 90, height: 90)
            .sheet(isPresented: $isPhotoViewPresent) {
                PhotoPicker(viewModel: viewModel)
            }
            .sheet(isPresented: $isIconViewPresent) {
                IconGridView(parentViewModel: viewModel)
            }
            .disabled(!isEditingMode)

            opacityPreview
        }
        .animation(.linear(duration: 0.2), value: viewModel.isOpacitySliderEditing)

    }

    private var opacityPreview: some View {
        Group {
            if viewModel.isOpacitySliderEditing {
                if let image = viewModel.image {
                    ZStack {
                        Image
                            .uiImage(image)
                            .resizable()
                            .scaledToFit()
                            .grayscale(0.99)
                    }
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .opacity(viewModel.opacityValue * 0.7)
                }
            }
        }
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

    private func imageLabel() -> some View {
        ZStack {
            if viewModel.isOpacitySliderEditing {
                Color.clear
            } else {
                AppColor.Background.first
            }

            if let image = viewModel.image {
                Image
                    .uiImage(image)
                    .resizable()
                    .scaledToFit()
                    .background(AppColor.Background.third)

            } else {
                ZStack {
                    Circle()
                        .fill(constant.isDarkMode ? .black : .white)
                        .opacity(constant.isDarkMode ? 0.3 : 1.0)
                    Image("plus.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.init(uiColor: .secondaryLabel))
                        .shadow(radius: 1)
                        .clipShape(Circle())
                        .opacity(constant.isDarkMode ? 0.4 : 0.7)
                    Text(selectImageLabel)
                        .foregroundColor(AppColor.Label.second)
                        .font(.custom(.robotoBold, size: 16))
                }
            }

        }
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.3, y: 0.3)
        .shadow(color: .black.opacity(0.1), radius: 0.5, x: -0.3, y: -0.3)
    }
}

#if DEBUG
struct PhotoEditMenu_Previews: PreviewProvider {
    static var previews: some View {
        PhotoEditMenu(isEditingMode: .constant(true), viewModel: MakeWidgetViewModel())
    }
}
#endif
