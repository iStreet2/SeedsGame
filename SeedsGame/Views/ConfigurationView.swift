//
//  ConfigurationView.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 31/01/24.
//

import Foundation
import SwiftUI

struct ConfigurationView: View {
    var body: some View {
        Color.gray
            .ignoresSafeArea()
            .opacity(0.6)
        ZStack {
            VStack() {
                VStack {
                    Text("CONFIGURAÇÕES")
                        .font(.custom("troika", size: 36))
                }
                VStack {
                    HStack {
                        MusicStyle()
                        Button("SOBRE NÓS"){
                        }
                        .buttonStyle(SeedButtonStyle())
                        .padding(.leading, 80)
                    }
                    HStack{
                        Button(action: {
                            print("GameCenter")
                        }) {
                            Image(systemName: "gear")
                        }
                        .buttonStyle(SeedButtonStyle())
                        //                    .padding(.leading)
                    }
                }
            }
        } .frame(width: 483, height: 277)
    }
}

#Preview {
    ConfigurationView()
}
