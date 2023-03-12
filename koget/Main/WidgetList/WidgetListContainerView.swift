//
//  WidgetCollectionView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import QGrid

// 위젯 Grid 및 List를 표현하는 컨테이너
struct WidgetListContainerView: View {
    
    let backgroundColor: Color = AppColor.Background.first
    @StateObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData

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
                    .swipeActions(allowsFullSwipe: true) {
                        Button {
                          print("Bookmark")
                        } label: {
                          Label("Bookmark", systemImage: "bookmark")
                        }
                        .onTapGesture {
                            print("???")
                        }

                    }
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
                        Text("이곳을 눌러 바로가기 위젯을 생성하고")
                            .font(.custom(CustomFont.NotoSansKR.bold, size: 16))
                        Text("다양한 앱/웹페이지에 빠르게 접근하세요!")
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

struct WidgetListGridView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WidgetListContainerView(viewModel: MainWidgetViewModel.shared)
        }
        .environmentObject(StorageProvider(inMemory: true))
    }
}
