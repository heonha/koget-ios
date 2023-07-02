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
    @State private var slideAnimation: Animation = .spring(response: 0.5, dampingFraction: 1, blendDuration: 0.7)
    @State private var showDetail = false
    
    init(widget: DeepLink) {
        self.widget = widget
    }
    
    private func slideButton(_ type: SlideableButtonType, action: @escaping () -> Void) -> some View {
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
    
    var body: some View {
        ZStack {
            mainBody
                .offset(x: offsetX)

            HStack {
                Spacer()
                
                slideButton(.edit) {
                    print("EDIT SHEET PRESENT")
                    showDetail.toggle()
                }

                slideButton(.delete) {
                    print("DELETE SHEET PRESENT")
                }

            }
            .offset(x: offsetX + 140)

        }
        .frame(height: 58)
        .sheet(isPresented: $showDetail) {
            DetailWidgetView(selectedWidget: widget, showDetail: $showDetail)
        }

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
                            
                            Text("100")
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
        .gesture(
            LongPressGesture()
                .onChanged { Bool in
                    print("DEBUG: LongPress On Changed!")
                }
                .onEnded { value in
                    print("DEBUG: LongPress Ended")
                    HapticManager.shared.triggerHapticFeedback(style: .heavy)
//
//                    if let url = widget.url, let id = widget.id {
//                        viewModel.urlOpenedInApp(urlString: "\(WidgetConstant.mainURL)\(url)\(WidgetConstant.idSeparator)\(id.uuidString)")
//                    }
                }
        )
//        .animation(, value: offsetX)
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

