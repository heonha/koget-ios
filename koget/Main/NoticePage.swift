//
//  NoticePage.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/03.
//

import SwiftUI

struct NoticePage: View {
    var frame: CGSize = .init(width: .zero, height: 110)

    let gridItem = [GridItem()]

    var body: some View {
        ZStack {
            TabView {
                NoticePageCell(named: "KogetLogo", frame: frame.height)
                NoticePageCell(systemName: "rectangle.and.pencil.and.ellipsis", frame: frame.height)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .frame(height: frame.height)
    }
}

struct NoticePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoticePage()
        }
    }
}

struct NoticePageCell: View {

    var named = ""
    var systemName = ""
    var frame: CGFloat
    var patchNotes: [PatchNote] = [
        PatchNote(title: "1.1 버전 업데이트 소식", version: "1.1", date: "2023-02-21", note: [
            SheetBody(systemName: "list.bullet.rectangle.portrait", title: "리스트 보기 추가", body: "이제 메인화면 우측 상단 버튼을 누르면 보기를 전환 할 수 있어요."),
            SheetBody(systemName: "arrow.up.backward.square.fill", title: "바로 실행하기", body: "메인화면에서 앱을 눌러보세요. 앱으로 바로 갈 수 있어요."),
            SheetBody(systemName: "1.circle", title: "실행 횟수 확인", body: "링크를 통해 앱을 얼마나 실행했는지 기록되고, 자주 사용하는 앱이 상단으로 올라와요."),
            SheetBody(systemName: "photo.circle", title: "아이콘은 옵션", body: "위젯 생성시 아이콘이 없어도 생성할 수 있어요. 아이콘은 코젯 아이콘으로 생성됩니다.")
        ])
    ]

    var body: some View {
        ZStack {
            NavigationLink {
                PatchNoteView(patchNote: patchNotes.first!)
            } label: {

                ZStack {
                    HStack {
                        Spacer()
                        Image(named)
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(1.5)
                        .opacity(0.2)
                        .padding(.leading, 30)
                    }

                HStack {
                    Spacer()
                    if !named.isEmpty {
                        // Image(named)
                        //     .resizable()
                        //     .scaledToFit()
                        //     .frame(width: frame, height: frame )
                        //     .padding(12)
                    } else if !systemName.isEmpty {
                        Image(systemName: systemName)
                            .font(.system(size: 40))
                            .padding(12)
                    }

                }

                HStack(content: {
                    VStack(alignment: .leading) {
                        Text("UPDATED 1.1")
                            .font(Font.custom("NotoSansKR-Bold", size: 18))
                        Text("새로워진 코젯 확인하기") 
                            .font(Font.custom("NotoSansKR-Light", size: 16))
                    }
                    .font(.system(size: 16, weight: .medium))
                    .padding(.leading)
                    Spacer()
                })
                }
                .frame(width: deviceSize.width - 48, height: frame * 0.9)

            }
        }
        .background(Color.init(uiColor: .secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
        .tint(.black)
        .padding(.horizontal)
    }
}
