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
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                        .bold()
                        .font(.title)
                        .background(.gray)
                        .padding(.trailing, 162)
                    
                    Button(action: {
                        print("foii")
                    }) {
                        Image(systemName: "gear")
                    }
                    .buttonStyle(SquareButtonStyle())
                }
                
                HStack(spacing: 40){                    
                    VStack(spacing: 20){
                        NavigationLink("MODO HISTÓRIA", destination: PhaseSelectionView())
                            .buttonStyle(SeedButtonStyle())
                        
                        NavigationLink("INFINITO", destination: TopicView())
                            .buttonStyle(SeedButtonStyle())
                    }
                }
            }
        }
    }
}

#Preview {
    MenuView()
}
