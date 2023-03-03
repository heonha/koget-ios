//
//  PatchNoteView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/20.
//

import SwiftUI

struct PatchNoteView: View {
    
    var patchNote: PatchNote
    var symbolColor: Color = .blue
    
    var body: some View {
        ZStack {
            
            VStack {
                ZStack {
                    Image("Koget")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.2)
                    VStack {

                    Text("업데이트 소식")
                        .font(.system(size: 26, weight: .bold))
                        .shadow(radius: 1.5, x: 2, y: 2)
                    Text("\(patchNote.version) Ver.")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.init(uiColor: .secondaryLabel))
                    }
                    
                }
                .frame(height: 70)

                    VStack {
                        Divider()
                        ScrollView {

                        ForEach(patchNote.note, id: \.id) { note in
                            HStack {
                                
                                HStack {
                                    
                                    Image(systemName: note.systemName)
                                        .font(.system(size: 28))
                                        .foregroundStyle(Constants.kogetGradient)
                                        .padding(.horizontal, 8)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(note.title)
                                            .font(.system(size: 18, weight: .semibold))
                                        
                                        Text(note.body)
                                            .font(.system(size: 16))
                                            .foregroundColor(.init(uiColor: .secondaryLabel))
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                
                                Spacer()
                                
                            }
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            
                        }
                        
                        Spacer()
                    }
                    .background(Color.white)
                }
            }
        }
    }
}

// struct PatchNoteView_Previews: PreviewProvider {
//     static var previews: some View {
//         PatchNoteView(patchNote: PatchNote.init(title: "타이틀", version: "1.1", date: "2023-02-21", note: [SheetBody.init(systemName: "person.fill", title: "타이틀", body: "이곳에 내용을 입력해주세요. 이곳에 내용을 입력해주세요."),SheetBody.init(systemName: "person.fill", title: "타이틀", body: "이곳에 내용을 입력해주세요. 이곳에 내용을 입력해주세요."),SheetBody.init(systemName: "person.fill", title: "타이틀", body: "이곳에 내용을 입력해주세요. 이곳에 내용을 입력해주세요.")]))
//     }
// }
