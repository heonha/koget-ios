//
//  SimpleIconManager.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/04.
//

import SwiftUI
import Combine
import Kingfisher
import SFSafeSymbols

// TODO: 내부 JSON파싱
// [v] JSON파싱 만들기
// [v] 이름에 따른 색 불러오기
// [v] ImageGet하기
// [v] 아이콘으로 사용할 수 있도록 반영하기.

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
    private var iconNames: [String] = []

    private var startIndex = 0
    private let baseUrl = "https://cdn.simpleicons.org/"

    private var cancellables = Set<AnyCancellable>()

    init() {
        getIconNames()
    }

    deinit {
        print("deinit: SimpleIconManager")
    }

    func fetchSimpleIcon(of batchSize: Int = 20) {
        let endIndex = min(startIndex + batchSize, iconNames.count)
        let itemsToFetch = Array(iconNames[startIndex..<endIndex])
        for name in itemsToFetch {
            convertIcon(name: name)
        }
        startIndex += batchSize
    }

    func convertIcon(name: String) {
        guard let url = URL(string: "\(baseUrl)\(name)") else { return }
        DispatchQueue.global().async { [weak self] in
            SVGManager().getSVGImage(url: url, name: name) { image in
                if let image = image {
                    if image != UIImage() {
                        self?.simpleIcon.append(image)
                    }
                }
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
                    print("종료됨")
                    break
                }
            }, receiveValue: { [weak self] receivedIcons in
                guard let self = self else { return }
                self.iconNames = receivedIcons.compactMap { $0.title }
            })
            .store(in: &cancellables)
    }
}
