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
        ScrollView {
            VStack(spacing: 4) {
                ForEach(viewModel.notes) { note in
                    PatchNoteListCell(title: note.title, subtitle: note.subtitle, date: note.date.toFormat("yyyy-MM-dd"), lightFileName: note.lightFileName, darkFileName: note.darkFileName)
                }
                Spacer()
            }
            .navigationTitle("업데이트 소식")
        }
    }
}

struct NoticeList_Previews: PreviewProvider {
    static var previews: some View {
        PatchNoteList()
    }
}
