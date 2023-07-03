//
//  WidgetButton.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/15.
//

import SwiftUI
import CoreData

struct WidgetGridCell: View {
    
    var widget: DeepLink
    
    private var cellWidth: CGFloat = Constants.deviceSize.width / 4.3
    private var imageSize: CGSize = .zero
    private var textSize: CGSize = .zero
    
    private var name: String = ""
    private var url: String = ""
    private var image: UIImage = UIImage()
    private let titleColor: Color = AppColor.Label.first
    @State var showDeleteAlert = false
    @EnvironmentObject private var coreData: WidgetCoreData
    @EnvironmentObject var viewModel: HomeWidgetViewModel

    @Environment(\.dismiss) private var dismiss

    init(widget: DeepLink) {
        self.widget = widget
        name = widget.name ?? ""
        url = widget.url ?? ""
        let imageData = widget.image ?? Data()
        image = UIImage(data: imageData) ?? CommonImages.emptyIcon
        imageSize = CGSize(width: cellWidth * 0.63, height: cellWidth * 0.63)
        textSize = CGSize(width: cellWidth, height: cellWidth * 0.40)
    }

    var body: some View {
        Menu {
            widgetMenu()
        } label: {
            widgetIcon()
        }
    }
    
    private func widgetIcon() -> some View {
        VStack(spacing: 2) {
            //MARK: 위젯 아이콘
            ZStack {
                // 아이콘배경
                Color.clear
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.25), radius: 0.5, x: 0.5, y: 0.5)
                    .shadow(color: .black.opacity(0.25), radius: 0.5, x: -0.5, y: -0.5)

                Image
                    .uiImage(image.addClearBackground(sourceResizeRatio: 1.0) ?? CommonImages.emptyIcon)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            }
            .frame(width: imageSize.width, height: imageSize.height)

            //MARK: 위젯 이름
            Text(name)
                .font(.custom(.robotoMedium, size: 13))
                .foregroundColor(titleColor)
                .frame(width: textSize.width, height: textSize.height)
                .lineLimit(2)
                .frame(height: 30)
            
        }
        .padding()
        .frame(width: cellWidth, height: cellWidth * 1.15)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func widgetMenu() -> some View {
        Group {
            Button {
                if let url = widget.url, let id = widget.id {
                    viewModel.urlOpenedInApp(urlString: "\(WidgetConstant.mainURL)\(url)\(WidgetConstant.idSeparator)\(id.uuidString)")
                }
            } label: {
                Label("실행", systemImage: "arrow.up.left.square")
            }
            Button {
                viewModel.targetWidget = self.widget
                viewModel.showDetail.toggle()
            } label: {
                Label("편집", systemImage: "slider.horizontal.3")
            }
            Button {
                showDeleteAlert.toggle()
            } label: {
                Label("삭제", systemImage: "xmark.bin.circle.fill")
                    .foregroundColor(.red)
            }
            .alert("\(widget.name ?? "알수없는 위젯")", isPresented: $showDeleteAlert, actions: {
                Button(S.Button.delete, role: .destructive) {
                    coreData.deleteData(data: widget)
                    dismiss()
                    viewModel.displayAlertView()
                    showDeleteAlert = false
                }
                Button(S.Button.cancel, role: .cancel) {
                    showDeleteAlert = false
                }
            }, message: {
                Text(S.Alert.Message.checkWidgetDelete)
            })
            
        }
    }

}

struct WidgetButton_Previews: PreviewProvider {
    static var previews: some View {
        WidgetGridCell(widget: DeepLink.example)
    }
}
