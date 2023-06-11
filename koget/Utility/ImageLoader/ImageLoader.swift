//
//  ImageLoader.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/11.
//

import SwiftUI
import Combine
import SVGKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL?

    private var cancellables: AnyCancellable?

    init(url: URL?) {
        self.url = url
    }

    deinit {
        cancel()
    }

    func load() {
        cancellables = URLSession.shared.dataTaskPublisher(for: url!)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0; print("imageProcessing") }
    }

    func loadSVG() {
        let size = CGSize(width: 64, height: 64)

        guard let url = self.url else { return }

        self.cancellables = URLSession.shared
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
            }, receiveValue: { [weak self] uiImage in
                if let resizedImage = uiImage.addClearBackground() {
                    self?.image = resizedImage
                }
            })
    }

    func cancel() {}
}
