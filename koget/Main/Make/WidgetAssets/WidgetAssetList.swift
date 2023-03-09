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
    
    var textColor: Color = AppColor.Label.first
    var installTextColor: Color = AppColor.Label.second
    var imageSize: CGSize = .init(width: 40, height: 40)
    
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
                                .foregroundColor(.init(uiColor: .secondaryLabel))
                                .padding(.leading, 16)
                        }
                        .sheet(isPresented: $presentAssetRequestView) {
                            AssetRequestView()
                        }

                        Spacer()
                        Text("실행가능한 앱/웹 보기")
                            .font(.custom(CustomFont.NotoSansKR.medium, size: 14))
                            .foregroundColor(.init(uiColor: .secondaryLabel))
                            .padding(.leading)
                        Toggle(isOn: $widgetAssets.isOnlyInstalledApp) {
                        }
                        .toggleStyle(.switch)
                        .frame(width: 50, height: 30)
                        .padding(.trailing, 24)
                        .tint(.blue)
                        
                    }
                    Rectangle()
                        .frame(width: deviceSize.width, height: 12)
                        .foregroundColor(.init(uiColor: .secondarySystemFill))
                }
                
                // 리스트
                List(searchText.isEmpty ? widgetAssets.data : widgetAssets.searchResults, id: \.id) { widget in
                    
                    Button {
                        viewModel.getWidgetData(selectedWidget: widget)
                        self.dismiss()
                    } label: {
                        LazyHStack {
                            ZStack {
                                Color.white
                                Image(uiImage: widget.image ?? UIImage(named: "questionmark.circle")!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageSize.width, height: imageSize.height)
                            }
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.3, y: 0.3)
                            .shadow(color: .black.opacity(0.1), radius: 0.5, x: -0.3, y: -0.3)

                            .padding([.trailing, .vertical], 4)
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(widget.displayName)
                                        .fontWeight(.semibold)
                                    .foregroundColor(textColor)
                                    if !widget.canOpen {
                                        Text("(미설치)")
                                            .font(.custom(CustomFont.NotoSansKR.bold, size: 14))
                                            .foregroundColor(installTextColor)
                                    }
                                }
                                Text(MainWidgetViewModel.shared.checkLinkType(url: widget.url).rawValue)
                                    .font(.custom(CustomFont.NotoSansKR.medium, size: 12))
                                    .foregroundColor(installTextColor)
                                    .padding(.leading, 1)
                            }
                        }
                    }
                    .disabled(Switcher.shared.isTestMode ? false : !widget.canOpen)
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
