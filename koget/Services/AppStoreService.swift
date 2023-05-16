//
//  AppStoreReviewable.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/28.
//

import Foundation
import StoreKit

protocol AppStoreServiceProtocol {
    func requestReview()
}

class AppStoreService {
    var appStoreVersion: String = ""

    init() {
        fetchAppStoreVersion { version in
            self.appStoreVersion = version ?? ""
        }
    }

    func requestReview() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        if let windowScene = windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }

    func fetchAppStoreVersion(completion: @escaping (String?) -> Void) {
        let appID = "com.heon.koget"
        let storeInfoURL = URL(string: "https://itunes.apple.com/lookup?bundleId=\(appID)")

        URLSession.shared.dataTask(with: storeInfoURL!) { (data, response, error) in
            if let data = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let resultsArray = result?["results"] as? [[String: Any]], let appStoreVersion = resultsArray.first?["version"] as? String {
                        completion(appStoreVersion)
                    }
                } catch {
                    print("Data Task Error: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                print("데이터가 없음")
                completion(nil)
            }
        }.resume()

    }
}
