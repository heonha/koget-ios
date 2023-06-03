//
//  AppList.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/05.
//

import UIKit
import CoreData
import SwiftUI

final class BaseWidgetService: ObservableObject {

    /// 앱에 내장된 DeepLink의 목록입니다.
    init() {

    }
    
    func getWidget() -> [LinkWidget] {

        var builtInApps = [LinkWidget]()

        // 구분자 처리

        let apps: [LinkWidget] = [
            .init(name: "Apple TV", nameKr: "애플TV", nameEn: "Apple TV", url: "videos://", imageName: "appletv"),
            .init(name: "Google Assistant", nameKr: "구글 어시스턴트", nameEn: "Assistant", url: "googleassistant://", imageName: "googleassistant"),
            .init(name: "Authenticator", nameKr: "구글OTP", nameEn: "Authenticator", url: "googleauthenticator://", imageName: "authenticator"),
            .init(name: "캐시워크", nameKr: "캐시워크", nameEn: "Cash Walk", url: "cashwalkapp://", imageName: "cashwalk"),
            .init(name: "Disney+", nameKr: "디즈니+", nameEn: "Disney+", url: "disneyplus://", imageName: "disneyplus"),
            .init(name: "facebook", nameKr: "페이스북", nameEn: "Facebook", url: "facebook://", imageName: "facebook"),
            .init(name: "나의 찾기", nameKr: "나의 찾기", nameEn: "Find My", url: "findmy://", imageName: "findmy"),
            .init(name: "Freeform", nameKr: "프리폼", nameEn: "FreeForm", url: "freeform://", imageName: "freeform"),
            .init(name: "GoodNotes", nameKr: "굿노트5", nameEn: "GoodNotes5", url: "goodnotes5://", imageName: "goodnotes5"),
            .init(name: "Google", nameKr: "구글", nameEn: "Google", url: "google://", imageName: "google"),
            .init(name: "Google Maps", nameKr: "구글맵스", nameEn: "Google Maps", url: "googlemaps://", imageName: "googlemaps"),
            .init(name: "건강", nameKr: "건강", nameEn: "Health", url: "x-apple-health://", imageName: "health"),
            .init(name: "Instagram", nameKr: "인스타그램", nameEn: "Instagram", url: "instagram://", imageName: "instagram"),
            .init(name: "카카오맵", nameKr: "카카오맵", nameEn: "Kakao Map", url: "kakaomap://", imageName: "kakaomap"),
            .init(name: "카카오네비", nameKr: "카카오네비", nameEn: "Kakao Navi", url: "kakaonavi://", imageName: "kakaonavi"),
            .init(name: "카카오페이", nameKr: "카카오페이", nameEn: "Kakao Pay", url: "kakaopay://", imageName: "kakaopay"),
            .init(name: "카카오톡", nameKr: "카카오톡", nameEn: "Kakao Talk", url: "kakaotalk://", imageName: "kakaotalk"),
            .init(name: "지도", nameKr: "지도", nameEn: "Maps", url: "maps://", imageName: "applemaps"),
            .init(name: "메모", nameKr: "메모", nameEn: "Memo", url: "mobilenotes://", imageName: "memo"),
            .init(name: "메시지", nameKr: "메시지", nameEn: "Messages", url: "messages://", imageName: "messages"),
            .init(name: "Messenger", nameKr: "페이스북메신저", nameEn: "Messenger", url: "fb-messenger-public://", imageName: "messenger"),
            .init(name: "모바일신분증", nameKr: "모바일신분증", nameEn: "Mobile ID", url: "MobileID://", imageName: "mobileid"),
            .init(name: "애플 뮤직", nameKr: "음악", nameEn: "Music", url: "musics://", imageName: "applemusic"),
            .init(name: "네이버", nameKr: "네이버", nameEn: "NAVER", url: "naversearchapp://", imageName: "naver"),
            .init(name: "네이버지도", nameKr: "네이버맵", nameEn: "Naver Map", url: "navermap://", imageName: "navermap"),
            .init(name: "네이버페이", nameKr: "네이버페이", nameEn: "Naver Pay", url: "naverpayapp://", imageName: "naverpay"),
            .init(name: "네이버웹툰", nameKr: "네이버웹툰", nameEn: "Naver Webtoon Kr", url: "fb455753897775430://", imageName: "naverwebtoon"),
            .init(name: "Netflix", nameKr: "넷플릭스", nameEn: "Netflix", url: "nflx://", imageName: "netflix"),
            .init(name: "Nike Run Club", nameKr: "나이키런클럽", nameEn: "Nike Run Club", url: "nikerunclub://", imageName: "nikerunclub"),
            .init(name: "PAYCO", nameKr: "페이코", nameEn: "PAYCO", url: "payco://", imageName: "payco"),
            .init(name: "Raddit", nameKr: "레딧", nameEn: "Raddit", url: "reddit://", imageName: "reddit"),
            .init(name: "신한플레이", nameKr: "신한플레이", nameEn: "shinhan play", url: "shpayfan-touchpay://", imageName: "shinhanplay"),
            .init(name: "신한터치페이", nameKr: "신한터치페이", nameEn: "Shinhan TouchPay", url: "shpayfan-touchpay://touch", imageName: "pay"),
            .init(name: "Spotify", nameKr: "스포티파이", nameEn: "Spotify", url: "spotify://", imageName: "spotify"),
            .init(name: "스타벅스", nameKr: "스타벅스", nameEn: "Starbucks", url: "starbucks://", imageName: "starbucks"),
            .init(name: "Strava", nameKr: "스트라바", nameEn: "Strava", url: "strava://", imageName: "strava"),
            .init(name: "TMAP", nameKr: "티맵", nameEn: "TMAP", url: "tmap://", imageName: "tmap"),
            .init(name: "Twitter", nameKr: "트위터", nameEn: "Twitter", url: "twitter://", imageName: "twitter"),
            .init(name: "Uber", nameKr: "우버", nameEn: "Uber", url: "uber://", imageName: "uber"),
            .init(name: "Wallet", nameKr: "월렛", nameEn: "Wallet", url: "wallet://", imageName: "wallet"),
            .init(name: "WhatsApp", nameKr: "왓츠앱", nameEn: "WhatApp", url: "whatsapp://", imageName: "whatsapp"),
            .init(name: "YouTube", nameKr: "유튜브", nameEn: "Youtube", url: "youtube://", imageName: "youtube"),
            .init(name: "chatGPT", nameKr: "chatGPT", nameEn: "chatGPT", url: "https://chat.openai.com/chat/", imageName: "chatgpt"),
            .init(name: "알뜰교통카드", nameKr: "알뜰교통카드", nameEn: "알뜰교통카드", url: "watc://", imageName: "watc"),
            // 23/03/31 추가
            .init(name: "당근마켓", nameKr: "당근마켓", nameEn: "Karrot", url: "daangn://", imageName: "daangn"),
            .init(name: "Kakao T", nameKr: "카카오T", nameEn: "Kakao T", url: "kakaot://", imageName: "kakaot"),
            .init(name: "Outlook", nameKr: "Outlook", nameEn: "Outlook", url: "ms-outlook://", imageName: "outlook"),
            .init(name: "리디", nameKr: "리디", nameEn: "RIDI", url: "ridi://", imageName: "ridiapp"),
            .init(name: "SNOW", nameKr: "SNOW", nameEn: "SNOW", url: "snowme://", imageName: "snowapp"),
            .init(name: "SODA", nameKr: "SODA", nameEn: "SODA", url: "soda://", imageName: "sodaapp"),
            .init(name: "후스콜", nameKr: "후스콜", nameEn: "Whoscall", url: "whoscall://", imageName: "whoscall"),
            .init(name: "스위치", nameKr: "스위치", nameEn: "Switch", url: "switchapp://", imageName: "switchapp"),
            .init(name: "현대카드", nameKr: "현대카드", nameEn: "Hyundai Card", url: "hyundaicardappcard://", imageName: "hyundaicard"),
            .init(name: "T전화", nameKr: "T전화", nameEn: "T전화", url: "tphone://", imageName: "tphone"),
            .init(name: "교보eBook", nameKr: "교보eBook", nameEn: "교보eBook", url: "kyoboebook://", imageName: "kyoboebook"),
            .init(name: "미세미세", nameKr: "미세미세", nameEn: "MiseMise", url: "misemise://", imageName: "misemise"),
            .init(name: "Raivo", nameKr: "Raivo", nameEn: "Raivo", url: "otpauth://", imageName: "raivo"),
            .init(name: "YouTube Music", nameKr: "유튜브뮤직", nameEn: "YouTube Music", url: "youtubemusic://", imageName: "youtubemusic"),
            .init(name: "토스", nameKr: "토스", nameEn: "Toss", url: "supertoss://", imageName: "toss"),
            .init(name: "예스24 eBook", nameKr: "예스24 eBook", nameEn: "YES24 eBook", url: "YES24EBOOK://", imageName: "yes24ebook"),
        ]

        for var app in apps {

            let displayName = getLocalName(appName: app.name, appNameEn: app.nameEn)
            let canOpen = canOpenURL(url: app.url)
            let image = getImage(imageName: app.imageName)

            app.displayName = displayName
            app.canOpen = canOpen
            app.image = image

            builtInApps.append(app)
        }

        builtInApps.sort { $0.displayName > $1.displayName }

        return builtInApps
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
