//
//  DragRelocateDelegate.swift
//  koget
//
//  Created by Heonjin Ha on 2023/05/17.
//

import SwiftUI

class DragRelocateDelegate: DropDelegate {
    var currentWidget: DeepLink
    @Binding var targetIndexSet: IndexSet
    @Binding var widgets: [DeepLink]

    init(currentWidget: DeepLink, targetIndexSet: Binding<IndexSet>, widgets: Binding<[DeepLink]>) {
        self.currentWidget = currentWidget
        self._targetIndexSet = targetIndexSet
        self._widgets = widgets
    }

    func performDrop(info: DropInfo) -> Bool {
        let targetIndex = $targetIndexSet.wrappedValue.first ?? $widgets.wrappedValue.count

        if let currentIndex = $widgets.wrappedValue.firstIndex(of: currentWidget), currentIndex != targetIndex {
            DispatchQueue.main.async {
                var adjustedTargetIndex = targetIndex
                if currentIndex < adjustedTargetIndex {
                    adjustedTargetIndex -= 1
                }
                self.$widgets.wrappedValue.remove(at: currentIndex)
                self.$widgets.wrappedValue.insert(self.currentWidget, at: adjustedTargetIndex)
                self.$targetIndexSet.wrappedValue = IndexSet(integer: adjustedTargetIndex)
            }
        }

        return true
    }


    func dropEntered(info: DropInfo) {
        if let currentIndex = widgets.firstIndex(of: currentWidget) {
            targetIndexSet = IndexSet(integer: currentIndex)
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func dropExited(info: DropInfo) {
        targetIndexSet = IndexSet()
    }
}
