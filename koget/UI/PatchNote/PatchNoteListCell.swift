//
//  NoticeList.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import SFSafeSymbols

struct PatchNoteListCell: View {

    let title: String
    let subtitle: String
    let date: String
    let lightFileName: String
    let darkFileName: String

    @State private var forwards = false
    @State var isPresent: Bool = false

    @EnvironmentObject var constant: AppStateConstant

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColor.Background.second)

            VStack {
                HStack {
                    textView(title: title, subtitle: subtitle)
                        .padding(8)
                    Spacer()

                    Text(date)
                        .font(.custom(.robotoLight, size: 14))
                        .foregroundColor(AppColor.Label.second)
                        .padding(.trailing)
                }

                if isPresent {
                    PatchNoteContentView(fileName: constant.isDarkMode ? darkFileName : lightFileName)
                        .opacity(isPresent ? 1 : 0)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .animation(.interactiveSpring(response: 0.4, dampingFraction: 1.0, blendDuration: 0.5), value: isPresent)
        .onTapGesture {
            isPresent.toggle()
        }
    }

    func textView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom(.robotoBold, size: 18))
            Text(subtitle)
                .font(.custom(.robotoLight, size: 14))
                .foregroundColor(AppColor.Label.second)
                .padding(.leading, 4)
        }
    }
}

struct PatchNoteListCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 4) {

            PatchNoteListCell(title: "Title", subtitle: "Subtitle", date: "Date", lightFileName: "lightFileName", darkFileName: "darkFileName")

            //             PatchNoteListCell(title: "업데이트 1.2", subtitle: "다크모드 등", date: "2023-00-00", url: "")
            //             PatchNoteListCell(title: "업데이트 1.1", subtitle: "리스트보기, 바로실행, 실행횟수 등", date: "2023-00-00", url: "")
        }
    }
}
