//
//  MyDataController.swift
//  SeedsGame
//
//  Created by Gabriel Vicentin Negro on 08/02/24.
//

import Foundation
import CoreData


class MyDataController: ObservableObject{
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
        
        initTutorial()
    }
    
    func saveContext() {
        do{
            try context.save()
        } catch{
            print("Não foi possível salvar os dados")
        }
    }
    
    func initTutorial(){
        let amountCoreDataItems = try? context.count(for: MyData.fetchRequest())
        
        guard amountCoreDataItems == 0 else{
            //ja foi inicializado pela primeira vez
            return
        }
        let myData = MyData(context: context) //o myData[0] recebe o tutorial e a música
        enableTutorial(myData: myData)
        enableMusic(myData: myData)
        
        for _ in 0..<3{ //Inicalizo tres MyData's com highscore igual a 0, aqui conta a partir do myData[1]
            let myData = MyData(context: context)
            initPhaseHighScore(myData: myData)
        }
        
        
    }
    
    func disableTutorial(myData: MyData){
        myData.tutorial = false
        saveContext()
    }
    
    func enableTutorial(myData: MyData){
        myData.tutorial = true
        saveContext()
    }
    
    func saveHighScore(myData: MyData, score: Double){
        myData.highscores = score
        saveContext()
    }
    
    func enableMusic(myData: MyData){
        myData.music = true
        saveContext()
    }
    
    func disableMusic(myData: MyData){
        myData.music = false
        saveContext()
    }
    
    func toggleMusic(myData: MyData){
        myData.music.toggle()
        saveContext()
    }
    
    func initPhaseHighScore(myData: MyData){
        myData.phase = 0
        saveContext()
    }
    
    func unlockNextPhase(myData: MyData){
        myData.phase += 1
        saveContext()
    }
}

