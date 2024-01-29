//
//  TopicView.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 24/01/24.
//

import Foundation
import SwiftUI

struct TopicView: View {
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Button(action: {
                print("foii")
            }) {
                Image(systemName: "triangle")
            }
            .buttonStyle(SquareButtonStyle())
            Spacer()
            VStack {
                Text("Escolha os Tópicos")
                    .font(.title)
                    .bold()
                    .padding(60)
                HStack {
                    Circle()
                        .frame(width: 20)
                    Text("Equações de Primeiro Grau")
                }
                HStack {
                    Circle()
                        .frame(width: 25)
                    Text("Equações de Segundo Grau")
                }
            }
            Spacer()
        }
        Spacer()
        Button("INICIAR"){
            print("a")
        }
        .buttonStyle(SeedButtonStyle())
    }
}

#Preview {
    TopicView()
}
