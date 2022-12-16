//
//  WidgetGridView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI


// 딥링크 위젯 리스트 뷰
struct WidgetGridView: View {
    
    var title: String = ""
    
    var gridItem = [GridItem(), GridItem(), GridItem(), GridItem()]
    var width = Constants.deviceSize.width / 4
    
    @State var isPresent = false
    @State var deepLinkWidgets: [DeepLink] = []
    
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    var body: some View {
        
        VStack {
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            
            LazyVGrid(columns: gridItem, alignment: .leading, spacing: 16 ) {
                ForEach(deepLinkWidgets, id: \.id) { widget in
                    Button {
                        self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                            DetailWidgetView(selectedWidget: widget)
                        })
                    } label: {
                        WidgetIconView(selectedObject: widget)
                            .tint(.white)
                            .frame(width: width, height: width)
                            .clipped()
                    }
                    .frame(width: width, height: width)
                }
            }
            .background(Color(uiColor: AppColors.normalDarkGrey))
            .cornerRadius(10)
            .shadow(radius: 3)
            Spacer()
        }.onAppear {
            subscribeWidgetData() // 위젯 데이터 가져오기
        }.onDisappear {
            WidgetCoreData.shared.disposeBag = .init()
        }
    }
    
    
    func subscribeWidgetData() {
        WidgetCoreData.shared.widgets
            .subscribe { (widgets) in
                deepLinkWidgets = widgets
                for widget in deepLinkWidgets {
                    print(widget.name!)
                }
            } onDisposed: {
                print("disposed")
            }.disposed(by: WidgetCoreData.shared.disposeBag)
    }
}


struct WidgetGridView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        
        NavigationView {
            WidgetGridView(title: "링크 위젯", deepLinkWidgets: StorageProvider.preview.linkWidgets)
            Spacer()
        }
        .environmentObject(StorageProvider.preview)

    }
}
