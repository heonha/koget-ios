 //
 // NoticeList.swift
 // koget
 //
 // Created by Heonjin Ha on 2023/03/12.

import SwiftUI

struct PatchNoteList: View {

    @ObservedObject var viewModel = PatchNoteViewModel.shared

    @State var appStoreVersion = "0.0.0"

    var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(AppColor.Background.third)
                    .frame(height: 60)
                    .overlay {
                        appVersionLabel()
                    }
                    .padding(.bottom, 12)

                ScrollView {
                    VStack(spacing: 6) {
                        ForEach(viewModel.notes) { note in
                            PatchNoteListCell(title: note.title,
                                              subtitle: note.subtitle,
                                              date: note.date.string,
                                              lightFileName: note.lightFileName,
                                              darkFileName: note.darkFileName)
                        }
                        Spacer()
                    }
                    .navigationTitle(S.PatchnoteList.navigationTitle)
                }
                .background(Color.init(uiColor: .systemBackground))
                .navigationBarTitleDisplayMode(.large)

        }
        .padding(.horizontal, 8)

    }

    func appVersionLabel() -> some View {
        VStack(spacing: 4) {
            HStack {
                Text("\("현재 버전  ")")
                    .font(.custom(CustomFont.NotoSansKR.medium, size: 14))
                    .foregroundColor(AppColor.Label.second)
                + Text("\(Constants.appVersion)")
                    .font(.custom(CustomFont.NotoSansKR.bold, size: 14))
                    .foregroundColor(AppColor.Label.second)
                Text("\("최신 버전  ")")
                    .font(.custom(CustomFont.NotoSansKR.medium, size: 14))
                    .foregroundColor(AppColor.Label.second)
                + Text("\(appStoreVersion)")
                    .font(.custom(CustomFont.NotoSansKR.bold, size: 14))
                    .foregroundColor(AppColor.Label.second)

            }

            if Constants.appVersion == appStoreVersion {
                Text("현재 최신버전을 사용 중입니다.")
                    .font(.custom(CustomFont.NotoSansKR.medium, size: 14))
                    .foregroundColor(.init(uiColor: .systemGreen))
            }

        }
        .onAppear {
            AppStoreService().fetchAppStoreVersion { version in
                self.appStoreVersion = version ?? "??"
            }
        }
    }
}

struct NoticeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PatchNoteList()
        }
    }
}
