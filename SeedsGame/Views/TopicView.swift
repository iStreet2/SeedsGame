//
//  TopicView.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 24/01/24.
//

import Foundation
import SwiftUI

struct TopicView: View {
    @State var isButtonOn = false
    @State var isSecondButtonOn = false
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Button(action: {
                print("foii")
            }) {
                Image("Setaesquerda")
            }
            .buttonStyle(SquareButtonStyle())
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Escolha os Tópicos")
                    .font(.custom("AlegreyaSans-Medium", size: 32))
                    .bold()
                    .padding(50)
                    .padding(.trailing, 65)
                
                VStack {
                    Toggle("Funções de Primeiro Grau", isOn: $isButtonOn)
                        .toggleStyle(CheckToggleStyle())
                        .padding()
                        .font(.custom("AlegreyaSans-Medium", size: 24))
                    
                    Toggle("Funções de Segundo Grau", isOn: $isSecondButtonOn)
                        .toggleStyle(CheckToggleStyle())
                        .padding()
                        .font(.custom("AlegreyaSans-Medium", size: 24))
                      
                }
            }
            Spacer()
        }
        Spacer()
        Button("INICIAR"){
            print("a")
        }
        .buttonStyle(SeedButtonStyle())
    }
}

#Preview {
    TopicView()
}
