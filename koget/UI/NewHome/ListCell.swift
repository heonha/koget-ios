//
//  ListCell.swift
//  koget
//
//  Created by HeonJin Ha on 2023/06/27.
//

import SwiftUI

struct ListCell: View {
    
    @State private var widget: DeepLink
    @State private var offsetX: CGFloat = .zero
    @State private var widgetIcon: UIImage = UIImage()
    
    init(widget: DeepLink) {
        self.widget = widget
    }
    
    private func setIcon() {
        if let data = widget.image, let image = UIImage(data: data) {
            self.widgetIcon = image
        } else {
            self.widgetIcon = UIImage(systemName: "person")!
        }
    }
    
    var body: some View {
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
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.20), radius: 2, x: 0.3, y: 0.3)
        .frame(height: 58)
        .padding(.horizontal, 2)
        .offset(x: offsetX)
        .gesture(
            DragGesture(minimumDistance: 30)
                .onChanged { value in
                    let changedOffset = value.translation.width
                    offsetX = changedOffset
                }
                .onEnded { value in
                    if value.translation.width < -70 {
                             offsetX = -150
                     } else {
                             offsetX = .zero
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
        .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0.7), value: offsetX)
    }
}

#if DEBUG
struct ListCell_Previews: PreviewProvider {
    static var previews: some View {
        ListCell(widget: DeepLink.example)
    }
}
#endif

