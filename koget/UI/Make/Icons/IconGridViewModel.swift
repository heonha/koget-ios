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

final class IconGridViewModel: ObservableObject {

    // Simple Icons
    private var cancellables: Set<AnyCancellable>!
    @Published var simpleIcons = [UIImage]()
    private var iconNames: [String] = []
    private var startIndex = 0
    private let baseUrl = "https://cdn.simpleicons.org/"

    @Published var searchText = ""
    @Published var icons = [(imgName: String, name: [String])]()
    @Published var selectedSource: CGFloat = 0 {
        willSet {
            if newValue == 0 {
                self.searchText = ""
                self.fetchAllIcon()
            } else {
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
        print("init")
        cancellables = .init()
        getIconNames()
        fetchAllIcon()
    }
    
    deinit {
        print("deinit: IconGridVeiwModel")
    }
    
}

extension IconGridViewModel {
    
    func fetchAllIcon() {
        icons = aliasTuple
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
    
    func filterSimpleIcons(text: String) {
        if text.isEmpty {
            return
        } else {
            searchIcon(name: text) { image in
                if let image = image {
                    self.simpleIcons = [image]
                }
            }
        }
    }
    
    func disposeServices() {
        cancellables = nil
    }

}

extension IconGridViewModel {

    // TODO: Infinity ScrollView로 로드하기 구현
    func searchIcon(name: String,
                    completion: @escaping (UIImage?) -> Void) {
        convertIcon(name: name) { image in
            completion(image)
        }
    }

    func fetchSimpleIcon(of batchSize: Int = 50) {
        let endIndex = min(startIndex + batchSize, iconNames.count)
        let itemsToFetch = Array(iconNames[startIndex..<endIndex])
        for name in itemsToFetch {
            convertIcon(name: name) { image in
                if let image = image {
                    self.simpleIcons.append(image)
                }
            }
        }
        startIndex += batchSize
    }

    func convertIcon(name: String, size: CGSize = CGSize(width: 64, height: 64),
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

    private func getIconNames() {

        print("아이콘 가져오기")

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
                    break
                }
            }, receiveValue: { [weak self] receivedIcons in
                guard let self = self else { return }
                self.iconNames = receivedIcons.compactMap { $0.title }
                self.fetchSimpleIcon(of: 100)
            })
            .store(in: &cancellables)
    }

    private func getSVGImage(url: URL, name: String = "",
                             size: CGSize,
                             completion: @escaping (Result<UIImage?, Error>) -> Void) {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .compactMap { (data: $0.data, response: $0.response as? HTTPURLResponse) }
            .filter{ $0.response?.statusCode == 200 }
            .compactMap { SVGKImage(data: $0.data) }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }, receiveValue: { svgImage in
                svgImage.size = size
                if let uiImage = svgImage.uiImage {
                    uiImage.metadata = name
                    completion(.success(uiImage))
                } else {
                    let error = NSError(domain: "ImageConversionError", code: 0, userInfo: nil)
                    completion(.failure(error))
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
