//
//  HomeWidgetView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/06/27.
//

import SwiftUI
import SFSafeSymbols

struct HomeWidgetView: View {
    
    @ObservedObject var viewModel: HomeWidgetViewModel
    
    @EnvironmentObject private var constant: AppStateConstant
    @EnvironmentObject private var coredata: WidgetCoreData

    @State private var onDarkMode = false
    @State private var onListView = false
    @State private var viewType: WidgetViewType = .list
    
    var body: some View {
        NavigationView {
            mainBody()
                .toolbar {
                    createToolbar()
                }
        }
        
    }
    
}

extension HomeWidgetView {
    
    private func mainBody() -> some View {
        VStack {
            AdPageContainer()
            
            ScrollView {
                VStack {
                    ForEach($viewModel.widgets.wrappedValue) { widget in
                        ListCell(widget: widget)
                    }
                }
            }
        }
        .padding(.horizontal, 15)
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
        HomeWidgetView(viewModel: HomeWidgetViewModel())
            .environmentObject(WidgetCoreData.shared)
            .environmentObject(AppStateConstant.shared)
    }
}
#endif
