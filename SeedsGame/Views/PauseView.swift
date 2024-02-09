//
//  PauseView.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 02/02/24.
//

import Foundation
import SwiftUI
import CoreData

struct PauseView: View {
    //Coisas do CoreData
    @Environment(\.managedObjectContext) var context //Contexto, DataController
    @ObservedObject var myDataController: MyDataController
    @FetchRequest(sortDescriptors: []) var myData: FetchedResults<MyData>
    
    @State var isMusic: Bool = true
    
    init(context: NSManagedObjectContext) {
        self.myDataController = MyDataController(context: context)
        self.isMusic = true
    }
	
	var body: some View {
		NavigationStack {
			VStack {
				Text("PAUSADO")
					.font(.custom("troika", size: 48))
					.padding(.bottom, 50)
				HStack(spacing: 150) {
					NavigationLink {
						MenuView(context: context)
					} label: {
						Text("")
					}
					.buttonStyle(SquareButtonStyle(tag: .home))
					
					
					
//					Button("") {
//						GameEngine.shared.setGameIsPausedFALSE()
//					} .buttonStyle(SquareButtonStyle(tag: .play))
				}
				Toggle("", isOn: $isMusic)
					.toggleStyle(MusicToggleStyle(context: context))
					.padding(.top, 60)
			}
			.background(Image("Fundo Pause"))
		}
	}
}

#Preview {
    PauseView(context: DataController().container.viewContext)
}
