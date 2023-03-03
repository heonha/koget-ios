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
    var cellSize: (grid: CGFloat, list: CGFloat)

    @ObservedObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData
    @Environment(\.viewController) var viewControllerHolder: UIViewController?

    init(widget: DeepLink, viewModel: MainWidgetViewModel, type: WidgetIconCellType) {
        self.widget = widget
        self.type = type
        self.viewModel = viewModel
        self.cellSize = (grid: deviceSize.width / 4.3, list: 50)

    }

    @State var isDelete: Bool = false
    lazy var imageSize = CGSize(width: cellSize.grid * 0.63, height: cellSize.grid * 0.63)
    lazy var textSize = CGSize(width: cellSize.grid, height: cellSize.grid * 0.40)
    
    let app: LocalizedStringKey = "앱"
    let web: LocalizedStringKey = "웹 페이지"

    @Environment(\.dismiss) var dismiss

    var body: some View {
        if let data = widget.image, let name = widget.name, let url = widget.url {
            if let widgetImage = UIImage(data: data) {
                Menu {
                    Button {
                        if let url = widget.url, let id = widget.id {
                            viewModel.maybeOpenedFromWidget(urlString: "\(schemeToAppLink)\(url)\(idSeparator)\(id.uuidString)")
                        } else {
                            // print("CoreData url Error")
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
                    Button(role: .destructive) {
                        isDelete.toggle()
                        // WidgetCoreData.shared.deleteData(data: widget)
                        // MainWidgetViewModel.shared.deleteSuccessful = true
                    } label: {
                        Label("삭제", systemImage: "trash.fill")
                    }
                } label: {
                    if type == .grid {
                        WidgetButton(name: name, url: url, widgetImage: widgetImage,
                                     cellWidth: cellSize.grid, viewModel: viewModel)
                    } else {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.6), radius: 0.5, x: -0.2, y: -0.5)
                                    .shadow(color: .black.opacity(0.6), radius: 0.5, x: 0.2, y: 0.5)

                                Image(uiImage: .init(data: widget.image!) ?? UIImage(named: "questionmark.circle")!)
                                    .resizable()
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text(widget.name ?? "알수없음")
                                switch viewModel.checkLinkType(url: widget.url ?? "" ) {
                                case .app:
                                    Text(self.app)
                                        .font(.custom(CustomFont.NotoSansKR.regular ,size: 13))
                                        .foregroundColor(.gray)
                                case .web:
                                    Text(self.web)
                                        .font(.custom(CustomFont.NotoSansKR.regular ,size: 13))
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(Color.init(uiColor: .gray))
                                        .frame(width: 70, height: 20)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, x: 0.2, y: 0.5)
                                        .opacity(0.7)
                                    Group {
                                        HStack(spacing: 0) {
                                        Text("\(Int(widget.runCount))")
                                            .font(.system(size: 14, weight: .semibold))
                                            .shadow(color: .black.opacity(0.4), radius: 0.5, x: 0.2, y: 0.5)

                                        Text("회 실행")
                                            .font(.system(size: 13, weight: .medium))
                                            .shadow(color: .black.opacity(0.4), radius: 0.5, x: 0.2, y: 0.5)
                                        }
                                        .foregroundStyle(Color.init(uiColor: .white))
                                    }
                                }
                            }
                        }
                        .frame(height: cellSize.list)
                        .alert("삭제 확인", isPresented: $isDelete, actions: {
                            Button("삭제", role: .destructive) {
                                WidgetCoreData.shared.deleteData(data: widget)
                                MainWidgetViewModel.shared.deleteSuccessful = true
                                isDelete = false
                                self.dismiss()
                                
                            }
                            Button("취소", role: .cancel) {}
                        }, message: {Text("\(widget.name ?? "알수없음")정말 삭제 하시겠습니까?")})
                    }
                }
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
            WidgetIconCell(widget: DeepLink.example, viewModel: MainWidgetViewModel.shared, type: .list)
                .padding(.horizontal)
        }
        .environmentObject(StorageProvider())
    }
}
