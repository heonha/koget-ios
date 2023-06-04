//
//  IconGridViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/03.
//

import SwiftUI
import SFSafeSymbols

final class IconGridViewModel: BaseViewModel {

    @Published var searchText = ""
    @Published var icons = [(imgName: String, name: [String])]()
    @Published var simpleIcons = [UIImage]()
    @Published var selectedSource: CGFloat {
        willSet {
            if newValue == 0 {
                self.searchText = ""
                self.fetchAllIcon()
            } else {
                self.searchText = ""
                self.fetchSimpleIcon()
            }
        }
    }

    @ObservedObject var manager = SimpleIconService()

    private let aliasTuple: [(imgName: String, name: [String])] = {
        let alias = WidgetAssetViewModel().data
            .compactMap{ (imgName: $0.imageName, name: [$0.name, $0.nameEn, $0.nameEn]) }
        return alias
    }()

    override init() {
        selectedSource = 0
        super.init()
        fetchAllIcon()
    }

}

extension IconGridViewModel {

    private func fetchAllIcon() {
        icons = aliasTuple
        manager.fetchSimpleIcon(of: 50)
        simpleIcons = manager.simpleIcon
    }

    func filterIcons(text: String) {
        if text.isEmpty {
            fetchAllIcon()
            return
        }

        self.icons = aliasTuple.filter { tuple in
            tuple.name.contains { name in
                name.lowercased().contains(text.lowercased())
            }
        }
    }

    private func fetchSimpleIcon() {
        print("아이콘 가져오기")
        manager.fetchSimpleIcon()
        simpleIcons = manager.simpleIcon
    }

}

#if DEBUG
struct IconGridViewModel_Previews: PreviewProvider {
    static var previews: some View {
        PhotoEditMenu(isEditingMode: .constant(true), viewModel: MakeWidgetViewModel())
        IconGridView(parentViewModel: MakeWidgetViewModel())
    }
}
#endif
