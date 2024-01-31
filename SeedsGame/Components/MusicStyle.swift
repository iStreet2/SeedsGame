//
//  ConfigurationStyle.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 30/01/24.
//

import Foundation
import SwiftUI

struct MusicStyle: View {
    @State var  showBotao = true
    
    var body: some View {
        HStack() {
            if showBotao {
                Image(systemName: "music.note.list")
                    .font(.title2)
            } else {
                Image(systemName: "music.note")
                    .font(.title2)
            }
            Toggle("", isOn: $showBotao)
   
        } .frame(width: 0)
    }
}

#Preview {
    MusicStyle()
}
