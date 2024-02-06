//
//  SeedButton.swift
//  SeedsGame
//
//  Created by Laura C. Balbachan dos Santos on 24/01/24.
//

import SwiftUI

struct RectangleButtonStyle: ButtonStyle {
    var tag: RectangleImages
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Image(tag.pressed): Image(tag.rawValue))
            .font(.custom("Troika", size: 32))
            .foregroundStyle(Color("FontLightBrown"))
    }
}

#Preview {
    Button("Infinito") {
        print("")
    }
    .buttonStyle(RectangleButtonStyle(tag: .type1))
}
