//
//  CheckButtonStyle.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 29/01/24.
//

import Foundation
import SwiftUI


struct CheckToggleStyle: ToggleStyle {

    func makeBody(configuration: Configuration) -> some View {
                Button {
                    configuration.isOn.toggle()
                } label: {
                    HStack {
                        Image(systemName: configuration.isOn
                              ? "checkmark.circle.fill"
                              : "circle")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        configuration.label
                    }
                }
                .tint(.primary)
                .buttonStyle(.borderless)
            }
    }

#Preview {
    Toggle(isOn: .constant(false), label: {
        Text("Funções de Primeiro Grau")
            .font(.custom("AlegreyaSans-Medium", size: 24))
    })
        .toggleStyle(CheckToggleStyle())
}

