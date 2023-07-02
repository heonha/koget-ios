//
//  SlideableWidgetCell.swift
//  koget
//
//  Created by HeonJin Ha on 2023/06/27.
//

import SwiftUI

struct SlideableWidgetCell: View {
    
    @State private var widget: DeepLink
    @State private var offsetX: CGFloat = .zero
    @State private var widgetIcon: UIImage = UIImage()
    @State private var slideAnimation: Animation = .spring(response: 0.5,
                                                           dampingFraction: 1,
                                                           blendDuration: 0.7)
//    @State private var showDetail = false
    @EnvironmentObject private var viewModel: HomeWidgetViewModel
    
    init(widget: DeepLink) {
        self.widget = widget
    }
    
    
    var body: some View {
        ZStack {
            mainBody
                .offset(x: offsetX)

            slideIcons

        }
        .frame(height: 58)

    }
    
    var slideIcons: some View {
        HStack {
            Spacer()
            
            slideButton(.edit) {
                viewModel.targetWidget = widget
                withAnimation(slideAnimation) {
                    offsetX = .zero
                }
                viewModel.showDetail = true
            }

            slideButton(.delete) {
                withAnimation(slideAnimation) {
                    offsetX = .zero
                }
            }

        }
        .offset(x: offsetX + 140)
    }
    
    var mainBody: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "F9F9F9"))

                HStack {
                    Image(uiImage: $widgetIcon.wrappedValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.18), radius: 4, x: 0.3, y: 0.3)
                        .padding(.leading)
                        .onAppear {
                            setIcon()
                        }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(widget.name ?? "")
                            .font(.custom(.robotoBold, size: 15))
                        
                        Text(widget.type ?? "앱")
                            .font(.custom(.robotoMedium, size: 13))
                            .foregroundColor(Color.init(hex: "85858B"))
                    }
                    
                    Spacer()
                    
                    Capsule()
                        .fill(AppColor.toggleOffBGColor)
                        .frame(width: 80 ,height: 24)
                        .overlay {
                            HStack {
                                Image(systemName: "personalhotspot")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.green)
                                
                                Text("\(widget.runCount)")
                                    .font(.custom(.robotoMedium, size: 14))
                            }
                            
                        }
                        .padding(.trailing)
                    
                }
            }
            .padding(.horizontal, 15)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.20), radius: 2, x: 0.3, y: 0.3)
            .gesture(
                DragGesture(minimumDistance: 30)
                    .onChanged { value in
                        withAnimation(slideAnimation) {
                            offsetX = value.translation.width
                        }
                    }
                    .onEnded { value in
                        withAnimation(slideAnimation) {
                            if value.translation.width < -70 {
                                offsetX = -150
                            } else {
                                offsetX = .zero
                            }
                        }
                    }
            )
            .onTapGesture {
                withAnimation(slideAnimation) {
                    offsetX = .zero // offsetX 값을 초기화
                }
            }
    }
        
    private func slideButton(_ type: SlideableButtonType,
                             action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(type.getBackgroundColor())
 

                Image(systemName: type.getSymbolName())
                    .font(.system(size: 27))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 60)
    }
    
    private func setIcon() {
        if let data = widget.image, let image = UIImage(data: data) {
            self.widgetIcon = image
        } else {
            self.widgetIcon = UIImage(systemName: "person")!
        }
    }
}

#if DEBUG
struct ListCell_Previews: PreviewProvider {
    static var previews: some View {
        SlideableWidgetCell(widget: DeepLink.example)
    }
}
#endif
