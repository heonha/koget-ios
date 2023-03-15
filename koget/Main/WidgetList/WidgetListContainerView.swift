//
//  WidgetCollectionView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import QGrid
import SFSafeSymbols

// 위젯 Grid 및 List를 표현하는 컨테이너
struct WidgetListContainerView: View {
    
    let backgroundColor: Color = AppColor.Background.first
    @StateObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData
    @State var isDelete: Bool = false
    @Environment(\.viewController) var viewControllerHolder: UIViewController?

    //swipeuicell
    var availableWidth: CGFloat = 40
    @State var currentUserInteractionCellID: String?

    var body: some View {
        ZStack {
            backgroundColor
            if !$coreData.linkWidgets.wrappedValue.isEmpty {
                if viewModel.isGridView {
                    gridView
                } else {
                    listView
                }
                Spacer()
            } else {
                emptyGrid
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.isGridView)
        .cornerRadius(5)
    }
    // MARK: - Widget Views
    // Grid
    var gridView: some View {
        QGrid($coreData.linkWidgets.wrappedValue, columns: 3) { widget in
            WidgetContainerCell(widget: widget, viewModel: viewModel, type: .grid)
        }
    }

    // List
    var listView: some View {
        List {
            ForEach(coreData.linkWidgets) { widget in
                WidgetContainerCell(widget: widget, viewModel: viewModel, type: .list)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            isDelete.toggle()
                        } label: {
                            Label(S.Button.delete, systemSymbol: .trashFill)
                        }
                        .tint(Color.init(uiColor: .systemRed))
                        Button {
                            self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                                DetailWidgetView(selectedWidget: widget)
                            })
                        } label: {
                            Label(S.Button.edit, systemSymbol: .sliderHorizontal3)
                        }
                        .tint(AppColor.kogetBlue)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            if let url = widget.url, let id = widget.id {
                                viewModel.maybeOpenedFromWidget(urlString: "\(schemeToAppLink)\(url)\(idSeparator)\(id.uuidString)")
                            }
                        } label: {
                            Label(S.Button.run, systemSymbol: .arrowUpLeftSquareFill)
                        }
                        .tint(Color.green)
                    }
                    .alert("\(widget.name ?? S.unknown)", isPresented: $isDelete, actions: {
                        Button(S.Button.delete, role: .destructive) {
                            coreData.deleteData(data: widget)
                            viewModel.displayToast()
                            isDelete = false
                        }
                        Button(S.Button.cancel, role: .cancel) {
                            isDelete = false
                        }
                    }, message: {Text(S.Alert.Message.checkWidgetDelete)})

            }

        }
        .listRowSeparator(.visible)
        .listStyle(.plain)
    }

    // Placeholder (위젯 없을 때.)
    var emptyGrid: some View {
        ZStack {
            VStack {
                NavigationLink {
                    MakeWidgetView()
                } label: {
                    VStack(spacing: 8) {
                        Text(S.MainWidgetView.EmptyGrid.messageLine1)
                            .font(.custom(CustomFont.NotoSansKR.bold, size: 16))
                        Text(S.MainWidgetView.EmptyGrid.messageLine2)
                            .font(.custom(CustomFont.NotoSansKR.bold, size: 18))
                            .foregroundStyle(Constants.kogetGradient)
                    }
                    .padding(.bottom, 32)
                }
                .frame(width: deviceSize.width - 32, height: 40)

            }
        }
    }
}
//
// struct WidgetListGridView_Previews: PreviewProvider {
//     static var previews: some View {
//         NavigationView {
//             WidgetListContainerView(viewModel: MainWidgetViewModel.shared)
//         }
//         .environmentObject(StorageProvider(inMemory: true))
//     }
// }
