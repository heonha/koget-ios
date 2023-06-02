//
//  PatchNoteManager.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import FirebaseFirestore

struct PatchNoteManager {

    private let language = Locale.current.language.languageCode?.identifier

    private let dbref: CollectionReference

    init() {
        if self.language == "ko" {
            self.dbref = Firestore.firestore().collection("patchnote")
        } else {
            self.dbref = Firestore.firestore().collection("patchnote-en")
        }
    }

    func getData(completion: @escaping([PatchNote]? , Error?) -> Void) {
        dbref.getDocuments { snapshot, error in

            var noteArray = [PatchNote]()
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
                    let data = PatchNote(title: title, subtitle: subtitle, lightFileName: light, darkFileName: dark, date: date)
                    noteArray.append(data)
                }
                noteArray.reverse()
                completion(noteArray, nil)
            }
        }
    }

}
