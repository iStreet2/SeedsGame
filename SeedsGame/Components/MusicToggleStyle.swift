//
//  MusicToggle.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 31/01/24.
//

import Foundation
import SwiftUI


struct MusicToggleStyle: ToggleStyle {
    @State var isMusicOn = true
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn
                  ? "speaker"
                  : "speaker.slash")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .frame(width: 15)
            .foregroundStyle(.black)
            
            configuration.label
            Spacer()
            (configuration.isOn ? Image("Toggle On") : Image("Toggle Off"))
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(width: 70, height: 36, alignment: .center)
                .overlay(Image("Bolinha do Toggle")
                    .offset(x: configuration.isOn ? 21 : -21, y: 0)
                    .animation(Animation.linear(duration: 0.15))

                )
                .onTapGesture { configuration.isOn.toggle() }
        } .frame(width: 0)
    }
}

#Preview {
    Toggle(isOn: .constant(true), label: {
        Text("")
    })
    .toggleStyle(MusicToggleStyle())
}
