//
//  ConfigurationView.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 31/01/24.
//

import Foundation
import SwiftUI

struct ConfigurationView: View {
    
    @State var isMusic = true
    var body: some View {
     
        ZStack {
            VStack() {
                    Text("CONFIGURAÇÕES")
                        .font(.custom("troika", size: 36))
                HStack {
                    VStack(spacing: 50) {
                        Toggle("", isOn: $isMusic)
                            .toggleStyle(MusicToggleStyle())
                        
                        Button(action: {
                            print("")
                        }) {
                            Text("")
                        }
                        .buttonStyle(SquareButtonStyle(tag: .gameCenter))
                    }
                    .padding(.horizontal, 80)
                    VStack(spacing: 50){
                        Button("SOBRE NÓS"){
                        }
                        .buttonStyle(RectangleButtonStyle(tag: .type2))
                        
                        Button("SUPORTE"){
                        }
                        .buttonStyle(RectangleButtonStyle(tag: .type1))
                        .padding(.trailing)
                    }
                }
            }
        } 
        .frame(width: 450, height: 250)
        .background(Color(.cyan))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ConfigurationView()
}
