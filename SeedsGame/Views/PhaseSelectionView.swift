//
//  PhaseSelectionView.swift
//  SeedsGame
//
//  Created by Laura C. Balbachan dos Santos on 24/01/24.
//

import SwiftUI
import SpriteKit

struct PhaseSelectionView: View {
    @State var index: Int = 0
    @State var gestureIsOn: Bool = true
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 0) {
                    HStack(alignment: .center) {
                        
                        
									Button("") {
										dismiss()
									}
                            
                         .buttonStyle(SquareButtonStyle(tag: .back))
                        
                        Spacer()
                        Text("Selecione o Capítulo")
                            .font(.custom("AlegreyaSans-Black", size: 32))
                            .foregroundStyle(Color("fontLightBrown"))
                            .frame(width: geometry.size.width*1, height: geometry.size.height*0.1)
//                            .padding(.trailing, geometry.size.width/3)
                    }
                    
                    .padding(.top, geometry.size.height*0.05)
                    PhaseViewer(phasesName: ["fase3", "fase2", "fase3"])
                        .frame(width: geometry.size.width*1, height: geometry.size.height/1.5)
                    
                    
                    
                }
                //                    .toolbar {
                //                        ToolbarItem(placement: .topBarLeading) {
                //                            Button {
                //                                dismiss()
                //
                //                            } label: {
                //                                Text("")
                //                            }
                //                            .buttonStyle(SquareButtonStyle(tag: .back))
                //                            .padding(.top, 50)
                //                        }
                //                    }
            } .background(Image("Fundo"))
        }
    }
}

#Preview {
    PhaseSelectionView()
}
