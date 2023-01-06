//
//  AppList.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/05.
//

import UIKit
import CoreData
import SwiftUI

final class LinkWidgetManager: ObservableObject {
    
    static let shared = LinkWidgetManager()
    
    /// 앱에 내장된 DeepLink의 목록입니다.
    var builtInApps: [LinkWidget] = []
    
    private init() {
        builtInApps = getWidgetData()
    }
    
    func getWidgetData() -> [LinkWidget] {
        
        let appData = "&사진,Photos,photos-redirect://,photos&YouTube Music,Youtube Music,youtubemusic://,youtubeMusic&YouTube,Youtube,youtube://,youtube&T전화,T전화,tphone://,tphone&TMAP,TMAP,tmap://,tmap&스타벅스,Starbucks,starbucks://,starbucks&신한터치페이,Shinhan TouchPay,shpayfan-touchpay://touch://,shinhanTouchPay&신한플레이,shinhan play,shpayfan-touchpay://,shinhanPlay&PAYCO,PAYCO,payco://,payco&네이버,NAVER,naversearchapp://,naver&네이버페이,Naver Pay,naverpayapp://,naverPay&네이버지도,Naver Map,navermap://,naverMap&카카오톡,Kakao Talk,kakaotalk://,kakaoTalk&카카오페이,Kakao Pay,kakaopay://,kakaoPay&카카오네비,Kakao Navi,kakaonavi://,kakaoNavi&카카오맵,Kakao Map,kakaomap://,kakaoMap&카카오뱅크,Kakao Bank,kakaobank://,kakaoBank&Instagram,Instagram,instagram://,instagram&Google 포토,Google Photo,googlephoto://,googlePhoto&Google Maps,Google Maps,googlemaps://,googleMaps&Gmail,Gmail,googlegmail://,gmail&Chrome,Chrome,googlechrome://,googleChrome&Authenticator,Authenticator,googleauthenticator://,googleOTP&Google,Google,google://,google&Strava,Strava,strava://,strava&쿠팡,Coupang,coupang://,coupang&Spotify,Spotify,spotify://,spotify"
        
        
        // 구분자 처리
        let divideString = appData.components(separatedBy: "&")
        
        var apps: [LinkWidget] = []
        
        for str in divideString {
            let app = str.components(separatedBy: ",")
            
            if app == [""] {
                
            } else {
                
                let appName = app[0]
                let appNameEn = app[1]
                let url = app[2]
                let imageName = app[3]
                let canOpen = canOpenURL(url: url)
                let image = getImage(imageName: imageName)
                let name = getLocalName(appName: appName, appNameEn: appNameEn)
                
                let myApp = LinkWidget(
                    appName: appName,
                    appNameEn: appNameEn,
                    url: url,
                    displayName: name,
                    image: image,
                    canOpen: canOpen
                )
                
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
