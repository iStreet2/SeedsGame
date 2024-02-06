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
                GeometryReader { geo in
                ZStack {
                    NavigationLink {
                        ConfigurationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("")
                        
                    } .buttonStyle(SquareButtonStyle(tag: .config))
                        .padding()
                        .frame(width: geo.size.width/1, height: geo.size.height*1, alignment: .topTrailing)
                    
                    VStack {
                        HStack() {
                            // Personagem Sr.Bhas
                             
                            Spacer()
                            Image("Sr.Bhas")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 187, height: 353)
                                .padding(.top, 160)


                            VStack(spacing: 50) {
                                // Título do Jogo
                                Text("Sr.Bhas e as\n Sementes Siderais")
                                    .frame(width: 500, height: 110)
                                    .bold()
                                    .font(.custom("Troika", size: 49))
                                    .foregroundStyle(Color("fontLightBrown"))
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    
                                
                                // Botão Modo História
                                NavigationLink {
                                    PhaseSelectionView()
                                        .navigationBarBackButtonHidden(true)
                                } label: {
                                    Text("Modo História")
                                } .buttonStyle(RectangleButtonStyle(tag: .story))
                                    

                                
                                // Botão do Modo Infinito
                                Button("INFINITO"){
                                    print("")
                                }
                                .buttonStyle(RectangleButtonStyle(tag: .type2))

                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.bottom, 100)
                            
                            // Personagem Rose
                            VStack() {
                                Spacer(minLength: 250)
                                
                                Image("Rose - Neutro")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 568/3, height: 1007/3)
                                    .padding(.bottom, 90)
                                

                                    
                            }
                            .edgesIgnoringSafeArea(.bottom)
                        }
                    } .frame(width: geo.size.width*1, height: geo.size.height * 1.2)
                }
            } .background(Image("Fundo"))
        }
				.navigationBarBackButtonHidden()
        
    }
}
#Preview {
    MenuView()
}
