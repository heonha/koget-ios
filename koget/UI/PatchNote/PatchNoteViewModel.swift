//
//  PatchNodeViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/27.
//

import SwiftUI

final class PatchNoteViewModel: BaseViewModel {

    @Published var notes = [PatchNote]()

    private let patchNoteManager = PatchNoteManager()

    static let shared = PatchNoteViewModel()

    private override init() {
        super.init()
        fetchPatchNotes()
    }

    private func fetchPatchNotes() {
        patchNoteManager.getData { [weak self] patchnotes, error in
            guard let self = self else { return }

            if let error = error {
                let errorData = PatchNote(title: "Server Error", subtitle: (error.localizedDescription), lightFileName: "", darkFileName: "", date: Date())
                self.notes.append(errorData)

            } else if let patchnotes = patchnotes {
                self.notes = patchnotes
            }
        }
    }
}
