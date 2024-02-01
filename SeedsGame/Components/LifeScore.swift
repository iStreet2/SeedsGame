//
//  EndScene.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 29/01/24.
//

import Foundation
import SwiftUI

struct LifeScore: View {
    
    @Binding var life: Int
    @Binding var points: Int
    
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
                    .contentTransition(.numericText())
                    .font(.custom("AlegreyaSans-Medium", size: 25))
                
                HStack {
                    ForEach(0..<life, id: \.self) { index in
                        Image("Life")
                            .font(.system(size: 30))
                            .foregroundStyle(.cyan)
                    }
                    ForEach(0..<3-life, id: \.self) { index in
                        Image("Life")
                            .font(.system(size: 30))
                            .foregroundStyle(.gray)
                    }

                }
            }
        }
    }
}
#Preview {
    LifeScore(life: .constant(1), points: .constant(1))
}
