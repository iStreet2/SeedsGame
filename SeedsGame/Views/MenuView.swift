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
            VStack(spacing: 40) {
                HStack(alignment: .top) {
                    Spacer()
                    Text("Título do Jogo")
                        .padding()
                        .padding(.horizontal, 60)
                        .padding(.vertical, 20)
                        .bold()
                        .font(.custom("Troika", size: 33))
                        .background(.gray)
                        .padding(.trailing, 122)


                    
//                    Spacer()
                    
                    Button(action: {
                        print("foii")
                    }) {
                        Image(systemName: "gear")
                    }
                    .buttonStyle(SquareButtonStyle())
                }
                
                HStack(spacing: 40){
//                    Image("client1")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 110)
//                        .padding()
                    VStack(spacing: 20){
                        Button("MODO HISTÓRIA"){
                            print("a")
                            
                        }
                        .buttonStyle(SeedButtonStyle())
                        
                        Button("INFINITO"){
                            print("b")
                        }
                        .buttonStyle(SeedButtonStyle())
                    }
//                    Image("client1")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 110)
//                        .padding()
                }
            }
        }
        
    }
}
#Preview {
    MenuView()
}
