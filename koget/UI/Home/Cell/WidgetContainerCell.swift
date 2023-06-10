//
//  WidgetContainerCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
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
    
    @State var isPresentDetailView = false
    @State var isDelete: Bool = false
    @State var imageSize: CGSize = .zero
    @State var textSize: CGSize = .zero
    
    @ObservedObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    
    init(widget: DeepLink, viewModel: MainWidgetViewModel, type: WidgetCellType) {
        self.widget = widget
        self.type = type
        self.viewModel = viewModel
        self.cellSize = (grid: Constants.deviceSize.width / 4.3, list: 50)
        self.imageSize = CGSize(width: cellSize.grid * 0.63, height: cellSize.grid * 0.63)
        self.textSize = CGSize(width: cellSize.grid, height: cellSize.grid * 0.40)
    }
    
    var body: some View {
        if let imageData = widget.image,
           let widgetImage = UIImage(data: imageData),
           let name = widget.name,
           let url = widget.url {

            ZStack {
                switch type {
                case .grid:
                    gridMenu(name: name,
                             url: url,
                             widgetImage: widgetImage,
                             cellWidth: cellSize.grid,
                             viewModel: viewModel)
                case .list:
                    WidgetListCell(name: name,
                                   url: url,
                                   widgetImage: widgetImage,
                                   cellWidth: cellSize.list,
                                   runCount: Int(widget.runCount),
                                   cellHeight: cellSize.list, viewModel: viewModel)
                }
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                swipeRunButton
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                swipeDeleteButton

                swipeEditButton
            }
            .alert("\(widget.name ?? S.unknown)", isPresented: $isDelete, actions: {
                Button(S.Button.delete, role: .destructive) {
                    coreData.deleteData(data: widget)
                    viewModel.setAlertView()
                    viewModel.displayAlertView()
                    isDelete = false
                }
                Button(S.Button.cancel, role: .cancel) {
                    isDelete = false
                }
            }, message: {
                Text(S.Alert.Message.checkWidgetDelete)
            })
        }
    }

    private var swipeRunButton: some View {
        Button {
            if let url = widget.url, let id = widget.id {
                viewModel.urlOpenedInApp(urlString: "\(WidgetConstant.mainURL)\(url)\(WidgetConstant.idSeparator)\(id.uuidString)")
            }
        } label: {
            Label(S.Button.run, systemSymbol: .arrowUpLeftSquareFill)
        }
        .tint(Color.init(uiColor: .systemGreen))
    }

    private var swipeDeleteButton: some View {
        Button {
            isDelete.toggle()
        } label: {
            Label(S.Button.delete, systemSymbol: .trashFill)
        }
        .tint(Color.init(uiColor: .systemRed))
    }

    private var swipeEditButton: some View {
        Button {
            self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                DetailWidgetView(selectedWidget: widget)
            })
        } label: {
            Label(S.Button.edit, systemSymbol: .sliderHorizontal3)
        }
        .tint(AppColor.kogetBlue)
    }

    private func gridMenu(name: String, url: String, widgetImage: UIImage,
                          cellWidth: CGFloat, viewModel: MainWidgetViewModel) -> some View {
        Menu {
            Button {
                if let url = widget.url, let id = widget.id {
                    viewModel.urlOpenedInApp(urlString: "\(WidgetConstant.mainURL)\(url)\(WidgetConstant.idSeparator)\(id.uuidString)")
                }
            } label: {
                Label(S.Button.run, systemSymbol: .arrowUpLeftSquareFill)
            }
            Button {
                self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                    DetailWidgetView(selectedWidget: widget)
                })
            } label: {
                Label(S.Button.edit, systemSymbol: .sliderHorizontal3)
            }
            Button(role: .destructive) {
                isDelete.toggle()
            } label: {
                Label(S.Button.delete, systemSymbol: .trashFill)
            }
        } label: {
            WidgetGridCell(name: name, url: url, widgetImage: widgetImage,
                           cellWidth: cellSize.grid, viewModel: viewModel)

        }
        .alert("\(widget.name ?? S.unknown)", isPresented: $isDelete, actions: {
            Button(S.Button.delete, role: .destructive) {
                coreData.deleteData(data: widget)
                dismiss()
                viewModel.displayAlertView()
                isDelete = false
            }
            Button(S.Button.cancel, role: .cancel) {
                isDelete = false
            }
        }, message: {
            Text(S.Alert.Message.checkWidgetDelete)
        })
        .sheet(isPresented: $isPresentDetailView, content: {
            DetailWidgetView(selectedWidget: widget)
        })
    }

}

#if DEBUG
struct DeepLinkWidgetIconView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // 배경
            AppColor.Background.second
                .ignoresSafeArea()
            
            // 컨텐츠
            WidgetContainerCell(widget: DeepLink.example, viewModel: MainWidgetViewModel(), type: .list)
                .padding(.horizontal)
        }
        .environmentObject(StorageProvider())
    }
}
#endif
