//
//  CardView.swift
//  Flashzilla
//
//  Created by Paul Hudson on 08/05/2024.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled

    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero

    let card: Card
    var removal: (() -> Void)? = nil

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                        ? .white
                        : .white
                            .opacity(1 - Double(abs(offset.width / 50)))

                )
                .background(
                    accessibilityDifferentiateWithoutColor
                        ? nil
                        : RoundedRectangle(cornerRadius: 25)
                            .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)

            VStack {
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)

                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        removal?()
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.bouncy, value: offset)
    }
}

#Preview {
    CardView(card: .example)
}
