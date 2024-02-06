//
//  WinView.swift
//  SeedsGame
//
//  Created by Laura C. Balbachan dos Santos on 01/02/24.
//

import Foundation
import SwiftUI

struct EndGameView: View {
    var tag: PhasesFrases
    var points: Int = 8002
    
    var body: some View {
        HStack(alignment: .top, spacing: 70) {
            VStack {
                // Lado esquerdo do Pop Up
                Image("Foto")
                    .resizable()
                    .frame(width: 263, height: 264)
                    .overlay {
                        Image("Moldura - Fim de Fase")
                            .resizable()
                            .frame(width: 280, height: 282)
                    }
            }
            
            // Lado direito do Pop Up
            VStack {
                VStack(spacing: 0) {
                    Text("\(tag.rawValue)")
                        .multilineTextAlignment(.center)
                        .font(.custom("troika", size: 36))
                        .frame(width: 220, height: 85)
                    
                    // Texto de High Score
                    // Aqui teria que ter a lógica de ver se é New High Score mesmo
                    HStack(spacing: 5) {
                        Text("NEW")
                            .font(.custom("AlegreyaSans-Medium", size: 24))
                        
                        Text("High Score: \(points)")
                            .font(.custom("AlegreyaSans-Medium", size: 20))
                    }
                }
                                
                // Botões
                VStack(spacing: 60) {
                    HStack(spacing: 140) {
                        Button("") {
                            print("aaa")
                        }
                        .buttonStyle(SquareButtonStyle(tag: .home))
                        
                        Button("") {
                            print("aaa")
                        }
                        .buttonStyle(SquareButtonStyle(tag: .gameCenter))
                    }
                    
                    Button("Próxima fase") {
                        print("aaa")
                    }
                    .buttonStyle(RectangleButtonStyle(tag: .type2))
                }
                .padding(.top, 25)
                
            }
        }
        .padding(.trailing, 40)
        .background(Image("Fundo Fase"))
        .frame(width: 673, height: 322)
    }
}

#Preview {
    EndGameView(tag: .uncoverd)
}
