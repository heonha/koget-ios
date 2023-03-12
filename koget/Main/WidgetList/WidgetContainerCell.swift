//
//  WidgetContainerCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import SwiftEntryKit
import SFSafeSymbols

enum WidgetCellType {
    case grid
    case list
}

// list Cell 또는 Grid Cell을 포함하는 컨테이너
struct WidgetContainerCell: View {
    
    var widget: DeepLink
    var type: WidgetCellType
    var cellSize: (grid: CGFloat, list: CGFloat)

    @ObservedObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData
    @State var isPresentDetailView = false
    @State var isDelete: Bool = false

    lazy var imageSize = CGSize(width: cellSize.grid * 0.63, height: cellSize.grid * 0.63)
    lazy var textSize = CGSize(width: cellSize.grid, height: cellSize.grid * 0.40)

    @Environment(\.dismiss) var dismiss
    @Environment(\.viewController) var viewControllerHolder: UIViewController?

    init(widget: DeepLink, viewModel: MainWidgetViewModel, type: WidgetCellType) {
        self.widget = widget
        self.type = type
        self.viewModel = viewModel
        self.cellSize = (grid: deviceSize.width / 4.3, list: 50)
    }

    var body: some View {
        if let data = widget.image, let name = widget.name, let url = widget.url {
            if let widgetImage = UIImage(data: data) {

                Menu {
                    Button {
                        if let url = widget.url, let id = widget.id {
                            viewModel.maybeOpenedFromWidget(urlString: "\(schemeToAppLink)\(url)\(idSeparator)\(id.uuidString)")
                        }
                    } label: {
                        Label("실행하기", systemSymbol: .arrowUpLeftSquareFill)
                    }
                    Button {
                        self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                            DetailWidgetView(selectedWidget: widget)
                        })
                    } label: {
                        Label("편집", systemSymbol: .sliderHorizontal3)
                    }
                    Button(role: .destructive) {
                        isDelete.toggle()
                    } label: {
                        Label("삭제", systemSymbol: .trashFill)
                    }
                } label: {
                    if type == .grid {
                        WidgetGridCell(name: name, url: url, widgetImage: widgetImage,
                                     cellWidth: cellSize.grid, viewModel: viewModel)

                    } else {
                        WidgetListCell(name: name, url: url, widgetImage: widgetImage, cellWidth: cellSize.list, runCount: Int(widget.runCount), cellHeight: cellSize.list, viewModel: viewModel)
                    }
                }
                .alert("\(widget.name ?? "알수없음")", isPresented: $isDelete, actions: {
                    Button("삭제", role: .destructive) {
                        coreData.deleteData(data: widget)
                        dismiss()
                        viewModel.displayToast()
                        isDelete = false
                    }
                    Button("취소", role: .cancel) {
                        isDelete = false
                    }
                }, message: {Text("이 위젯을 삭제 할까요?")})
                .sheet(isPresented: $isPresentDetailView, content: {
                    DetailWidgetView(selectedWidget: widget)
                })
            }
        }
    }

}

struct DeepLinkWidgetIconView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // 배경
            AppColor.Background.second
                .ignoresSafeArea()
            
            // 컨텐츠
            WidgetContainerCell(widget: DeepLink.example, viewModel: MainWidgetViewModel.shared, type: .list)
                .padding(.horizontal)
        }
        .environmentObject(StorageProvider())
    }
}
