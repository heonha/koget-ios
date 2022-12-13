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
    @State var deepLinkWidgets: [DeepLink] = []
    
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    var body: some View {
        
        VStack {
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
                                DetailWidgetView(selectedWidget: widget)
                            })
                        } label: {
                            WidgetIconView(selectedObject: widget)
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


struct DeepLinkWidgetScrollView_Previews: PreviewProvider {
        
    
    static var previews: some View {
        
        NavigationView {
            WidgetListScrollView(title: "링크 위젯")
            Spacer()
        }
    }
}
