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
        
        NavigationStack {
            ZStack {
                HStack(alignment: .bottom){
                    Image("Bhas")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 196, height: 347)
                        .padding(.bottom, 55)
                    
                    Spacer(minLength: 400)
                    
                    Image("Rose - Neutro")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 196, height: 347)
                        .padding(.top, 250)
                }
                
                VStack(spacing: 50) {
                    HStack(alignment: .top) {
                        Spacer()
                        Text("Título do Jogo")
                            .padding()
                            .padding(.horizontal, 40)
                            .padding(.vertical, 35)
                            .bold()
                            .font(.custom("Troika", size: 33))
                            .background(.gray)
                            .padding(.trailing, 190)
                            .foregroundStyle(.white)

                        Button(action: {
                            print("foii")
                        }) {
                            Image("")
                        }
                        .buttonStyle(SquareButtonStyle(tag: .config))
                        .padding()
                    }
                    VStack(spacing: 50){
                        Button("MODO HISTÓRIA"){
                            print("")
                            
                        }
                        .buttonStyle(RectangleButtonStyle(tag: .story))
                        
                        Button("INFINITO"){
                            print("")
                        }
                        .buttonStyle(RectangleButtonStyle(tag: .type2))
                    }
                }
                
            }
        }
        
    }
}
#Preview {
    MenuView()
}
