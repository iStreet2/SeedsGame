//
//  SquareButtonStyle.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 24/01/24.
//

import SwiftUI

struct SquareButtonStyle: ButtonStyle {
    var tag: SquareImages
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Image(tag.pressed): Image(tag.rawValue))
    }
}

#Preview {
    Button(action: {
        print("")
    }) {
        Text("")
    }
    .buttonStyle(SquareButtonStyle(tag: .back))
}
