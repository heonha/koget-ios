 //
 // NoticeList.swift
 // koget
 //
 // Created by Heonjin Ha on 2023/03/12.

import SwiftUI
import SwiftDate

struct PatchNoteList: View {

    @ObservedObject var viewModel = PatchNoteViewModel.shared

    var body: some View {
        Group {
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(viewModel.notes.reversed()) { note in
                        PatchNoteListCell(title: note.title, subtitle: note.subtitle, date: note.date.toFormat("yyyy-MM-dd"), lightFileName: note.lightFileName, darkFileName: note.darkFileName)
                    }
                    Spacer()
                }
                .navigationTitle(S.PatchnoteList.navigationTitle)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Text("\(S.kogetVersion) \(appVersion)")
                            .font(.custom(CustomFont.NotoSansKR.medium, size: 14))
                            .foregroundColor(AppColor.Label.second)
                    }
                }
            }
        }
    }
}

struct NoticeList_Previews: PreviewProvider {
    static var previews: some View {
        PatchNoteList()
    }
}
