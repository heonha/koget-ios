//
//  IconGridView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/03.
//

import SwiftUI
import SFSafeSymbols

struct IconGridView<V: VMPhotoEditProtocol>: View {

    @ObservedObject private var viewModel = IconGridViewModel()
    @EnvironmentObject var appConstant: AppStateConstant
    var parentViewModel: V

    @Environment(\.dismiss) var dismiss

    @State var index = 0

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
        }
        .tint(AppColor.Label.second)
        .background(AppColor.Background.first)
    }
}

extension IconGridView {

    private func titleView() -> some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .frame(height: 24)

            HStack {
                Spacer()

                Text("아이콘 선택")
                    .bold()

                Spacer()
            }

        }

    }

    private func segmentView() -> some View {
        HStack {
            Spacer()
            Button {
                viewModel.selectedSource = 0
            } label: {
                Text("AppIcons")
            }

            Spacer()

            Button {
                viewModel.selectedSource = 1
            } label: {
                Text("SimpleIcons")
            }

            Spacer()

        }.frame(height: 50)
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
                                .font(.system(size: 16))
                                .foregroundColor(AppColor.Label.second)
                                .padding(.leading, 8)
                            TextField(" 아이콘 이름", text: $viewModel.searchText)
                                .frame(height: 22)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .textCase(.none)
                                .onChange(of: viewModel.searchText) { newValue in
                                    if !newValue.isEmpty {
                                        if viewModel.selectedSource == 0 {
                                            viewModel.filterIcons(text: newValue.lowercased())
                                        } else {
                                            viewModel.filterSimpleIcons(text: newValue.lowercased())
                                        }
                                    }

                                }
                        }
                    }
                    .padding(.horizontal, 16)
            }
        }
    }

    private func scrollView() -> some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {

                if viewModel.selectedSource == 0 {
                    ForEach(viewModel.icons.map{ $0.imgName }, id: \.self) { image in
                        imageCell(imageName: image)
                    }
                } else {
                    ForEach(viewModel.simpleIcons, id: \.self) { image in
                        imageCell(image: image)
                            .onAppear {
                                if image == viewModel.simpleIcons.last {
                                    if viewModel.searchText.isEmpty {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            print("Last!")
                                            viewModel.fetchSimpleIcon()
                                        }
                                    }
                                }
                            }
                    }
                }
            }
            .padding()
        }

    }

    private func scrollToBottom(scrollViewProxy: ScrollViewProxy) {
        // 스크롤뷰를 맨 아래로 스크롤합니다.
        scrollViewProxy.scrollTo(viewModel.simpleIcons.indices.last, anchor: .bottom)
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

    private func imageCell(image: UIImage) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(appConstant.isDarkMode ? Color.white.opacity(0.27) : AppColor.Background.second)
                .shadow(color: Color.init(uiColor: .label).opacity(0.2), radius: 2, x: 1, y: 1)

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
        }
        .onTapGesture {
            print(image.metadata)
            viewModel.getSelectedImage(name: image.metadata, target: parentViewModel)
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
