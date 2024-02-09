//
//  PhaseSelectionView.swift
//  SeedsGame
//
//  Created by Laura C. Balbachan dos Santos on 24/01/24.
//

import SwiftUI
import SpriteKit
import CoreData

struct PhaseSelectionView: View {
    
    //Coisas do CoreData
    @Environment(\.managedObjectContext) var context //Contexto, DataController
    @ObservedObject var myDataController: MyDataController
    @FetchRequest(sortDescriptors: []) var myData: FetchedResults<MyData>
    
    @Environment(\.dismiss) private var dismiss
    
    init(context: NSManagedObjectContext) {
        self.myDataController = MyDataController(context: context)
    }
    
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
  
                PhaseViewer(context: context, phasesName: ["fase1", "fase2", "fase3","fase4"])

            }
            .padding(.top,30)
            .background(Image("Fundo"))
        }
    }
}

#Preview {
    PhaseSelectionView(context: DataController().container.viewContext)
}
