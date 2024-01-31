////
////  ConfigurationView.swift
////  SeedsGame
////
////  Created by André Enes Pecci on 30/01/24.
////
//
//import Foundation
//import SwiftUI
//
//struct ConfigurationView: View {
//    @State var  showBotao = true
//    
//    var body: some View {
//        VStack {
//                
//                title
//            HStack{
//                music
//                Button("Sobre Nós"){
//                    
//                }
//                    .buttonStyle(SeedButtonStyle())
//                    .padding(.leading, 80)
//            }
//                content
//                
//                
//            }.padding()
//                .multilineTextAlignment(.center)
//                .background(.gray)
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//                .frame(width: 483, height: 277)
//        }
//}
//private extension ConfigurationView {
//    var title: some View {
//        Text("Configurações")
//            .font(.custom("Troika", size: 36))
//            .padding ()
//    }
//    
//    var music: some View {
//        MusicStyle()
//    }
//    var content: some View {
//        Text("Lorem ipsum dolor sit amet, consectetur.")
//            .font(.callout)
//            .foregroundColor(.black.opacity(0.8))
//    }
//}
//
//
//
//#Preview {
//    ConfigurationView()
//}
