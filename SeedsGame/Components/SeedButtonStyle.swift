//
//  SeedButton.swift
//  SeedsGame
//
//  Created by Laura C. Balbachan dos Santos on 24/01/24.
//

import SwiftUI

struct SeedButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .bold()
            .padding()
            .padding(.horizontal, 20)
            .background(configuration.isPressed ? .black : .gray)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            
    }
}

#Preview {
    Button("Infinito") {
        print("aaaa")
    }
    .buttonStyle(SeedButtonStyle())
}
