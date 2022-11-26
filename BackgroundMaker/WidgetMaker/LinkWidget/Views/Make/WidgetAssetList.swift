//
//  WidgetListForDeepLink.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/22.
//

import SwiftUI

struct WidgetAssetList: View {
    
    var builtInWidgets = FilterWidgetModel()
    
    @State var viewModel: LinkWidgetModel?
    
    
    @State private var searchText: String = ""
    @State var searching: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Color.init(uiColor: AppColors.normalDarkGrey)
            VStack {
                NavigationView {
                    List(searchText.isEmpty ? builtInWidgets.data : builtInWidgets.searchResults, id: \.id) { widget in
                        Button {
                            viewModel?.getWidgetData(selectedWidget: widget)
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack {
                                Image(uiImage: widget.image ?? UIImage(named: "questionmark.circle")!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)
                                    .cornerRadius(15)
                                    .padding(.trailing, 5)
                                    .padding(.vertical, 4)
                                Text(widget.appNameGlobal)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .navigationTitle("앱 리스트")
                    .navigationBarTitleDisplayMode(.inline)
                }
                .searchable(text: $searchText, placement: .toolbar)
                .onChange(of: searchText) { searchText in
                    builtInWidgets.searchResults = builtInWidgets.data.filter({ widget in
                        widget.appNameGlobal.lowercased().contains(searchText.lowercased()) ||
                        widget.appName_en.lowercased().contains(searchText.lowercased()) ||
                        widget.appName_ko.lowercased().contains(searchText.lowercased())
                    })
                }
                
            }
        }
        
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
