//
//  IconGridView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/03.
//

import SwiftUI
import SFSafeSymbols
import SVGKit

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

struct IconGridView<V: VMPhotoEditProtocol>: View {

    @ObservedObject private var viewModel = IconGridViewModel()
    @EnvironmentObject var appConstant: AppStateConstant
    @State private var cellCount: CGFloat = .zero
    @State private var scrollPosition: CGFloat = .zero
    @State private var iconIndex = 0
    var parentViewModel: V

    @Environment(\.dismiss) var dismiss

    var body: some View {

        VStack {
            Rectangle()
                .fill(.clear)
                .frame(height: 16)

            titleView()

            Divider()
                .padding(.horizontal)

            searchView()

            segmentView()

            scrollView()

            Rectangle()
                .fill(AppColor.Background.first)
                .frame(height: 24)
        }
        .ignoresSafeArea(edges: .bottom)
        .tint(AppColor.Label.second)
        .background(AppColor.Background.first)

    }
}

// MARK: MainViews
extension IconGridView {

    private func titleView() -> some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .frame(height: 24)

            HStack {
                Spacer()

                Text("아이콘 선택하기")
                    .bold()

                Spacer()
            }

        }

    }

    private func segmentView() -> some View {
        HStack {
            Spacer()
            Button {
                viewModel.selectedSource = .simpleIcons
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(viewModel.selectedSource == .simpleIcons ? AppColor.kogetBlue : AppColor.Fill.second )
                        .cornerRadius(8)
                        .frame(height: 32)
                    Text("Simple Icons")
                        .foregroundColor(viewModel.selectedSource == .simpleIcons ? .white : AppColor.Label.second )
                }
            }

            Spacer()

            Button {
                viewModel.selectedSource = .appIcons
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(viewModel.selectedSource == .appIcons ? AppColor.kogetBlue : AppColor.Fill.second )
                        .cornerRadius(8)
                        .frame(height: 32)
                    Text("앱 아이콘")
                        .foregroundColor(viewModel.selectedSource == .appIcons ? .white : AppColor.Label.second )
                }
            }

            Spacer()

        }
        .frame(height: 40)
        .padding(.horizontal)
    }

    private func searchView() -> some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .frame(height: 48)

            VStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColor.Fill.first)
                    .frame(height: 36)
                    .overlay {
                        HStack(spacing: 6) {
                            Image(systemSymbol: .magnifyingglass)
                                .font(.custom(.robotoRegular, size: 11))
                                .foregroundColor(AppColor.Label.second)
                                .padding(.leading, 8)
                            TextField(" 아이콘 이름", text: $viewModel.searchText)
                                .frame(height: 22)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .textCase(.none)
                                .onChange(of: viewModel.searchText) { newValue in
                                    if viewModel.selectedSource == .appIcons {
                                        viewModel.filterIcons(text: newValue.lowercased())
                                    } else {
                                        viewModel.searchSimpleIcons(text: newValue.lowercased())
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 16)
            }
        }
    }

    private func scrollView() -> some View {
        Group {
            ZStack {

                if viewModel.selectedSource == .simpleIcons {
                    if viewModel.isLoading == false {
                        VStack {
                            Spacer()
                            Image(systemName: "arrow.up")
                                .font(.custom(.robotoMedium, size: 16))
                            Button("당겨서 더 보기") {
                                    viewModel.fetchIconNames()
                            }
                                .font(.custom(.robotoMedium, size: 16))
                        }
                    }
                }

                ScrollView {
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
                    VStack {

                    LazyVGrid(columns: columns, spacing: 12) {

                        switch viewModel.selectedSource {
                        case .appIcons:
                            ForEach(viewModel.icons.map{ $0.imgName }, id: \.self) { image in
                                imageCell(imageName: image)
                            }
                        case .simpleIcons:
                            ForEach($viewModel.iconNames.indices, id: \.self) { nameIndex in
                                    imageCell(simpleIconName: viewModel.iconNames[nameIndex])
                                    .onAppear {
                                        print("\(self.cellCount = CGFloat(viewModel.iconNames.count))")
                                    }
                            }
                        }
                    }
                    .background(
                        GeometryReader { geometry in
                            let scrollViewHeight = geometry.size.height * 0.5
                            Color.clear
                                .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin.y)
                        })

                        if $viewModel.isLoading.wrappedValue {
                            ZStack {
                                loadingView(type: .loadingDot)
                                    .frame(width: 200, height: 100)
                            }
                            .frame(width: 100, height: 28)

                        }
                    }

                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    let maxY = viewModel.calculateScrollMinYPosition(cellCount: cellCount)

                    let result = viewModel.isScrollBottom(currentY: value, maxY: maxY)
                    if result {
                        if viewModel.isLoading == false {
                            viewModel.isLoading = true
                            HapticManager.shared.triggerHapticFeedback(style: .heavy)
                            viewModel.excuteLoadImage.toggle()
                        }
                    }
                    self.scrollPosition = value
                }
                .padding(.horizontal, 8)
                .animation(.interactiveSpring(response: 0.4,
                                              dampingFraction: 1.0,
                                              blendDuration: 0.5),
                           value: viewModel.selectedSource)
            }

        }
        .background(
            GeometryReader { geometry in
                Color.clear
                    .padding()
                    .onAppear {
                        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                            print("높이: \(geometry.size.height)")
                        }
                    }
            })
    }

}

// MARK: Subviews
extension IconGridView {

    private func loadingView(type: LottieFactory.AnimationType = .loading) -> some View {
        let lottieView = LottieFactory.create(type: type)
        lottieView.play()
        return LottieContainerView(animationView: lottieView)
    }

    private func imageCell(imageName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(appConstant.isDarkMode ? Color.white.opacity(0.27) : AppColor.Background.second)
                .shadow(color: Color.init(uiColor: .label).opacity(0.2), radius: 2, x: 1, y: 1)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
        }
        .onTapGesture {
            parentViewModel.image = UIImage(named: imageName)
            self.dismiss()
        }
        .frame(width: 64, height: 64)
    }

    private func imageCell(simpleIconName: String, isLast: Bool = false) -> some View {

        ZStack {

            RoundedRectangle(cornerRadius: 8)
                .fill(appConstant.isDarkMode ? Color.white.opacity(0.27) : AppColor.Background.second)
                .shadow(color: Color.init(uiColor: .label).opacity(0.2), radius: 2, x: 1, y: 1)
            let url = URL(string: "\(viewModel.baseUrl)\(simpleIconName)")

            AsyncImageView(url: url) {
                loadingView()
                    .frame(width: 32, height: 32)
            }
            .scaledToFit()
            .frame(width: 32, height: 32)
            .clipShape(Circle())
        }
        .onTapGesture {
            print(simpleIconName)
            viewModel.getSelectedImage(name: simpleIconName, target: parentViewModel)
            self.dismiss()
        }
        .frame(width: 64, height: 64)

    }

}

#if DEBUG
struct IconGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoEditMenu(isEditingMode: .constant(true), viewModel: MakeWidgetViewModel())
        IconGridView(parentViewModel: MakeWidgetViewModel())
            .environmentObject(AppStateConstant.shared)
    }
}
#endif
