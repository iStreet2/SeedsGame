//
//  EndScene.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 29/01/24.
//

import Foundation
import SwiftUI

struct LifeScore: View {
    
    var life: Int
    var points: Int
    var body: some View {
        ZStack {
            Image("Placar")
                .resizable()
                .frame(width: 144, height: 133)
            VStack(spacing: 1) {
                Text("Pontos")
                    .font(.custom("troika", size: 25))
                    .bold()
                Text("\(points)")
                    .font(.custom("AlegreyaSans-Medium", size: 25))
                HStack {
                    ForEach(0..<life, id: \.self) { index in
                        Image("Vida")
                            .frame(width: 30)
                    }
                }
            }
        }
    }
}
#Preview {
    LifeScore(life: 3, points: 0)
}
