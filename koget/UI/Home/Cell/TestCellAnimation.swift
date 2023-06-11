//
//  TestCellAnimation.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/11.
//

import SwiftUI

struct TestCellAnimation: View {
    var body: some View {
        VStack(spacing: 12) {
            TestDisclosure()
            TestDisclosure()
            TestDisclosure()
            Spacer()
        }
    }
}

struct TestDisclosure: View {
    @State var expanded: Bool = false
    @State var isDeleting: Bool = false
    @State var horzdrag: CGFloat = 0 // the horizontal translation of the drag
    @State var predictedEnd: CGFloat = 0 // the predicted end translation of the drag

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.red)

            label
                .clipped()
                .offset(x: getOffset(horzdrag: horzdrag))
                .animation(.default, value: horzdrag)     // << here !!
        }
        .offset(x: isDeleting ? -400 : 0)
        .animation(.spring(), value: isDeleting)
        .transition(.move(edge: .leading))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    onDragChange(gesture: gesture)
                }
                .onEnded { _ in
                    onDragEnd()
                }
        )
        .cornerRadius(15)
        .padding(.horizontal)
        .onTapGesture {
            withAnimation(.spring()) {
                expanded.toggle()
            }
        }
        .frame(maxHeight: expanded ? 150 : 85)
        .clipped()
    }

    private var label: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.teal)

            VStack {
                HStack {
                    Text("Test")
                    Spacer()
                    Text("1 unit")
                    Text("12 units")
                }
                .padding(.horizontal)
            }
        }
    }

    private func onDragChange(gesture: DragGesture.Value) {
        horzdrag = gesture.translation.width
        predictedEnd = gesture.predictedEndTranslation.width
    }

    private func onDragEnd() {
        if getOffset(horzdrag: horzdrag) <= -400 {
            withAnimation(.spring()) {
                isDeleting = true
            }
        }

        horzdrag = .zero
    }

    // used to calculate how far to move the teal rectangle
    private func getOffset(horzdrag: CGFloat) -> CGFloat {
        if isDeleting {
            return -400
        } else if horzdrag < -165 {
            return -400
        } else if predictedEnd < -60 && horzdrag == 0 {
            return -80
        } else if predictedEnd < -60 {
            return horzdrag
        } else if predictedEnd < 50 && horzdrag > 0 && (-80 + horzdrag <= 0) {
            return -80 + horzdrag
        } else if horzdrag < 0 {
            return horzdrag
        } else {
            return 0
        }
    }
}


#if DEBUG
struct TestCellAnimation_Previews: PreviewProvider {
    static var previews: some View {

        TestCellAnimation()

    }
}
#endif
