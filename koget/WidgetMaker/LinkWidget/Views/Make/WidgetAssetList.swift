//
//  WidgetListForDeepLink.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/22.
//

import SwiftUI

struct WidgetAssetList: View {
    
    @StateObject var widgetAssets = WidgetAssetViewModel()
    
    var textColor: Color = AppColors.label
    var imageSize: CGSize = .init(width: 40, height: 40)
    
    @State var viewModel: MakeWidgetViewModel
    @State private var searchText: String = ""
    @State var searching: Bool = false
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                
                Text("앱 리스트")
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.vertical, 12)
                
                VStack(alignment: .leading) {
                    TextFieldView(systemName: "magnifyingglass", placeholder: "앱 검색하기", text: $searchText)
                        .padding(.horizontal)
                    
                    HStack {
                        Spacer()
                        Text("설치된 앱만 보기")
                            .font(.system(size: 14, weight: .semibold))
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
                        .frame(width: DEVICE_SIZE.width, height: 12)
                        .foregroundColor(.init(uiColor: .secondarySystemFill))
                }
                
                // 리스트
                List(searchText.isEmpty ? widgetAssets.data : widgetAssets.searchResults, id: \.id) { widget in
                    
                    Button {
                        viewModel.getWidgetData(selectedWidget: widget)
                        self.dismiss()
                    } label: {
                        LazyHStack {
                            Image(uiImage: widget.image ?? UIImage(named: "questionmark.circle")!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: imageSize.width, height: imageSize.height)
                                .clipShape(Circle())
                                .shadow(color: .black, radius: 0.25, x: 0.5, y: 0.5)
                                .padding([.trailing, .vertical], 4)
                            Text(widget.displayName)
                                .fontWeight(.semibold)
                                .foregroundColor(textColor)
                            if !widget.canOpen {
                                Text("(미설치)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    // .disabled(!widget.canOpen)
                    // .opacity(widgetAssets.canOpenApp(widget.canOpen))
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
