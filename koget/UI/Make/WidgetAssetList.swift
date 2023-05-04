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
    @ObservedObject var viewModel: MakeWidgetViewModel

    @State private var searchText: String = ""
    @State var searching: Bool = false
    @State var presentAssetRequestView: Bool = false

    //Strings
    let appList = S.WidgetAssetList.appList
    let requestApp = S.WidgetAssetList.requestApp
    let excutableToggleLabel = S.WidgetAssetList.excutableToggleLabel
    let searchApp = S.WidgetAssetList.searchApp

    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            AppColor.Background.first
                .ignoresSafeArea()
            VStack {
                
                Text(appList)
                    .font(.custom(CustomFont.NotoSansKR.bold, size: 18))
                    .padding(.vertical, 12)
                
                VStack(alignment: .leading) {
                    TextFieldView(systemName: .magnifyingglass, placeholder: S.WidgetAssetList.searchApp, text: $searchText)
                        .padding(.horizontal)
                    
                    HStack {
                        
                        Button {
                            presentAssetRequestView.toggle()
                        } label: {
                            Text(requestApp)
                                .font(.custom(CustomFont.NotoSansKR.medium, size: 14))
                                .foregroundColor(AppColor.Label.second)
                                .padding(.leading, 16)
                        }
                        .sheet(isPresented: $presentAssetRequestView) {
                            AssetRequestView()
                        }

                        Spacer()

                        Text(excutableToggleLabel)
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
                        .frame(width: Constants.deviceSize.width, height: 12)
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
