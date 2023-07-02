//
//  HomeWidgetView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/06/27.
//

import SwiftUI

enum WidgetViewType {
    case list
    case grid
}

struct HomeWidgetView: View {
    
    @StateObject private var viewModel = HomeWidgetViewModel()
    
    @State private var onDarkMode = false
    @State private var onListView = false
    @State private var viewType: WidgetViewType = .list
    @State private var offsetX: CGFloat = .zero
    @State private var isFloatingButtonOpen = false
    
    @EnvironmentObject private var constant: AppStateConstant
    @EnvironmentObject private var coredata: WidgetCoreData
    
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
                    .offset(x: Constants.deviceSize.width / 3,
                            y: Constants.deviceSize.height / 3)
            }
        }
        .overlay {
            OverlayHomeWidgetView()
        }
        .environmentObject(viewModel)
        
    }
    
}

extension HomeWidgetView {
    
    private func mainBody() -> some View {
        VStack {
            AdPageContainer()
                .padding(.horizontal, 15)
                .padding(.bottom, 12)
            
            Group {
                switch viewType {
                case .grid:
                    GridScrollView()
                case .list:
                    ListScrollView()
                }
            }
            .background(
                ZStack {
                    VStack {
                        Circle()
                            .fill(Color.blue)
                            .scaleEffect (0.40, anchor: .leading)
                            .offset(x: 20)
                            .blur(radius: 120)
                        Circle()
                            .fill(Color.red)
                            .scaleEffect (0.40, anchor: .trailing)
                            .offset(y: -20)
                            .blur (radius: 120)
                    }
                }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
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
            switch type {
            case .list:
                viewType = .grid
            case .grid:
                viewType = .list
            }
        } label: {
            ZStack {
                Circle()
                    .fill(.regularMaterial)
                Image(systemName: type == .list
                      ? "checklist.unchecked"
                      : "circle.grid.2x2")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color.init(uiColor: .secondaryLabel))
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0.5, y: 0.5)
            }
            .frame(width: 32, height: 32)
        }
    }
    
    private func createToolbar() -> some ToolbarContent {
        Group {
            // Center
            ToolbarItem(placement: .navigationBarLeading) {
                kogetLogoView()
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Toggle(isOn: $constant.isDarkMode) { }
                    .toggleStyle(DarkModeToggleStyle())
            }
            
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
