//
//  HomeWidgetView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/06/27.
//

import SwiftUI
import SFSafeSymbols

struct HomeWidgetView: View {
    
    // Flow -> 다른 셀이 클릭됨 (ParentView에서 감지) 다른 선택된 셀이 있다면 false로 업데이트
    // 그때 Cell은 다른셀이 클릭 되었음을 감지하고 flase가 되야함.
    // ViewModel -> Cell으로 업데이트 내용 전달 -> Cell 업데이트.
    @StateObject var viewModel: HomeWidgetViewModel = .init()
    
    @EnvironmentObject private var constant: AppStateConstant
    @EnvironmentObject private var coredata: WidgetCoreData

    @State private var onDarkMode = false
    @State private var onListView = false
    @State private var viewType: WidgetViewType = .list
    @State private var offsetX: CGFloat = .zero
    @State var isFloatingButtonOpen = false

    var body: some View {
        NavigationView {
            ZStack {
                mainBody()
                    .toolbar {
                        createToolbar()
                    }
                    .onDisappear {
                        isFloatingButtonOpen = false
                    }
                
                    MainFloatingButton(isOpen: $isFloatingButtonOpen)
                    .offset(x: Constants.deviceSize.width/3,
                            y: Constants.deviceSize.height/3)
            }

        }
        .overlay {
            overlayDetailView(widget: viewModel.targetWidget)
        }
        .environmentObject(viewModel)
        
    }

}

extension HomeWidgetView {
    
    private func mainBody() -> some View {
        VStack {
            AdPageContainer()
                .padding(.horizontal, 15)

            vstackCellScrollView

        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var vstackCellScrollView: some View {
        ScrollView {
            VStack {
                ForEach(0..<$viewModel.widgets.count) { index in
                    SlideableWidgetCell(widget: viewModel.widgets[index])
                        .onAppear {
                            print("DEBUG: INDEX: \(index)")
                        }
                }
            }
        }
        .background(
            ZStack {
                VStack {
                    Circle()
                        .fill(Color.blue)
                        .scaleEffect (0.4, anchor: .leading)
                        .offset(x: 20)
                        .blur(radius: 120)
                    Circle()
                        .fill(Color.red)
                        .scaleEffect (0.4, anchor: .trailing)
                        .offset(y: -30)
                        .blur (radius: 120)
                }
            }
        )
    }
    
    private func overlayDetailView(widget: DeepLink?) -> some View {
        Group {
            if viewModel.showDetail {
                if let widget = viewModel.targetWidget {
                    ZStack {
                        Rectangle()
                            .fill(.black.opacity(0.3))
                            .blur(radius: 4)
                            .ignoresSafeArea()
                        DetailWidgetView(selectedWidget: widget)
                            .environmentObject(viewModel)
                    }
                    .onAppear {
                        print("DEBUG: \(#function)is Appear")
                    }
                    .onDisappear {
                        viewModel.fetchAllWidgets()
                        viewModel.objectWillChange.send()
                    }

                }
            }
        }
    }
    
    private func widgetListCell(_ widget: DeepLink) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "F9F9F9"))
            HStack {
                Group {
                    Image
                        .uiImage(UIImage(data: widget.image ?? Data()) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                
                VStack {
                    Text(widget.name ?? "")
                        .font(.custom(.robotoBold, size: 16))
                    
                    Text(widget.type ?? "")
                        .font(.custom(.robotoMedium, size: 14))
                }
                
                Spacer()
            }
        }
        .frame(height: 58)
    }
    
    private func viewTypeToggle(type: WidgetViewType) -> some View {
        Button {
            if type == .list {
                viewType = .grid
            } else {
                viewType = .list
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor($constant.isDarkMode.wrappedValue
                                     ? AppColor.toggleOnBGColor
                                     : AppColor.toggleOffBGColor)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0.7, y: 0.7)
                
                Image(systemSymbol: type == .list
                      ? SFSymbol.listBullet
                      : SFSymbol.squareGrid3x3)
                .foregroundColor(AppColor.Label.first)
                .font(.system(size: 14))
                .padding(4)
            }
        }
        .frame(width: 32, height: 32)

    }
    
    func createToolbar() -> some ToolbarContent {
        Group {
            // Center
            ToolbarItem(placement: .navigationBarLeading) {
                kogetLogoView()
            }
            
            // trailing 2
            ToolbarItem(placement: .navigationBarTrailing) {
                Toggle(isOn: $constant.isDarkMode) { }
                    .toggleStyle(DarkModeToggleStyle())
            }
            
            // trailing 1
            if !coredata.linkWidgets.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    viewTypeToggle(type: viewType)
                }
            }
        }

    }

    private func kogetLogoView() -> some View {
        CommonImages.koget
            .toImage()
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
    }
}

#if DEBUG
struct HomeWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        HomeWidgetView()
            .environmentObject(WidgetCoreData.shared)
            .environmentObject(AppStateConstant.shared)
    }
}
#endif
