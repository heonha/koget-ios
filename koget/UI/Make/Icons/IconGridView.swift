//
//  IconGridView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/03.
//

import SwiftUI
import SFSafeSymbols
import SVGKit

struct IconGridView<V: VMPhotoEditProtocol>: View {

    @State private var cellCount: CGFloat = .zero
    @State private var scrollPosition: CGFloat = .zero
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
    var parentViewModel: V

    @State private var scrollViewProxy: ScrollViewProxy? = nil
    @ObservedObject private var viewModel = IconGridViewModel()
    @EnvironmentObject var appConstant: AppStateConstant
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            customSafeArea(height: 16)
            
            titleView()
            
            Divider()
                .padding(.horizontal)
            
            searchView()

            ScrollViewReader { proxy in
                segmentView()

                scrollView()
                    .onAppear {
                        self.scrollViewProxy = proxy
                    }
            }

            customSafeArea()
        }
        .ignoresSafeArea(edges: .bottom)
        .tint(AppColor.Label.second)
        .background(AppColor.Background.first)
        
    }
}

// MARK: - MainViews
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

    func segmentButton(name: String, select: IconGridType) -> some View {
        Button {
            viewModel.selectedSource = select
            withAnimation {
                self.scrollViewProxy?.scrollTo("top")
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(viewModel.selectedSource == select ? AppColor.kogetBlue : AppColor.Fill.second )
                    .cornerRadius(8)
                    .frame(height: 32)
                Text(name)
                    .foregroundColor(viewModel.selectedSource == select ? .white : AppColor.Label.second )
            }
        }
    }
    
    private func segmentView() -> some View {
        HStack {
            Spacer()

            segmentButton(name: "Simple Icons", select: .simpleIcons)

            Spacer()

            segmentButton(name: "앱 아이콘", select: .appIcons)

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
                                .onAppear {
                                    UITextField.appearance().clearButtonMode = .whileEditing
                                }
                        }
                    }
                    .padding(.horizontal, 16)
            }
        }
    }

    private var iconCellInLazyVGrid: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 12) {
                switch viewModel.selectedSource {
                case .appIcons:
                    ForEach(viewModel.icons.map{ $0.imgName }, id: \.self) { image in
                        imageCell(imageName: image)
                    }
                case .simpleIcons:
                    ForEach($viewModel.iconNames.wrappedValue, id: \.self) { name in
                        simpleIconCell(name: name)
                            .onAppear {
                                print("\(self.cellCount = CGFloat(viewModel.iconNames.count))")
                            }
                    }
                }
            }
            .background(
                GeometryReader { geometry in
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
    
    private func scrollView() -> some View {
        Group {
            ScrollView {
                VStack {
                    Divider()
                        .id("top")
                    iconCellInLazyVGrid
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                let maxY = viewModel.calculateScrollMinYPosition(cellCount: cellCount)
                let isLoadMore = viewModel.scrollBottomPositionCalculator(currentY: value, maxY: maxY)
                if isLoadMore {
                    if viewModel.isLoading == false {
                        viewModel.isLoading = true
                        viewModel.isShouldLoadImage.toggle()
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

    private func customSafeArea(height: CGFloat = 24) -> some View {
        Rectangle()
            .fill(AppColor.Background.first)
            .frame(height: height)
    }
    
}

// MARK: - Subviews
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
    
    private func simpleIconCell(name: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(appConstant.isDarkMode ? Color.white.opacity(0.27) : AppColor.Background.second)
                .shadow(color: Color.init(uiColor: .label).opacity(0.2), radius: 2, x: 1, y: 1)

            let url = viewModel.getSimpleIconsURL(iconName: name)

            AsyncImageView(url: url) {
                loadingView()
                    .frame(width: 32, height: 32)
            }
            .scaledToFit()
            .frame(width: 32, height: 32)
            .clipShape(Circle())
        }
        .onTapGesture {
            viewModel.getSelectedImage(name: name, target: parentViewModel)
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
