//
//  PauseView.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 02/02/24.
//

import Foundation
import SwiftUI

struct PauseView: View {
    @State var isMusic = true
    
    var body: some View {
        VStack {
            Text("PAUSADO")
                .font(.custom("troika", size: 48))
                .padding(.bottom, 50)
            HStack(spacing: 150) {
                Button("") {
                    print("")
                } .buttonStyle(SquareButtonStyle(tag: .home))
                
                
                Button("") {
                    print("")
                } .buttonStyle(SquareButtonStyle(tag: .play))
            }
            Toggle("", isOn: $isMusic)
                .toggleStyle(MusicToggleStyle())
                .padding(.top, 60)
        }
        .background(Image("Fundo Pause"))
    }
}

#Preview {
    PauseView()
}
