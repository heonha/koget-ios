//
//  PatchNoteList.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/20.
//

import SwiftUI
import WelcomeSheet
import QGrid
import SFSafeSymbols

struct PatchNote: Identifiable {
    let id: UUID = .init()
    let title: LocalizedStringKey
    let version: String
    let date: String
    let note: [SheetBody]
}

struct SheetBody {
    let id: UUID = .init()
    let systemName: SFSymbol
    let title: LocalizedStringKey
    let body: LocalizedStringKey
}

struct PatchNoteList: View {
    
    var patchNotes: [PatchNote] = [
        PatchNote(title: "1.1 버전 업데이트 소식", version: "1.1", date: "2023-02-21", note: [
            SheetBody(systemName: .listBulletRectanglePortrait, title: "리스트 보기 추가", body: "이제 메인화면 우측 상단 버튼을 누르면 보기를 전환 할 수 있어요."),
            SheetBody(systemName: .arrowUpBackwardSquareFill, title: "바로 실행하기", body: "메인화면에서 앱을 눌러보세요. 앱으로 바로 갈 수 있어요."),
            SheetBody(systemName: ._1Circle, title: "실행 횟수 확인", body: "링크를 통해 앱을 얼마나 실행했는지 기록되고, 자주 사용하는 앱이 상단으로 올라와요."),
            SheetBody(systemName: .photoCircle, title: "아이콘은 옵션", body: "위젯 생성시 아이콘이 없어도 생성할 수 있어요. 아이콘은 코젯 아이콘으로 생성됩니다.")

        ])
    ]
    
    let title: LocalizedStringKey = "업데이트 소식"
    
    var body: some View {
        
        ZStack {
            AppColor.Background.second
                .ignoresSafeArea()
            VStack {
                Divider()
                
                QGrid(patchNotes, columns: 1) { note in
                    
                    NavigationLink {
                        PatchNoteView(patchNote: note)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .background(AppColor.Background.first)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 4, y: 4)
                            Image("Koget")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.2)
                                VStack(alignment: .center, spacing: 4) {
                                    Text("업데이트 소식")
                                        .font(.system(size: 20, weight: .heavy))
                                        .shadow(radius: 1.5, x: 4, y: 4)
                                        .foregroundColor(.init("000000"))
                                    Divider()
                                        .frame(width: deviceSize.width / 2)
                                    Text("\(note.version) Ver.")
                                        .font(.system(size: 18, weight: .semibold))
                                        .shadow(radius: 1.5, x: 4, y: 4)
                                        .foregroundColor(.init("191919"))

                                }
                                .multilineTextAlignment(.leading)
                            
                        }
                        .padding(4)
                        .frame(width: deviceSize.width / 1.2, height: deviceSize.width / 2.5)
                    }
                }
            }
            .navigationTitle("업데이트 소식")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PatchNoteList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PatchNoteList()
        }
    }
}
