//
//  PatchNoteModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import FirebaseFirestore

struct PatchNoteData: Codable, Identifiable {
    var id: UUID = UUID()
    let title: String
    let subtitle: String
    let lightFileName: String
    let darkFileName: String
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
                    let light = document["light"] as? String ?? "unknown"
                    let dark = document["dark"] as? String ?? "unknown"

                    let timeStamp = document["date"] as? Timestamp ?? Timestamp()
                    let date = timeStamp.dateValue()
                    let data = PatchNoteData(title: title, subtitle: subtitle, lightFileName: light, darkFileName: dark, date: date)
                    noteArray.append(data)
                }
                completion(noteArray, nil)
            }
        }
    }

}
