//
//  WidgetIconCell.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import SwiftEntryKit

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
    @State var isOn = false
    @State var deleteAlertView = UIView()


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
                        listCell
                    }
                }
                .alert("\(widget.name ?? "알수없음")", isPresented: $isDelete, actions: {
                    Button("삭제", role: .destructive) {
                        WidgetCoreData.shared.deleteData(data: widget)
                        isDelete = false
                        self.dismiss()
                        self.displayToast()
                    }
                    Button("취소", role: .cancel) {}
                }, message: {Text("이 위젯을 삭제 할까요?")})
                .onAppear {
                    deleteAlertView = EKMaker.redAlertView(title: "위젯 삭제 완료!", subtitle: "삭제한 위젯은 잠금화면에서도 변경 또는 삭제 해주세요", named: "success.white")
                }

            }
        }
    }

    var listCell: some View {
        ZStack {
            HStack {
                if viewModel.isEditMode == .active {

                    Button {
                        isOn.toggle()
                    } label: {
                        if isOn {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.red)
                                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
                                .bold()
                        } else {
                            Image(systemName: "circle")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
                                .bold()
                        }
                    }
                }
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
                        .font(.custom(CustomFont.NotoSansKR.medium, size: 16))
                        .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.2, y: 0.5)

                    switch viewModel.checkLinkType(url: widget.url ?? "" ) {
                    case .app:
                        Text(self.app)
                            .font(.custom(CustomFont.NotoSansKR.regular ,size: 13))
                            .foregroundColor(.gray)
                            .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.2, y: 0.5)
                    case .web:
                        Text(self.web)
                            .font(.custom(CustomFont.NotoSansKR.regular ,size: 13))
                            .foregroundColor(.gray)
                            .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.2, y: 0.5)

                    }
                }
                Spacer()
                VStack {
                    // MARK: 실행 횟수
                    runCountView
                }
            }
            .frame(height: cellSize.list)

        }
    }

    var runCountView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.init(uiColor: .tertiarySystemFill))
                .frame(width: 70, height: 20)
                .shadow(color: .black.opacity(0.4), radius: 0.5, x: 0.2, y: 0.5)
                .opacity(0.7)
            Group {
                HStack(spacing: 2) {
                    Image(systemName: "bolt.horizontal.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .shadow(color: .black.opacity(0.7), radius: 0.5, x: 0.5, y: 0.5)
                        .foregroundColor(.yellow)
                    Text("\(Int(widget.runCount))")
                        .font(.system(size: 14, weight: .semibold))
                        .shadow(color: .black.opacity(0.6), radius: 0.5, x: 0.3, y: 0.5)
                }
                .foregroundStyle(Color.init(uiColor: .white))
            }
        }
    }


    func displayToast() {
        SwiftEntryKit.display(entry: deleteAlertView, using: EKMaker.redAlertAttribute)
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
