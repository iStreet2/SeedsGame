//
//  DataController.swift
//  SeedsGame
//
//  Created by Gabriel Vicentin Negro on 08/02/24.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "Model")
    
    init() {
        container.loadPersistentStores{ descricao, erro in
            if let erro = erro{
                print("Erro ao pegar os dados \(erro.localizedDescription)")
            }
        }
    }
}
