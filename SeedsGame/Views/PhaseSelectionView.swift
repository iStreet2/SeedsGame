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
            VStack(alignment: .center, spacing: -50) {
                HStack(alignment: .center) {
                    Button {
                        dismiss()
                    } label: {
                        Text("")
                    }
                    .buttonStyle(SquareButtonStyle(tag: .back))
                    
                    Spacer()
                    Text("Selecione o Capítulo")
                        .font(.custom("AlegreyaSans-Black", size: 32))
                        .foregroundStyle(Color("FontLightBrown"))
                    Spacer()
                }
  
                PhaseViewer(phasesName: ["fase3", "fase2", "fase3"])

            }
            .padding(.top,30)
            .background(Image("Fundo"))
        }
    }
}

#Preview {
    PhaseSelectionView()
}
