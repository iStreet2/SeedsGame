//
//  EndScene.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 29/01/24.
//

import Foundation
import SwiftUI

struct LifeScore: View {
    
    @EnvironmentObject var userEngine: UserEngine
    
    var body: some View {
        ZStack {
            Image("Placar")
                .resizable()
                .frame(width: 144, height: 133)
            
            VStack(spacing: 1) {
                Text("Pontos")
                    .font(.custom("troika", size: 25))
                    .bold()
                    .foregroundStyle(Color("FontDarkBrown"))
                
                Text("\(userEngine.score)")
                    .contentTransition(.numericText())
                    .font(.custom("AlegreyaSans-Medium", size: 25))
                    .foregroundStyle(Color("FontDarkBrown"))
                
                HStack {
                    ForEach(0..<userEngine.life, id: \.self) { index in
                        Image("Life")
                            .font(.system(size: 30))
                            .foregroundStyle(Color("FontDarkBrown"))
                    }
                    ForEach(0..<3-userEngine.life, id: \.self) { index in
                        Image("Life")
                            .font(.system(size: 30))
                            .foregroundStyle(Color("FadedLifePoint"))
                    }

                }
            }
        }
    }
}
//#Preview {
//    LifeScore(userEngine: UserEngine())
//}
