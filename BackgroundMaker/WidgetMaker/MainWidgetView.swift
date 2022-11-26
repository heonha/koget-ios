//
//  MainWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI
import CoreData
import RxSwift

// 메인 뷰
struct MainWidgetView: View {
    
    @State private var deepLinkWidgets: [DeepLink] = []
    
    var disposeBag = DisposeBag()
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Color(uiColor: AppColors.blackDarkGrey)
                        .ignoresSafeArea()
                    VStack {
                        WidgetButtonToMake()
                        WidgetCollectionView(deepLinkWidgets: $deepLinkWidgets)
                    }
                    .padding(.horizontal)
                }
                
                .navigationTitle("위젯")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tint(.white)
        }.onAppear {
            print("On Appear")
            subscribeWidgetData()
        }.onDisappear {
            WidgetCoreData.shared.disposeBag = .init()
        }
    }
    
    func subscribeWidgetData() {
        print("새로운 구독 시작")
        WidgetCoreData.shared.widgets
            .subscribe { (widgets) in
                print("onNext")
                deepLinkWidgets = widgets
            } onDisposed: {
                print("disposed")
            }.disposed(by: WidgetCoreData.shared.disposeBag)
    }}

struct MainWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            MainWidgetView()
        }
        .environmentObject(StorageProvider.preview)
    }
}







