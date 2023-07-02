//
//  WidgetListCell.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import SFSafeSymbols

// TODO: - 1.3버전 계획
// [] 편집 뷰 UI개선
// [] MakeView Flow로 진행하기
// [] 온보딩 추가
// [] 도움말 추가
// [] 드래그 앤 드롭기능 추가 -https://stackoverflow.com/questions/62606907/swiftui-using-ondrag-and-ondrop-to-reorder-items-within-one-single-lazygrid

struct WidgetListCell: View {
    
    private let widget: DeepLink
    
    private var name: String = ""
    private var url: String = ""
    private var image: UIImage = UIImage()
    private var runCount: Int = 0
    
    @State private var runDeepLink: Bool = false
    @State private var showDeleteAlert = false
    @State private var showEditSheet = false
    @State private var offsetX: CGFloat = .zero
    @State private var currentDragOffsetX: CGFloat = 0
    @State private var isSlideMode = false
    
    private let app: String = S.WidgetCell.WidgetType.app
    private let web: String = S.WidgetCell.WidgetType.web
    private var imageSize = CGSize(width: 40, height: 40)
    private let titleColor: Color = AppColor.Label.first
    
    @ObservedObject private var viewModel: MainWidgetViewModel
    @EnvironmentObject private var appConstant: AppStateConstant
    @EnvironmentObject private var coreData: WidgetCoreData
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @Environment(\.dismiss) private var dismiss
    
    init(widget: DeepLink, viewModel: MainWidgetViewModel) {
        self.widget = widget
        self.viewModel = viewModel
        self.name = widget.name ?? ""
        self.url = widget.url ?? ""
        let imageData = widget.image ?? Data()
        self.image = UIImage(data: imageData) ?? CommonImages.emptyIcon
    }
    
}

extension WidgetListCell {
    
    var body: some View {
        ZStack {
            mainBody
                .offset(x: offsetX)
            HStack {
                Spacer()
                
                Button {
                    viewModel.editTarget = widget
                    withAnimation(.easeIn) {
                        viewModel.isPresentEditSheet.toggle()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "FFE4A7"))

                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 27))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 60)

                Button {
                    showDeleteAlert.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "FEA1A1"))

                        Image(systemName: "xmark.octagon.fill")
                            .font(.system(size: 27))
                            .foregroundColor(.white)
                    }

                }
                .frame(width: 60)
                .alert("\(widget.name ?? "알수없는 위젯")", isPresented: $showDeleteAlert, actions: {
                    Button(S.Button.delete, role: .destructive) {
                        coreData.deleteData(data: widget)
                        dismiss()
                        viewModel.displayAlertView()
                        showDeleteAlert = false
                    }
                    Button(S.Button.cancel, role: .cancel) {
                        showDeleteAlert = false
                    }
                }, message: {
                    Text(S.Alert.Message.checkWidgetDelete)
                })
            }
//            .offset(x: offsetX + 150)
        }
        .frame(height: 60)
        .gesture(
            DragGesture(minimumDistance: 30)
                .onChanged { value in
                    let changedOffset = value.translation.width
                        withAnimation(.spring()) {
                            offsetX = changedOffset
                        }
                    print(changedOffset)
                }
                .onEnded { value in
                    if value.translation.width < -70 {
                        withAnimation(.spring()) {
                            offsetX = -150
                        }
                    }
                    else {
                        withAnimation(.spring()) {
                            offsetX = .zero
                        }
                    }
                    
                }
        )
        .gesture(
            LongPressGesture()
                .onChanged { Bool in
                    print("On Changed!")
                }
                .onEnded { value in
                    HapticManager.shared.triggerHapticFeedback(style: .heavy)
                    
                    if let url = widget.url, let id = widget.id {
                        viewModel.urlOpenedInApp(urlString: "\(WidgetConstant.mainURL)\(url)\(WidgetConstant.idSeparator)\(id.uuidString)")
                    }
                }
        )

    }
    
    // 리스트 셀
    private var mainBody: some View {
        ZStack {
            VStack {
                HStack(spacing: 16) {
                    imageView(with: image)
                    
                    textVStack(name: name)
                    
                    Spacer()
                    
                    runCountView(with: runCount)
                }
                .frame(height: 58)
                .padding(.horizontal, 12)
            }
            .background(appConstant.isDarkMode ? AppColor.Background.second : AppColor.Background.first)
        }
        .cornerRadius(15)
        .clipped()
        .shadow(color: .black.opacity(0.12), radius: 2, x: 0.8, y: 0.2)
    }
    
    private func actionButton(title: String,
                              isDelete: Bool = false,
                              action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            ZStack {
                if appConstant.isDarkMode {
                    AppColor.GrayFamily.dark1
                        .cornerRadius(8)
                } else {
                    AppColor.Label.second
                        .cornerRadius(8)
                }
                
                Text(title)
                    .font(.custom(.robotoMedium, size: 16))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 100, height: 30)
    }
    
    private func imageView(with image: UIImage) -> some View {
        ZStack {
            Circle()
                .fill(AppStateConstant.shared.isDarkMode ? AppColor.Background.second : AppColor.Background.first)
                .shadow(color: .black.opacity(0.1), radius: 1.5, x: -0.3, y: -0.5)
                .shadow(color: .black.opacity(0.2), radius: 1.5, x: 0.3, y: 0.5)
            
            Image
                .uiImage(image)
                .resizable()
                .clipShape(Circle())
        }
        .frame(width: imageSize.width, height: imageSize.height)
    }
    
    private func textVStack(name: String) -> some View {
        
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
    private func runCountView(with runCount: Int) -> some View {
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
                        Text("\(runCount)")
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
        WidgetListCell(widget: DeepLink.example, viewModel: MainWidgetViewModel())
            .padding(.horizontal, 8)
            .environmentObject(AppStateConstant.shared)
            .environmentObject(WidgetCoreData.shared)
        
    }
}
