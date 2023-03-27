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
    @EnvironmentObject var constant: Constants

    var body: some View {
        VStack {
            HStack {
                textView(title: title, subtitle: subtitle)
                    .padding(8)
                Spacer()

                Text(date)
                    .font(.custom(CustomFont.NotoSansKR.light, size: 14))
                    .foregroundColor(AppColor.Label.second)
                    .padding(.trailing)
            }
            .background(AppColor.Background.second)

            if isPresent {
                PatchNoteContentView(fileName: constant.isDarkMode ? darkFileName : lightFileName)
            }
        }
        .onTapGesture {
            isPresent.toggle()
        }
        .animation(.interactiveSpring(), value: isPresent) // 애니메이션 적용
    }

    func textView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom(CustomFont.NotoSansKR.bold, size: 18))
            Text(subtitle)
                .font(.custom(CustomFont.NotoSansKR.light, size: 14))
                .foregroundColor(AppColor.Label.second)
                .padding(.leading, 4)
        }
    }
}
// 
// struct PatchNoteListCell_Previews: PreviewProvider {
//     static var previews: some View {
//         VStack(spacing: 4) {
//             PatchNoteListCell(title: "업데이트 1.2", subtitle: "다크모드 등", date: "2023-00-00", url: "")
//             PatchNoteListCell(title: "업데이트 1.1", subtitle: "리스트보기, 바로실행, 실행횟수 등", date: "2023-00-00", url: "")
//         }
//     }
// }
