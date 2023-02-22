//
//  WidgetIconCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

enum WidgetIconCellType {
    case grid
    case list
}

struct WidgetIconCell: View {
    
    var widget: DeepLink
    var type: WidgetIconCellType
    var gridCellWidth: CGFloat = GRID_CELL_WIDTH
    var listCellHeight: CGFloat = 50

    
    @ObservedObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData
    @Environment(\.viewController) var viewControllerHolder: UIViewController?

    
    init(widget: DeepLink, viewModel: MainWidgetViewModel, type: WidgetIconCellType) {
        self.widget = widget
        self.viewModel = viewModel
        self.type = type
    }
    
    let app: LocalizedStringKey = "앱"
    let web: LocalizedStringKey = "웹 페이지"

    
    
    var body: some View {
        if let data = widget.image, let name = widget.name, let url = widget.url {
            if let widgetImage = UIImage(data: data) {
                
                
                Menu {
                    Button {
                        if let url = widget.url, let id = widget.id {
                            viewModel.maybeOpenedFromWidget(urlString: "\(SCHEME_LINK)\(url)\(ID_SEPARATOR)\(id.uuidString)")
                        } else {
                            print("CoreData url Error")
                        }
                    } label: {
                        Label("실행하기", systemImage: "arrow.up.left.square.fill")
                    }
                    Button {
                        self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                            DetailWidgetView(selectedWidget: widget)
                        })
                    } label: {
                        Label("편집", systemImage: "slider.horizontal.3")
                    }
                    Divider()
                    Button(role: .destructive) {
                        WidgetCoreData.shared.deleteData(data: widget)
                        MainWidgetViewModel.shared.deleteSuccessful = true
                    } label: {
                        Label("삭제", systemImage: "trash.fill")
                    }
                
                } label: {
                    
                    if type == .grid {
                        WidgetButton(name: name, url: url, widgetImage: widgetImage, cellWidth: gridCellWidth, imageSize: CGSize(width: gridCellWidth * 0.63, height: gridCellWidth * 0.63), textSize: CGSize(width: gridCellWidth, height: gridCellWidth * 0.40), viewModel: viewModel)
                    } else {
                        
                        HStack {
                            Image(uiImage: .init(data: widget.image!) ?? UIImage(named: "questionmark.circle")!)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(widget.name ?? "알수없음")
                                switch viewModel.checkLinkType(url: widget.url ?? "" ) {
                                case .app:
                                    Text(self.app)
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                case .web:
                                    Text(self.web)
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(Constants.kogetGradient)
                                        .frame(width: 70, height: 20)
                                        .opacity(0.8)
                                    Group {
                                        HStack(spacing: 0) {
                                        Text("\(Int(widget.runCount))")
                                            .font(.system(size: 14, weight: .semibold))
                                        Text("회 실행")
                                            .font(.system(size: 13, weight: .medium))
                                        }
                                        .foregroundColor(.init(uiColor: .label))
                                    }
                                }
                            }

                            
                        }
                        .frame(height: listCellHeight)
                    }

                }
                // 버튼
                
                
                
            }
        }
    }
}


struct DeepLinkWidgetIconView_Previews: PreviewProvider {

    static var previews: some View {
        
        
        ZStack {
            // 배경
            AppColors.secondaryBackgroundColor
                .ignoresSafeArea()
            
            // 컨텐츠
            WidgetIconCell(widget: DeepLink.example, viewModel: MainWidgetViewModel.shared, type: .grid)
        }
        .environmentObject(StorageProvider())
    }
}



