//
//  WidgetListCell.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import SFSafeSymbols

// TODO: GridView 메뉴 추가
// TODO: 드래그 앤 드롭기능 추가 -https://stackoverflow.com/questions/62606907/swiftui-using-ondrag-and-ondrop-to-reorder-items-within-one-single-lazygrid
// TODO: 편집 뷰 UI개선
// TODO: MakeView Flow로 진행하기
// TODO: 온보딩 추가
// TODO: 도움말 추가

struct WidgetListCell: View {

    let widget: DeepLink

    @State var expanded: Bool = false
    @State var isDeleting: Bool = false
    @State var horzdrag: CGFloat = 0
    @State var predictedEnd: CGFloat = 0
    @State var isDelete = false

    var name: String
    var url: String
    var widgetImage: UIImage
    var runCount: Int

    let app: String = S.WidgetCell.WidgetType.app
    let web: String = S.WidgetCell.WidgetType.web
    var imageSize = CGSize(width: 40, height: 40)
    let titleColor: Color = AppColor.Label.first

    @ObservedObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var appConstant: AppStateConstant
    @EnvironmentObject var coreData: WidgetCoreData
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    @Environment(\.dismiss) var dismiss

}

extension WidgetListCell {

    // 리스트 셀
    var body: some View {
        ZStack {

            VStack {
                HStack(spacing: 16) {
                    imageView

                    textVStack

                    Spacer()

                    HStack {
                        runCountView

                        Image(systemSymbol: .chevronRight)
                            .font(.custom(.robotoBold, size: 14))
                            .foregroundColor(AppColor.Label.second)
                            .rotationEffect(.degrees(expanded ? 90 : 0))
                    }
                }
                .frame(height: 58)
                .padding(.horizontal, 12)

                if expanded {

                    Spacer()

                        HStack {
                            actionButton(title: "실행") {
                                if let url = widget.url, let id = widget.id {
                                    viewModel.urlOpenedInApp(urlString: "\(WidgetConstant.mainURL)\(url)\(WidgetConstant.idSeparator)\(id.uuidString)")
                                }
                            }

                            actionButton(title: "편집") {
                                self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                                    DetailWidgetView(selectedWidget: widget)
                                })
                            }

                            actionButton(title: "삭제", isDelete: true) {
                                isDelete.toggle()
                            }
                            .alert("\(widget.name ?? "알수없는 위젯")", isPresented: $isDelete, actions: {
                                Button(S.Button.delete, role: .destructive) {
                                    coreData.deleteData(data: widget)
                                    dismiss()
                                    viewModel.displayAlertView()
                                    isDelete = false
                                }
                                Button(S.Button.cancel, role: .cancel) {
                                    isDelete = false
                                }
                            }, message: {
                                Text(S.Alert.Message.checkWidgetDelete)
                            })

                        }
                        .frame(height: 30)

                    Spacer()
                }
                
            }
            .background(.ultraThinMaterial)
        }
        .offset(x: isDeleting ? -400 : 0)
        .animation(.spring(), value: isDeleting)
        .transition(.move(edge: .leading))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    onDragChange(gesture: gesture)
                }
                .onEnded { _ in
                    onDragEnd()
                }
        )
        .cornerRadius(15)
        .onTapGesture {
            HapticManager.shared.triggerHapticFeedback(style: .rigid)
            withAnimation(.spring()) {
                expanded.toggle()
            }
        }
        .onLongPressGesture(perform: {
            HapticManager.shared.triggerHapticFeedback(style: .heavy)
            if let url = widget.url, let id = widget.id {
                viewModel.urlOpenedInApp(urlString: "\(WidgetConstant.mainURL)\(url)\(WidgetConstant.idSeparator)\(id.uuidString)")
            }
        })
        .frame(maxHeight: expanded ? 140 : 60)
        .clipped()
        .shadow(color: .black.opacity(0.25), radius: 1.5, x: 0.8, y: 0.7)
    }

    var buttonBg: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color(red: 1, green: 1, blue: 1).opacity(0.15))
    }

    private func onDragChange(gesture: DragGesture.Value) {
        horzdrag = gesture.translation.width
        predictedEnd = gesture.predictedEndTranslation.width
    }

    private func onDragEnd() {
        if getOffset(horzdrag: horzdrag) <= -400 {
            withAnimation(.spring()) {
                isDeleting = true
            }
        }

        horzdrag = .zero
    }

    // used to calculate how far to move the teal rectangle
    private func getOffset(horzdrag: CGFloat) -> CGFloat {
        if isDeleting {
            return -400
        } else if horzdrag < -165 {
            return -400
        } else if predictedEnd < -60 && horzdrag == 0 {
            return -80
        } else if predictedEnd < -60 {
            return horzdrag
        } else if predictedEnd < 50 && horzdrag > 0 && (-80 + horzdrag <= 0) {
            return -80 + horzdrag
        } else if horzdrag < 0 {
            return horzdrag
        } else {
            return 0
        }
    }

    private func actionButton(title: String, isDelete: Bool = false, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            ZStack {

                if isDelete {
                    AppColor.kogetRed
                        .cornerRadius(8)
                } else {
                    if appConstant.isDarkMode {
                        AppColor.GrayFamily.dark1
                            .cornerRadius(8)
                    } else {
                        AppColor.Label.second
                            .cornerRadius(8)
                    }
                }

                Text(title)
                    .font(.custom(.robotoMedium, size: 16))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 100, height: 30)
    }

    var imageView: some View {
        ZStack {
            Circle()
                .fill(AppStateConstant.shared.isDarkMode ? AppColor.Background.second : AppColor.Background.first)
                .shadow(color: .black.opacity(0.1), radius: 1.5, x: -0.3, y: -0.5)
                .shadow(color: .black.opacity(0.2), radius: 1.5, x: 0.3, y: 0.5)
            
            Image
                .uiImage(widgetImage)
                .resizable()
                .clipShape(Circle())
        }
        .frame(width: imageSize.width, height: imageSize.height)
    }

    var textVStack: some View {

        VStack(alignment: .leading, spacing: 4) {
            // title
            Text(name)
                .font(.custom(.robotoMedium, size: 16))
                .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.2, y: 0.5)
                .foregroundColor(AppColor.Label.first)

            // subtitle
            switch viewModel.checkLinkType(url: url) {
            case .app:
                Text(app)
                    .font(.custom(.robotoRegular ,size: 13))
                    .foregroundColor(Color.init(uiColor: .secondaryLabel))
                    .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.2, y: 0.5)
            case .web:
                Text(web)
                    .font(.custom(.robotoRegular ,size: 13))
                    .foregroundColor(Color.init(uiColor: .secondaryLabel))
                    .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.2, y: 0.5)
            }
        }
    }

    // 실행 횟수 카운터
    var runCountView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(AppColor.Fill.third.opacity(0.6))
                .frame(width: 70, height: 30)
                .shadow(color: .black.opacity(0.3), radius: 0.5, x: 0.3, y: 0.3)
                .overlay {
                    HStack(spacing: 6) {
                        Image(systemSymbol: .boltHorizontalFill)
                            .font(.custom(.robotoMedium, size: 11))
                            .shadow(color: .black.opacity(0.7), radius: 0.5, x: 0.5, y: 0.5)
                            .foregroundColor(.yellow)
                        Text("\(Int(runCount))")
                            .font(.custom(.robotoMedium, size: 14))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.8), radius: 0.3, x: 0.3, y: 0.5)
                    }
                }
        }
    }


}

struct WidgetListCell_Previews: PreviewProvider {
    static var previews: some View {
        WidgetListCell(widget: DeepLink.example, name: "이름", url: "https://google.com", widgetImage: UIImage(named: "Koget")!, runCount: 999, viewModel: MainWidgetViewModel())
            .padding(.horizontal, 8)
    }
}
