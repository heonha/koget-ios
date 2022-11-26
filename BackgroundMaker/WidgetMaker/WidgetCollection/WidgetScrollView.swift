//
//  WidgetScrollView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI


// 딥링크 위젯 리스트 뷰
struct WidgetListScrollView: View {
    
    var title: String
    
    @State var isPresent = false
    @Binding var deepLinkWidgets: [DeepLink]
    
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    var body: some View {
        
        Text(title)
            .fontWeight(.bold)
            .font(.system(size: 20))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(deepLinkWidgets, id: \.id) { widget in
                    Button {
                        self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                            DetailWidgetView(widget: widget)
                        })
                    } label: {
                        WidgetIconView(
                            image: UIImage(data: widget.image!) ?? UIImage(named: "qustionmark.circle")!,
                            name: widget.name!)
                        .tint(.white)
                    }
                }
            }
        }
        .frame(width: Constants.deviceSize.width - 32, height: 100)
        .background(Color(uiColor: AppColors.normalDarkGrey))
        .cornerRadius(10)
        .shadow(radius: 3)
        
        Spacer()
        
    }

}


struct DeepLinkWidgetScrollView_Previews: PreviewProvider {
        
    
    static var previews: some View {
        
        NavigationView {
            WidgetListScrollView(title: "링크 위젯", deepLinkWidgets: .constant(StorageProvider.preview.linkWidgets))
            Spacer()
        }
    }
}
