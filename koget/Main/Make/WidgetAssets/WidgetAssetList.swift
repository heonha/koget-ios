//
//  WidgetListForDeepLink.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/22.
//

import SwiftUI
import SFSafeSymbols

struct WidgetAssetList: View {
    
    @StateObject var widgetAssets = WidgetAssetViewModel()
    @State var viewModel: MakeWidgetViewModel
    @State private var searchText: String = ""
    @State var searching: Bool = false
    @State var presentAssetRequestView: Bool = false
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            AppColor.Background.first
                .ignoresSafeArea()
            VStack {
                
                Text("앱 리스트")
                    .font(.custom(CustomFont.NotoSansKR.bold, size: 18))
                    .padding(.vertical, 12)
                
                VStack(alignment: .leading) {
                    TextFieldView(systemName: .magnifyingglass, placeholder: "앱 검색하기", text: $searchText)
                        .padding(.horizontal)
                    
                    HStack {
                        
                        Button {
                            presentAssetRequestView.toggle()
                        } label: {
                            Text("앱/웹 추가요청")
                                .font(.custom(CustomFont.NotoSansKR.medium, size: 14))
                                .foregroundColor(AppColor.Label.second)
                                .padding(.leading, 16)
                        }
                        .sheet(isPresented: $presentAssetRequestView) {
                            AssetRequestView()
                        }

                        Spacer()

                        Text("실행가능한 앱/웹 보기")
                            .font(.custom(CustomFont.NotoSansKR.medium, size: 14))
                            .foregroundColor(AppColor.Label.second)
                            .padding(.leading)

                        Toggle(isOn: $widgetAssets.isOnlyInstalledApp) {

                        }
                        .toggleStyle(CheckmarkToggleStyle())
                        .frame(width: 30, height: 30)
                        .tint(.blue)
                        .padding(.trailing, 20)

                    }
                    Rectangle()
                        .frame(width: deviceSize.width, height: 12)
                        .foregroundColor(.init(uiColor: .secondarySystemFill))
                }
                
                // 리스트
                List(searchText.isEmpty ? widgetAssets.data : widgetAssets.searchResults, id: \.id) { widget in
                    WidgetAssetCell(viewModel: viewModel, widget: widget)
                        .opacity(widgetAssets.canOpenApp(widget.canOpen))
                        .listStyle(.plain)

                }
                .onChange(of: searchText) { searchText in
                    widgetAssets.fetchSearchData(searchText: searchText)
                }
                .onChange(of: widgetAssets.isOnlyInstalledApp) { isOnlyInstallApp in
                    widgetAssets.fetchData(isOnlyInstall: isOnlyInstallApp)
                }
            }
        }
    }
}

struct WidgetListForDeepLink_Previews: PreviewProvider {
    
    static var previews: some View {
        WidgetAssetList(viewModel: MakeWidgetViewModel())
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
