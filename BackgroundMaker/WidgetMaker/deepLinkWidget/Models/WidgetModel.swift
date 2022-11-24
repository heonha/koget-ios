//
//  AppList.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/05.
//

import UIKit
import CoreData
import SwiftUI

enum DeepLinkType {
    case builtIn
    case custom
}

/// DeepLinking 할 앱의 정보
struct BuiltInDeepLink {
    let id = UUID()
    var type: DeepLinkType
    var appID: String
    var displayAppName: String?
    var appNameGlobal: String
    var appName_ko: String
    var appName_en: String
    var deepLink: String
    var image: UIImage?
    
    mutating func getImage(imageName: String) {
        self.image = UIImage(named: "\(imageName)")
    }
    
    mutating func getName() {
        let langStr = Locale.current.language.languageCode?.identifier
        if langStr == "ko" {
            displayAppName = "\(appNameGlobal)"
            } else {
                displayAppName! += "(\(appName_en))"
            }
    }
}


struct CustomWidgetInfo {
    let id: UUID
    let name: String
    let image: Image?
    let text: String?
}

final class WidgetModel: ObservableObject {
    
    static let shared = WidgetModel()
    
    // MARK: [Todo] CoreData로 전환이 필요한지 검토해보기
    
    /// 앱에 내장된 DeepLink의 목록입니다.
    var builtInApps: [BuiltInDeepLink] = [
        
    ]
    
    
    var deepLinkApps: [DeepLink] = []


    private init() {
        builtInApps = getWidgetData()

    }

    
    func debugIntent(data: String) {
        print("DebugIntent: \(data)")
    }
    
    
    func getWidgetData() -> [BuiltInDeepLink] {
        
        let appData = "&youtubeMusic,YouTube Music,유튜브뮤직,Youtube Music,youtubemusic,youtubeMusic&youtube,YouTube,유튜브,Youtube,youtube,youtube&tphone,T전화,T전화,T전화,tphone,tphone&tmap,TMAP,티맵,TMAP,tmap,tmap&starbucks,스타벅스,스타벅스,Starbucks,starbucks,starbucks&shinhanTouchPay,신한터치페이,신한터치페이,Shinhan TouchPay,shpayfan-touchpay://touch,shinhanTouchPay&shinhanPlay,신한플레이,신한플레이,shinhan play,shpayfan-touchpay,shinhanPlay&payco,PAYCO,페이코,PAYCO,payco,payco&naver,네이버,네이버,Naver,naversearchapp,naver&naverPay,네이버페이,네이버페이,Naver Pay,naverpayapp,naverPay&naverMap,네이버지도,네이버지도,Naver Map,navermap,naverMap&kakaoTalk,카카오톡,카카오톡,Kakao Talk,kakaotalk,kakaoTalk&kakaoPay,카카오페이,카카오페이,Kakao Pay,kakaopay,kakaoPay&kakaoNavi,카카오네비,카카오네비,Kakao Navi,kakaonavi,kakaoNavi&kakaoMap,카카오맵,카카오맵,Kakao Map,kakaomap,kakaoMap&kakaoBank,카카오뱅크,카카오뱅크,Kakao Bank,kakaobank,kakaoBank&instagram,Instagram,인스타그램,Instagram,instagram,instagram&googlePhoto,Google 포토,구글포토,Google Photo,googlephoto,googlePhoto&googleMaps,Google Maps,구글지도,Google Maps,googlemaps,googleMaps&gmail,Gmail,지메일,Gmail,googlegmail,gmail&googleChrome,Chrome,구글 크롬,Chrome,googlechrome,googleChrome&googleOTP,Authenticator,구글 OTP,Authenticator,googleauthenticator,googleOTP&google,Google,Google,Google,google,google&strava,Strava,Strava,Strava,strava,strava&coupang,쿠팡,쿠팡,Coupang,coupang,coupang"
        
        
        let divideString = appData.components(separatedBy: "&")
        
        var apps: [BuiltInDeepLink] = []
        
        for str in divideString {
            let app = str.components(separatedBy: ",")
            
            if app == [""] {
                
            } else {
                var myApp = BuiltInDeepLink(type: .builtIn, appID: app[0], appNameGlobal: app[1], appName_ko: app[2], appName_en: app[3], deepLink: app[4])
                    myApp.getImage(imageName: app[0])
                    myApp.getName()
                    apps.append(myApp)
            }
        }
        return apps
    }
    
}




