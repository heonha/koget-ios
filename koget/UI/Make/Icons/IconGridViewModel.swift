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

// TODO: 검색기능 구현할 것
final class IconGridViewModel: ObservableObject {

    // 스크롤 맨아래 감지
    // view의 특정 조건 일치하면 viewModel에 알린다 -> viewModel에서 특정 메소드 실행 (3초 내 동시 요청 무시한다.)
    @Published var excuteLoadImage = false
    private var cancellables: Set<AnyCancellable>!

    // -> 메소드 실행 -> 데이터 Array에 UIImage로 저장

    // Simple Icons
    @Published var iconNames = [String]()
    private var allNames = [String]()
    @Published var devidedNames = [[String]]()
    var namesIndex = 0 {
        willSet {
            print("INDEX: \(newValue)")
        }
    }

    var baseUrl = "https://cdn.simpleicons.org/"
    @Published var isLoading = false
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

    private var resultSubject: PassthroughSubject<CGFloat, Never> = .init()
    var resultPublisher: AnyPublisher<CGFloat, Never> {
        return resultSubject.eraseToAnyPublisher()
    }
    
    private let aliasTuple: [(imgName: String, name: [String])] = {
        let alias = BaseWidgetService().apps
            .compactMap{ (imgName: $0.imageName, name: [$0.name, $0.nameEn, $0.nameEn]) }
        return alias
    }()
    
    init() {
        print("init")
        cancellables = .init()

        $excuteLoadImage
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { [weak self] shouldExecute in
                if shouldExecute {
                    self?.fetchIconNames()
                }
            }
            .store(in: &cancellables)

        getIconNames()
        fetchAssetsIcon()
    }
    
    deinit {
        print("deinit: IconGridVeiwModel")
    }
    
}

extension IconGridViewModel {
    
    func fetchAssetsIcon() {
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

    func searchSimpleIcons(text: String) {
        if text.isEmpty {
            return
        } else {
            iconNames = []
            iconNames = allNames.filter{ $0.contains(text)}
        }
    }
    
    func disposeServices() {
        cancellables = nil
    }

}

extension IconGridViewModel {

    func isScrollBottom(currentY: CGFloat, maxY: CGFloat) -> Bool {
        print("isScrollBottom: \((-(currentY) / maxY - 1.0))")
        let result = -(currentY) / maxY - 1.0

        let deviceType = UIDevice.current.deviceType()

        var limit = -0.3

        if result >= limit { // 일반적인 당김 0.10 ~ 0.25정도
            return true
        } else {
            return false
        }
    }

    // Calculate Scoll Y Position
    func calculateScrollMinYPosition(cellCount: CGFloat,
                                     spacing: CGFloat = 12,
                                     cellHeight: CGFloat = 64) -> CGFloat {

        let numberOfCellsPerRow = CGFloat(Int(ceil(Double(cellCount) / 4.0))) // 한 행에 표시될 셀의 수
        let a = (spacing * numberOfCellsPerRow) - spacing
        let b = (cellHeight * numberOfCellsPerRow)
        let scrollViewHeight = Constants.deviceSize.height * 0.67// 약 0.67이 스크롤 맨 아래.
        print("DEBUG: \(scrollViewHeight)")

        return (a + b - scrollViewHeight)

    }

    func searchIcon(name: String,
                    completion: @escaping (UIImage?) -> Void) {
        getSvgImageToUIImage(name: name) { image in
            completion(image)
        }
    }

    func fetchIconNames() {
        if namesIndex == devidedNames.endIndex { return }
        if !searchText.isEmpty { return }
        print("Fetch Icons Called")
        let names = self.devidedNames[self.namesIndex]

        self.iconNames += names
        self.namesIndex += 1

        self.isLoading = false
        self.excuteLoadImage = false

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

    private func convertUIImage(from svgImage: SVGKImage,
                                imageName: String? = "") -> UIImage? {

        if let uiImage = svgImage.uiImage {
            if let resizedImage = uiImage.addClearBackground() {
                resizedImage.metadata = imageName!
                return resizedImage
            } else {
                return nil
            }
        } else {
            return nil
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
                    self.fetchIconNames()
                    break
                }
            }, receiveValue: { [weak self] receivedIcons in
                guard let self = self else { return }
                let names = receivedIcons.compactMap { $0.title.cleanedString() }
                self.allNames = names
                self.devidedNames = names.chunked(into: 50)
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

extension String {

    func cleanedString() -> String {
        return self.replacingOccurrences(of: "[^a-zA-Z0-9]", with: "").replacingOccurrences(of: " ", with: "")
    }

}
