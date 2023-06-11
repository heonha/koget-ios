//
//  IconGridViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/03.
//

import SwiftUI
import Combine
import SFSafeSymbols
import SVGKit

// TODO: SimpleIcons 검색기능 구현할 것
// TODO: segment전환할때 스크롤 맨위로 올리기
final class IconGridViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var isShouldLoadImage = false
    private var cancellables = Set<AnyCancellable>()

    // Simple Icons
    private var baseUrl = "https://cdn.simpleicons.org/"
    private var allNames = [String]()
    private var devidedNames = [[String]]()
    @Published var iconNames = [String]()
    var simpleIconNameIndex = 0

    @Published var searchText = "" {
        willSet {
            if newValue == "" {
                if selectedSource == .appIcons {
                    self.fetchAssetsIcon()
                }
            }
        }
    }
    @Published var icons = [(imgName: String, name: [String])]()
    @Published var selectedSource: IconGridType = .simpleIcons{
        willSet {
            switch newValue {
            case .simpleIcons:
                self.searchText = ""
            case .appIcons:
                self.searchText = ""
            }
        }
    }
    private let aliasTuple: [(imgName: String, name: [String])] = {
        let alias = BaseWidgetService().apps
            .compactMap{ (imgName: $0.imageName, name: [$0.name, $0.nameEn, $0.nameEn]) }
        return alias
    }()

    init() {
        cancellables = .init()
        subscribeLoadImage()
        getIconNames()
        fetchAssetsIcon()
    }
    
    deinit {
        print("deinit: IconGridVeiwModel")
    }

    private func subscribeLoadImage() {
        $isShouldLoadImage
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { [weak self] shouldExecute in
                if shouldExecute {
                    self?.fetchSimpleIconsName()
                }
            }
            .store(in: &cancellables)
    }

    func disposeServices() {
        cancellables = .init()
    }

}

// MARK: - App Icons
extension IconGridViewModel {

    func searchIcon(name: String, completion: @escaping (UIImage?) -> Void) {
        getSvgImageToUIImage(name: name) { image in
            completion(image)
        }
    }

    func filterIcons(text: String) {
        if text.isEmpty {
            return
        }

        self.icons = aliasTuple.filter { tuple in
            tuple.name.contains { name in
                name.lowercased().contains(text.lowercased())
            }
        }
    }

    private func fetchAssetsIcon() {
        icons = aliasTuple
    }

}

// MARK: - SimpleIcons
extension IconGridViewModel {

    func getSimpleIconsURL(iconName: String) -> URL? {
       return URL(string: "\(baseUrl)\(iconName)")
    }

    func searchSimpleIcons(text: String) {
        if text.isEmpty {
            return
        } else {
            iconNames = []
            iconNames = allNames.filter{ $0.contains(text)}
        }
    }

    func getSelectedImage(name: String, target: any VMPhotoEditProtocol) {
        self.getSvgImageToUIImage(name: name,
                                  size: CGSize(width: 192, height: 192),
                                  completion: { image in
            if let image = image {
                target.image = image
            } else {
                target.image = UIImage(systemName: "autostartstop.trianglebadge.exclamationmark")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
            }
        })
    }

    private func fetchSimpleIconsName() {
        if simpleIconNameIndex == devidedNames.endIndex { return }
        if !searchText.isEmpty { return }
        let names = self.devidedNames[self.simpleIconNameIndex]

        self.iconNames += names
        self.simpleIconNameIndex += 1

        self.isLoading = false
        self.isShouldLoadImage = false
    }
}

// MARK: - View Calculators
extension IconGridViewModel {

    func scrollBottomPositionCalculator(currentY: CGFloat, maxY: CGFloat) -> Bool {
        let comparePositionPercent = -(currentY) / maxY - 1.0
        let limit = -0.3

        if comparePositionPercent >= limit {
            return true
        } else {
            return false
        }
    }

    func calculateScrollMinYPosition(cellCount: CGFloat,
                                     spacing: CGFloat = 12,
                                     cellHeight: CGFloat = 64) -> CGFloat {

        let numberOfCellsPerRow = CGFloat(Int(ceil(Double(cellCount) / 4.0)))
        let a = (spacing * numberOfCellsPerRow) - spacing
        let b = (cellHeight * numberOfCellsPerRow)
        let scrollViewHeight = Constants.deviceSize.height * 0.67 // ScrollView대비 보이는 높이 px

        return (a + b - scrollViewHeight)
    }
}

// MARK: - ImageProcessing
extension IconGridViewModel {

    private func getIconNames() {
        let urlString = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/_data/simple-icons.json"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .compactMap { $0.data }
            .decode(type: SimpleIcons.self, decoder: JSONDecoder())
            .compactMap { $0.icons }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    self.fetchSimpleIconsName()
                    break
                }
            }, receiveValue: { [weak self] receivedIcons in
                let names = receivedIcons.compactMap { $0.title.replaceOnlyAlphabetAndNumbers() }
                self?.allNames = names
                self?.devidedNames = names.chunked(into: 50)
            })
            .store(in: &cancellables)
    }

    private func getSvgImageToUIImage(name: String, size: CGSize = CGSize(width: 64, height: 64),
                                      completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "\(baseUrl)\(name)") else { return }

        self.getSVGImage(url: url, name: name, size: size) { result in
            switch result {
            case .success(let image):
                if let image = image {
                    completion(image)
                }
            case .failure(let error):
                print("Error")
                print("SVG File Get Error : \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    private func getSVGImage(url: URL, name: String = "",
                             size: CGSize,
                             completion: @escaping (Result<UIImage?, Error>) -> Void) {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .compactMap { (data: $0.data, response: $0.response as? HTTPURLResponse) }
            .filter{ $0.response?.statusCode == 200 }
            .compactMap { SVGKImage(data: $0.data) }
            .compactMap { svgImage in
                svgImage.size = size
                return svgImage.uiImage
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }, receiveValue: { uiImage in
                if let resizedImage = uiImage.addClearBackground() {
                    resizedImage.metadata = name
                    completion(.success(resizedImage))
                }
            })
            .store(in: &cancellables)
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
