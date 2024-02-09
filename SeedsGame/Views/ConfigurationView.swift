//
//  ConfigurationView.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 31/01/24.
//

import Foundation
import SwiftUI
import CoreData

struct ConfigurationView: View {
    
    //Coisas do CoreData
    @Environment(\.managedObjectContext) var context //Contexto, DataController
    @ObservedObject var myDataController: MyDataController
    @FetchRequest(sortDescriptors: []) var myData: FetchedResults<MyData>
	
	@Environment(\.dismiss) private var dismiss
	@State var isMusic = true
	
    init(context: NSManagedObjectContext){
        self.myDataController = MyDataController(context: context)
        self.isMusic = true
    }
    
	var body: some View {
		NavigationStack {
			GeometryReader { geometry in
				ZStack {
					HStack() {
						Text("Configurações")
							.font(.custom("AlegreyaSans-Medium", size: 36))
							.foregroundStyle(Color("FontDarkBrown"))
							.padding(.bottom, 200)
							.padding(.horizontal, 120)
						
						Button(action: {
							GameEngine.shared.setConfigurationPopUpIsPresentedIsFALSE()
						}) {
							Text("")
						}
						.buttonStyle(SquareButtonStyle(tag: .close))
						.padding(.bottom, 250)
						
						
					}
					VStack(spacing: 20) {
						HStack(spacing: geometry.size.width*0.2) {
                            
							Toggle("", isOn: $isMusic)
								.toggleStyle(MusicToggleStyle(context: context))
								.padding()
                            
							Button("SOBRE NÓS"){
							}
							.buttonStyle(RectangleButtonStyle(tag: .type2))
							
						}
						
//						HStack(spacing: geometry.size.width*0.2){
//							Button(action: {
//								print("")
//							}) {
//								Text("")
//							}
//							.buttonStyle(SquareButtonStyle(tag: .gameCenter))
//							.padding()
//							
//							Button("SUPORTE"){
//							}
//							.buttonStyle(RectangleButtonStyle(tag: .type1))
//							.padding()
//						}
					} .padding(.top, 60)
					
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
				.background(Image("Fundo Config"))
			}
		}
	}
}

#Preview {
    ConfigurationView(context: DataController().container.viewContext)
}
