//
//  WidgetListForDeepLink.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/22.
//

import SwiftUI

struct WidgetListView: View {
    
    var builtInWidgets = WidgetModel.shared.builtInApps
    @State private var searchText: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    @State var viewModel: WidgetModels?

    var body: some View {
        ZStack {
            Color.init(uiColor: AppColors.normalDarkGrey)
            VStack {
                TextField(" 여기에 검색하세요", text: $searchText)
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                    .background(Color.init(uiColor: AppColors.normalDarkGrey))
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                    .onTapGesture {
                        hideKeyboard()
                    }
                List(builtInWidgets, id: \.id) { widget in
                    ZStack {
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
                }
            }
        }
    }
}

struct WidgetListForDeepLink_Previews: PreviewProvider {
    
    
    static var previews: some View {
        WidgetListView(builtInWidgets: [
            BuiltInDeepLink(type: .builtIn, appID: "id", appNameGlobal: "Tmap", appName_ko: "T map", appName_en: "TmapEN", deepLink: "tmap://", image: UIImage(named: "tmap")!),
            BuiltInDeepLink(type: .builtIn, appID: "id", appNameGlobal: "Tmap", appName_ko: "T map", appName_en: "TmapEN", deepLink: "tmap://", image: UIImage(named: "tmap")!),
            BuiltInDeepLink(type: .builtIn, appID: "id", appNameGlobal: "Tmap", appName_ko: "T map", appName_en: "TmapEN", deepLink: "tmap://", image: UIImage(named: "tmap")!)])
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
