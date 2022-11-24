//
//  MainWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI
import CoreData
import RxSwift

struct MainWidgetView: View {
    
    @State var deepLinkWidgets: [DeepLink] = []
    var disposeBag = DisposeBag()

    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Color(uiColor: AppColors.blackDarkGrey)
                        .ignoresSafeArea()
                    VStack {
                        ZStack {
                            VStack {
                            CreateWidgetButton()
                                .padding(.horizontal)
                                .padding(.bottom)
                                ZStack {
                                    Color.black
                                    VStack {
                                        WidgetScrollView(title: "딥 링크 위젯", deepLinkWidgets: $deepLinkWidgets)
                                            .padding(.top, 16)
                                        Spacer()
                                    }
                                }
                            }
                        }
       
                    }
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
        MainWidgetView()
    }
}



// 위젯 만들기 버튼
struct CreateWidgetButton: View {
    
    let deviceSize = UIScreen.main.bounds.size
    @State var isPresent: Bool = false

    var body: some View {
        NavigationLink {
            AddWidgetView()
        } label: {
                HStack {
                    Image(systemName: "cursorarrow.and.square.on.square.dashed")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .tint(.gray)
                    Spacer()

                    Text("위젯 만들기")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    Spacer()
            }
            .padding()
            .background(Color(uiColor: AppColors.normalDarkGrey))
            .shadow(radius: 3)
        }
        .frame(width: deviceSize.width - 50, height: 70)
        .background(Color(uiColor: AppColors.deepDarkGrey))
        .cornerRadius(10)
        .padding(.top)
    }
}

// 딥링크 위젯 스크롤 뷰
struct WidgetScrollView: View {
    
    var title: String
    let deviceSize = UIScreen.main.bounds
    @State var isPresent = false
    
    @Binding var deepLinkWidgets: [DeepLink]
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    var body: some View {
        VStack {
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(deepLinkWidgets, id: \.id) { widget in
                        Button {
                            self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                                EditWidgetView(widget: widget)
                            })
                        } label: {
                            DeepLinkWidgetIconView(
                                image: UIImage(data: widget.image!) ?? UIImage(named: "qustionmark.circle")!,
                                name: widget.name!)
                            .tint(.white)
                        }
                    }
                }
            }
            .frame(width: deviceSize.width - 32, height: 100)
            .background(Color(uiColor: AppColors.normalDarkGrey))
            .cornerRadius(10)
            .shadow(radius: 3)

        }.padding(.horizontal)
    }
}



struct DeepLinkWidgetIconView: View {
    
    let image: UIImage
    let name: String
    
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 50, height: 50)
            Text(name)
                .lineLimit(2)
                .font(.system(size: 13))
        }.frame(width: 70, height: 80)
    }
}
