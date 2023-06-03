//
//  IconGridViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/03.
//

import SwiftUI
import SFSafeSymbols

final class IconGridViewModel: BaseViewModel {

    // TODO: Simple Icon 지원 추가.
    // TODO: Combine으로 선택한 이미지 데이터 전달.
    @Published var icons = [(imgName: String, name: [String])]()

    private let aliasTuple: [(imgName: String, name: [String])] = {
        let alias = WidgetAssetViewModel().data
            .compactMap{ (imgName: $0.imageName, name: [$0.name, $0.nameEn, $0.nameEn]) }
        return alias
    }()

    override init() {
        super.init()
        fetchAllIcon()
    }

    private func fetchAllIcon() {
        icons = aliasTuple
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

}
