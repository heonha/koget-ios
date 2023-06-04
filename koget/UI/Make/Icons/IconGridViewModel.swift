//
//  IconGridViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/03.
//

import SwiftUI
import Combine
import SFSafeSymbols

final class IconGridViewModel: BaseViewModel {

    // Simple Icons
    @ObservedObject var manager = SimpleIconService()
    private var cancellables: Set<AnyCancellable>!
    @Published var simpleIcons = [UIImage]()

    @Published var searchText = ""
    @Published var icons = [(imgName: String, name: [String])]()
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
    
    private let aliasTuple: [(imgName: String, name: [String])] = {
        let alias = WidgetAssetViewModel().data
            .compactMap{ (imgName: $0.imageName, name: [$0.name, $0.nameEn, $0.nameEn]) }
        return alias
    }()
    
    override init() {
        selectedSource = 0
        super.init()
        cancellables = .init()
        fetchAllIcon()
        subscribing()
    }
    
    deinit {
        print("deinit: IconGridVeiwModel")
    }
    
    func subscribing() {
        manager.simpleIconPublisher
            .sink { icons in
                print("전달받은 아이콘")
                self.simpleIcons = icons
            }.store(in: &cancellables)
    }
    
}

extension IconGridViewModel {
    
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
    
    func filterSimpleIcons(text: String) {
        if text.isEmpty {
            manager.updateIcons()
        } else {
            manager.searchIcon(name: text) { image in
                if let image = image {
                    self.simpleIcons = [image]
                }
            }
        }
    }
    
    func fetchSimpleIcon() {
        print("아이콘 가져오기")
        manager.updateIcons()
        print(self.simpleIcons.count)
    }
    
    func disposeServices() {
        manager.cancel()
        cancellables = nil
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
