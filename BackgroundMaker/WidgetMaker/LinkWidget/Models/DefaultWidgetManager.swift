//
//  AppList.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/05.
//

import UIKit
import CoreData
import SwiftUI

final class DefaultWidgetManager: ObservableObject {
    
    static let shared = DefaultWidgetManager()
        
    /// 앱에 내장된 DeepLink의 목록입니다.
    var builtInApps: [LinkWidget] = []

    private init() {
        builtInApps = getWidgetData()
    }
    
    func getWidgetData() -> [LinkWidget] {
        
        let appData = "&YouTube Music,Youtube Music,youtubemusic://,youtubeMusic&YouTube,Youtube,youtube://,youtube&T전화,T전화,tphone://,tphone&TMAP,TMAP,tmap://,tmap&스타벅스,Starbucks,starbucks://,starbucks&신한터치페이,Shinhan TouchPay,shpayfan-touchpay://touch://,shinhanTouchPay&신한플레이,shinhan play,shpayfan-touchpay://,shinhanPlay&PAYCO,PAYCO,payco://,payco&네이버,NAVER,naversearchapp://,naver&네이버페이,Naver Pay,naverpayapp://,naverPay&네이버지도,Naver Map,navermap://,naverMap&카카오톡,Kakao Talk,kakaotalk://,kakaoTalk&카카오페이,Kakao Pay,kakaopay://,kakaoPay&카카오네비,Kakao Navi,kakaonavi://,kakaoNavi&카카오맵,Kakao Map,kakaomap://,kakaoMap&카카오뱅크,Kakao Bank,kakaobank://,kakaoBank&Instagram,Instagram,instagram://,instagram&Google 포토,Google Photo,googlephoto://,googlePhoto&Google Maps,Google Maps,googlemaps://,googleMaps&Gmail,Gmail,googlegmail://,gmail&Chrome,Chrome,googlechrome://,googleChrome&Authenticator,Authenticator,googleauthenticator://,googleOTP&Google,Google,google://,google&Strava,Strava,strava://,strava&쿠팡,Coupang,coupang://,coupang&Spotify,Spotify,spotify://,spotify&캐시워크,Cash Walk,cashwalkapp://,cashwalk"

        
        // 구분자 처리
        let divideString = appData.components(separatedBy: "&")
        
        var apps: [LinkWidget] = []
        
        for str in divideString {
            let app = str.components(separatedBy: ",")
            
            if app == [""] {
                
            } else {
                var myApp = LinkWidget(appName: app[0], appNameGlobal: app[1], url: app[2], imageName: app[3])
                    myApp.getImage(imageName: app[3])
                    myApp.getName()
                    apps.append(myApp)
            }
        }
        return apps
    }
    
}
