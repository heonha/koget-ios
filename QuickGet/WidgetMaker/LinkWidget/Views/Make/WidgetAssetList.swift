//
//  WidgetListForDeepLink.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/22.
//

import SwiftUI

struct WidgetAssetList: View {
    
    var builtInWidgets = FilterWidgetModel()
    
    var textColor: Color = AppColors.label
    var imageSize: CGSize = .init(width: 40, height: 40)
    
    @State var viewModel: LinkWidgetModel?
    @State private var searchText: String = ""
    @State var searching: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            AppColors.normalDarkGrey
            VStack {
                NavigationView {
                    List(searchText.isEmpty ? builtInWidgets.data : builtInWidgets.searchResults, id: \.id) { widget in
                        Button {
                            viewModel?.getWidgetData(selectedWidget: widget)
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            LazyHStack {
                                Image(uiImage: widget.image ?? UIImage(named: "questionmark.circle")!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageSize.width, height: imageSize.height)
                                    .clipShape(Circle())
                                    .shadow(radius: 0.5, x: 0.5, y: 0.5)
                                    .padding([.trailing, .vertical], 4)
                                Text(widget.appNameGlobal)
                                    .fontWeight(.semibold)
                                    .foregroundColor(textColor)
                            }
                        }
                    }
                    .navigationTitle("앱 리스트")
                    .navigationBarTitleDisplayMode(.inline)
                }
                .searchable(text: $searchText, placement: .toolbar)
                .onChange(of: searchText) { searchText in
                    fetchSearchData(searchText: searchText)
                }
                
            }
        }
        
    }
    
    func fetchSearchData(searchText: String) {
        builtInWidgets.searchResults = builtInWidgets.data.filter({ widget in
            widget.appNameGlobal.lowercased().contains(searchText.lowercased()) ||
            widget.appName.lowercased().contains(searchText.lowercased())
        })
    }
    
}

struct WidgetListForDeepLink_Previews: PreviewProvider {
    
    static var previews: some View {
        WidgetAssetList()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
