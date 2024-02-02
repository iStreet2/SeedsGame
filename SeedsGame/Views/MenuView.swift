//
//  MenuView.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 24/01/24.
//

import Foundation
import SwiftUI

struct MenuView: View {
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    Button(action: {
                        print("foii")
                    }) {
                        Image("")
                    }
                    .buttonStyle(SquareButtonStyle(tag: .config))
                    .padding()
                    .frame(width: geo.size.width/1.05, height: geo.size.height/1.5, alignment: .topTrailing)
                    
                    HStack {
                        // Personagem Sr.Bhas
                        
                        Image("Bhas")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 187, height: 260)
                            .padding(.top, 150)
                            .edgesIgnoringSafeArea(.bottom)
                        
                        VStack(spacing: 50) {
                            // Título do Jogo
                            Text("Título do\nJogo")
                                .bold()
                                .font(.custom("Troika", size: 49))
                                .foregroundStyle(Color("fontLightBrown"))
                                .multilineTextAlignment(.center)
                            
                            
                            // Botão do Modo História
                            Button("MODO HISTÓRIA"){
                                print("")
                            }
                            .buttonStyle(RectangleButtonStyle(tag: .story))
                            
                            // Botão do Modo Infinito
                            Button("INFINITO"){
                                print("")
                            }
                            .buttonStyle(RectangleButtonStyle(tag: .type2))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        // Personagem Rose
                        VStack {
                            Spacer(minLength: 250)
                            
                            Image("Rose - Neutro")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 568/3, height: 1007/3)
                            
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }
                }
            }
        }
        
    }
}
#Preview {
    MenuView()
}
