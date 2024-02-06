//
//  ConfigurationView.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 31/01/24.
//

import Foundation
import SwiftUI

struct ConfigurationView: View {
    
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) private var dismiss
    @State var isMusic = true
    var body: some View {
     
        GeometryReader { geometry in
            ZStack {
                HStack() {
                    Text("Configurações")
                        .font(.custom("AlegreyaSans-Medium", size: 36))
                        .foregroundStyle(Color("FontDarkBrown"))
                        .padding(.bottom, 200)
                        .padding(.horizontal, 120)
                    
                        Button(action: {
                            dismiss()
                        }) {
                            Text("")
                        }
                        .buttonStyle(SquareButtonStyle(tag: .close))
                        .padding(.bottom, 250)
                    
                    
                }
                VStack(spacing: 20) {
                        HStack(spacing: geometry.size.width*0.2) {
                            Toggle("", isOn: $isMusic)
                                .toggleStyle(MusicToggleStyle())
                                .padding()
                            Button("SOBRE NÓS"){
                                openURL(URL(string: "https://www.instagram.com/srbhas.app?igsh=M2F3OWg2dW0zM2Mz")!)
                            }
                            .buttonStyle(RectangleButtonStyle(tag: .type2))
                           
                        }
                    
                        HStack(spacing: geometry.size.width*0.2){
                            Button(action: {
                                print("")
                            }) {
                                Text("")
                            }
                            .buttonStyle(SquareButtonStyle(tag: .gameCenter))
                            .padding()
                            
                            Button("SUPORTE"){
                            }
                            .buttonStyle(RectangleButtonStyle(tag: .type1))
                            .padding()
                        }
                } .padding(.top, 60)
                
            } 
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Image("Fundo Config"))
        }
    }
}

#Preview {
    ConfigurationView()
}
