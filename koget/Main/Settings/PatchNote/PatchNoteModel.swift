//
//  PatchNoteModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import FirebaseFirestore
import SwiftDate

struct PatchNoteData: Codable, Identifiable {
    var id: UUID = UUID()
    let title: String
    let subtitle: String
    let url: String
    let date: Date
}

struct PatchNoteModel {

    let language = Locale.current.language.languageCode?.identifier

    let dbref: CollectionReference

    init() {
        if self.language == "ko" {
            self.dbref = Firestore.firestore().collection("patchnote")
        } else {
            self.dbref = Firestore.firestore().collection("patchnote-en")
        }
    }

    func fetchDate(completion: @escaping([PatchNoteData]? , Error?) -> Void) {
        dbref.getDocuments { snapshot, error in

            var noteArray = [PatchNoteData]()
            if let error = error {
                completion(nil, error)
            } else if let documents = snapshot?.documents {
                for document in documents {
                    let title = document["title"] as? String ?? "unknown"
                    let subtitle = document["subtitle"] as? String ?? "unknown"
                    let url = document["url"] as? String ?? "unknown"
                    let date = document["date"] as? Date ?? Date()
                    let data = PatchNoteData(title: title, subtitle: subtitle, url: url, date: date)
                    noteArray.append(data)
                }
                completion(noteArray, nil)
            }
        }
    }

}

final class PatchNoteViewModel: ObservableObject {

    @Published var notes = [PatchNoteData]()

    let model = PatchNoteModel()

    static let shared = PatchNoteViewModel()

    private init() {
        model.fetchDate { [weak self] patchnotes, error in

            guard let self = self else { return }

            if let error = error {
                let errorData = PatchNoteData(title: "Server Error", subtitle: (error.localizedDescription), url: "", date: Date())
                notes.append(errorData)
            } else if let patchnotes = patchnotes {
                self.notes = patchnotes
            }
        }
    }
}
