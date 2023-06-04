//
//  SimpleIconManager.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/04.
//

import SwiftUI
import Combine
import SVGKit

struct SimpleIcons: Codable, Identifiable {
    var id: UUID? = UUID()
    let icons: [SimpleIcon]
}

struct SimpleIcon: Codable {
    let title: String
    let hex: String
    let source: String
    let license: [String: String]?
    let guidelines: String?
    let aliases: SimpleIconAKA?
}

struct SimpleIconAKA: Codable {
    let aka: [String]?
}

class SimpleIconService: ObservableObject {

    // TODO: 검색 기능 추가하시오
    // TODO: Combine Subject - Publisher - Subscriber 구조로 변경 하시오
    @Published var simpleIcon: [UIImage] = []
    private var simpleIconSubject: PassthroughSubject<[UIImage], Never> = .init()
    var simpleIconPublisher: AnyPublisher<[UIImage], Never> {
        return simpleIconSubject.eraseToAnyPublisher()
    }
    private var cancellables: Set<AnyCancellable>!

    private var iconNames: [String] = []
    private var startIndex = 0
    private let baseUrl = "https://cdn.simpleicons.org/"

    init() {
        cancellables = .init()
        getIconNames()
    }

    deinit {
        print("deinit: SimpleIconManager")
    }

    func updateIcons() {
        fetchSimpleIcon()
    }

    func cancel() {
        self.cancellables = nil
    }

    private func fetchSimpleIcon(of batchSize: Int = 20) {
        let endIndex = min(startIndex + batchSize, iconNames.count)
        let itemsToFetch = Array(iconNames[startIndex..<endIndex])
        for name in itemsToFetch {
            convertIcon(name: name) { image in
                if let image = image {
                    self.simpleIcon.append(image)
                }
            }
        }
        simpleIconSubject.send(self.simpleIcon)
        startIndex += batchSize
    }

    func convertIcon(name: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "\(baseUrl)\(name)") else { return }

        self.getSVGImage(url: url) { result in
                switch result {
                case .success(let image):
                    print("Success!")
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
                    self.fetchSimpleIcon(of: 120)
                    print("DEBUG: \(self.iconNames.count)")
                    break
                }
            }, receiveValue: { [weak self] receivedIcons in
                guard let self = self else { return }
                self.iconNames = receivedIcons.compactMap { $0.title }
            })
            .store(in: &cancellables)
    }

    private func getSVGImage(url: URL, name: String = "", size: CGSize = CGSize(width: 256, height: 256),
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
                    print("완료")
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
