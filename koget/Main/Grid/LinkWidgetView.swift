//
//  WidgetCollectionView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct LinkWidgetView: View {
    
    let backgroundColor: Color = AppColors.backgroundColor
    @StateObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea(edges: .bottom)
            VStack {
                // 그리드뷰
                if viewModel.isGridView {
                    WidgetGrid(title: "나의 잠금화면 위젯")
                } else {
                    
                    // 리스트뷰
                    List(coreData.linkWidgets, id: \.id) { widget in
                        

                            HStack {
                                Image(uiImage: .init(data: widget.image!) ?? UIImage(named: "questionmark.circle")!)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                VStack(alignment: .leading) {
                                    Text(widget.name ?? "알수없음")
                                    switch viewModel.checkLinkType(url: widget.url ?? "" ) {
                                    case .app:
                                        Text("앱")
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                    case .web:
                                        Text("웹 페이지")
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                                    Text("지금까지 \(Int(widget.runCount))회 실행")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .frame(height: 50)
                            .onTapGesture {
                                print("\(widget.name!): \(coreData.lastSelectedWidget?.name)")
                            }
                        

                    }
                }
            }
        }
    }
}


struct WidgetListGridView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LinkWidgetView(viewModel: MainWidgetViewModel.shared)
        }
        .environmentObject(StorageProvider(inMemory: true))
    }
}
