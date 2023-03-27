//
//  PatchNodeViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/27.
//

import SwiftUI

final class PatchNoteViewModel: ObservableObject {

    @Published var notes = [PatchNoteData]()

    let model = PatchNoteModel()

    static let shared = PatchNoteViewModel()

    private init() {
        model.fetchDate { [weak self] patchnotes, error in

            guard let self = self else { return }

            if let error = error {
                let errorData = PatchNoteData(title: "Server Error", subtitle: (error.localizedDescription), lightFileName: "", darkFileName: "", date: Date())
                self.notes.append(errorData)
            } else if let patchnotes = patchnotes {
                self.notes = patchnotes
            }
        }
    }
}
