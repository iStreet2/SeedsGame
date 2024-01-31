//
//  SquareButtonStyle.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 24/01/24.
//

import SwiftUI

struct SquareButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 32))
            .bold()
            .frame(width: 59, height: 59)
            .background(configuration.isPressed ? .black: .gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    Button(action: {
        print("foii")
    }) {
        Image(systemName: "gear")
    }
    .buttonStyle(SquareButtonStyle())
}
