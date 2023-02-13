//
//  AppList.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/05.
//

import UIKit
import CoreData
import SwiftUI

final class LinkWidgetModel: ObservableObject {
    
    static let shared = LinkWidgetModel()
    
    /// 앱에 내장된 DeepLink의 목록입니다.
    var builtInApps: [LinkWidget] = []
    
    private init() {
        builtInApps = getWidgetData()
    }
    
    func getWidgetData() -> [LinkWidget] {

        
        let appData = "&Authenticator,구글OTP,Authenticator,googleauthenticator://,authenticator&캐시워크,캐시워크,Cash Walk,cashwalkapp://,cashwalk&Google Maps,구글맵스,Google Maps,googlemaps://,googlemaps&Instagram,인스타그램,Instagram,instagram://,instagram&카카오맵,카카오맵,Kakao Map,kakaomap://,kakaomap&카카오네비,카카오네비,Kakao Navi,kakaonavi://,kakaonavi&카카오페이,카카오페이,Kakao Pay,kakaopay://,kakaopay&Messenger,페이스북메신저,Messenger,fb-messenger-public://,messenger&모바일신분증,모바일신분증,Mobile ID,MobileID://,mobileid&NAVER,네이버,NAVER,naversearchapp://,naver&네이버 지도,네이버맵,Naver Map,navermap://,navermap&네이버페이,네이버페이,Naver Pay,naverpayapp://,naverpay&PASS by KT,패스,PASS by KT,ktAuth://,passapp&PASS by SKT,패스,PASS by SKT,tauthlink://,passapp&PASS by U+,패스,PASS by U+,uplusauth://,passapp&PAYCO,페이코,PAYCO,payco://,payco&신한플레이,신한플레이,shinhan play,shpayfan-touchpay://,shinhanplay&신한터치페이,신한터치페이,Shinhan TouchPay,shpayfan-touchpay://touch,shinhanplay&스타벅스,스타벅스,Starbucks,starbucks://,starbucks&Strava,스트라바,Strava,strava://,strava&TMAP,티맵,TMAP,tmap://,tmap&YouTube,유튜브,Youtube,youtube://,youtube&ChatGPT,챗지피티,ChatGPT,https://chat.openai.com,ChatGPT"
        
        
        // 구분자 처리
        let divideString = appData.components(separatedBy: "&")
        
        var apps: [LinkWidget] = []
        
        for str in divideString {
            let app = str.components(separatedBy: ",")
            
            if app == [""] {
                
            } else {
                
                let name = app[0]
                let nameKr = app[1]
                let nameEn = app[2]
                let url = app[3]
                let imageName = app[4]
                
                let canOpen = canOpenURL(url: url)
                let image = getImage(imageName: imageName)
                
                let myApp = LinkWidget(name: name, nameKr: nameKr, nameEn: nameEn, url: url, imageName: imageName, displayName: name, image: image, canOpen: canOpen)
                
                
                apps.append(myApp)
            }
        }
        return apps
    }
    
     func getImage(imageName: String) -> UIImage {
        return UIImage(named: imageName) ?? UIImage(named: "questionmark.circle")!
    }
    
    func getLocalName(appName: String, appNameEn: String) -> String {
        let langStr = Locale.current.language.languageCode?.identifier
        
        if langStr == "ko" { // 한국어라면 글로벌 네임을 보여줘라.
            return appName
        } else {
            return appNameEn
        }
    }
    
    
    private func canOpenURL(url: String) -> Bool {
        let url = URL(string: url)!
        
        // Info.plist 내 Queried URL Schemes (LSApplicationQueriesSchemes) Array에 등록한 URL만 확인가능
        // URL 등록이 되지 않았다면 설치되어 있더라도 permission ERROR이 발생하기 때문에 false를 return
        
        return UIApplication.shared.canOpenURL(url)
    }
    
}
