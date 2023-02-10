//
//  WidgetIconCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct WidgetIconCell: View {
    
    var widget: DeepLink
    let titleColor: Color = AppColors.label
    var cellWidth: CGFloat
    
    var imageSize: CGSize = .zero
    var textSize: CGSize = .zero
    
    
    
    init(widget: DeepLink, cellWidth: CGFloat) {
        self.widget = widget
        self.cellWidth = cellWidth
        self.imageSize = CGSize(width: cellWidth * 0.63, height: cellWidth * 0.63)
        self.textSize = CGSize(width: cellWidth, height: cellWidth * 0.40)
    }
    
    
    @StateObject var viewModel = MainWidgetViewModel.shared
    @ObservedObject var coredata = WidgetCoreData.shared

    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    
    var body: some View {
        
        // 버튼
        Button {
            if viewModel.isEditingMode {
                self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                    DetailWidgetView(selectedWidget: widget)
                })
            } else {
                if let url = widget.url {
                    viewModel.openURL(urlString: url)
                } else {
                    print("CoreData url Error")
                }
            }
            
        } label: {
            
            if let data = widget.image {
                if let widgetImage = UIImage(data: data) {
                    VStack(spacing: 2) {
                        Spacer()
                        
                        VStack {
                            ZStack {
                                Color.white
                                    .clipShape(Circle())
                                    .shadow(radius: 1, x: 2, y: 2)
                                Image(uiImage: widgetImage)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                if viewModel.isEditingMode {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .foregroundStyle(.white)
                                                    .frame(width: 13, height: 13)
                                                Image(systemName: "ellipsis.circle.fill")
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(.init(uiColor: .darkGray))
                                                    .clipShape(Circle())
                                                    .shadow(radius: 0.3, x: 0.5, y: 0.5)
                                            }
                                        }
                                    }
                                    .padding([.bottom, .trailing], -4)
                                }
        
                            }
                            .frame(width: imageSize.width, height: imageSize.height)
                            .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.3, y: 0.3)
                            .shadow(color: .black.opacity(0.1), radius: 0.5, x: -0.3, y: -0.3)
                        }
                        
                        Text(widget.name ?? "알수없는 이름")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(titleColor)
                            .shadow(radius: 0.5, x: 0.5, y: 0.5)
                            .frame(width: textSize.width, height: textSize.height)
                            .lineLimit(2)
                        
                        Spacer()
                    }
                    .frame(width: cellWidth, height: cellWidth * 1.1)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                }
            }
        }
    }
}


struct DeepLinkWidgetIconView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            // 배경
            AppColors.secondaryBackgroundColor
                .ignoresSafeArea()
            
            // 컨텐츠
            WidgetIconCell(widget: DeepLink.example, cellWidth: DEVICE_SIZE.width / 5)
        }
        .environmentObject(StorageProvider())
    }
}


