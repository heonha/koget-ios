//
//  SlideableWidgetCell.swift
//  koget
//
//  Created by HeonJin Ha on 2023/06/27.
//

import SwiftUI

struct SlideableWidgetCell: View {
    
    @State var widget: DeepLink
    @State private var showDeleteAlert = false
    
    @EnvironmentObject private var viewModel: HomeWidgetViewModel
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            mainBody

        }
        .frame(height: 58)
        .swipeActions {
            slideButton(.delete) {
                showDeleteAlert.toggle()
            }
        }
        .swipeActions {
            slideButton(.edit) {
                viewModel.targetWidget = widget
                viewModel.showDetail = true
            }
        }
        .alert("\(widget.name ?? "알수없는 위젯")",
               isPresented: $showDeleteAlert,
               actions: {
            Button("삭제", role: .destructive) {
                viewModel.deleteWidget(self.widget)
                showDeleteAlert = false
                dismiss()
            }
            
            Button("취소", role: .cancel) {
                showDeleteAlert = false
            }
        }, message: {
            Text("이 위젯을 삭제 할까요?")
        })

    }
    
    var mainBody: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.regularMaterial)

                HStack {
                        Image(uiImage: UIImage(data: widget.image!)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.18), radius: 4, x: 0.3, y: 0.3)
                            .padding(.leading)
  
                    VStack(alignment: .leading, spacing: 4) {
                        Text(widget.name ?? "")
                            .font(.custom(.robotoBold, size: 15))
                        
                        Text(widget.type ?? "앱")
                            .font(.custom(.robotoMedium, size: 13))
                            .foregroundColor(Color.init(hex: "85858B"))
                    }
                    
                    Spacer()
                    
                    Capsule()
                        .fill(.ultraThinMaterial)
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
    }
        
    private func slideButton(_ type: SlideableButtonType,
                             action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: type.getSymbolName())
                .font(.system(size: 27))
                .foregroundColor(.init(uiColor: .systemBackground))
        }
        .tint(type.getBackgroundColor())
        .frame(width: 60)
    }

}

#if DEBUG
struct ListCell_Previews: PreviewProvider {
    static var previews: some View {
        SlideableWidgetCell(widget: DeepLink.example)
    }
}
#endif
