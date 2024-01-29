//
//  GameEngine.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation
import SwiftUI
import SpriteKit


@Observable class GameEngine {
    
    static let shared = GameEngine()
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    let seedBagWidth: Double = 50
    let seedBagHeight: Double  = 70
    
    let hitBoxWidth: Double = 50
    let hitBoxHeight: Double = 50
    
    var realocationPosition = 0
    
    var actions: [Action] = []
    var phases: [PhaseScene] = []
    var currentPhase = 0
    
    
    init() {
        let phases = [PhaseScene(phase: 1, width: width, height: height), PhaseScene(phase: 2, width: width, height: height)]
        self.phases = phases
    }
    
    
    func receiveAction(_ action: Action) {
        actions.append(action)
        let res = action.execute()
		 
		 // recebeu uma equação de resposta -> OperationAction
		 if res.contains("=") {
			 self.phases[currentPhase].currentEqLabel.text = "\(res)"
		 }
    }
    
    
    func clearActions() {
        actions.removeAll()
    }
    
    
    func getActions() -> [Action] {
        return actions
    }
    
    
    func nextPhase(scene: PhaseScene) {
        let reveal = SKTransition.reveal(with: .left, duration: 1)
        
        if currentPhase != phases.count - 1 {
            currentPhase += 1
            
            scene.scene?.view?.presentScene(GameEngine.shared.phases[GameEngine.shared.currentPhase], transition: reveal)
        }
        else {
            // cena após as 3 fases
            scene.currentEqLabel.text = "All phases done!"
        }
    }
    
    func nextQuestion(scene: PhaseScene) {
        
        let nQuestions = scene.clients.count
        
        for client in scene.clients {
            
            let scaleAction = SKAction.scale(by: 1.15, duration: 0.5)
            client.run(scaleAction)
            
            let moveAction = SKAction.moveTo(x: client.position.x - 75, duration: 0.5)
            client.run(moveAction)
            
            if client.eq == scene.clients[scene.currentClientNumber].eq {
                // Cliente da pergunta atual é despachado
                scene.removeChildren(in: [client])
            }
        }
        
        // renderiza o sprite do próximo cliente no final da fila
        if (scene.currentClientNumber + 3) <= (nQuestions - 1) {
            scene.addChild(scene.clients[scene.currentClientNumber + 3])
        }
        
        // não deixa o número do cliente atual ser maior do que o número de clientes
        if scene.currentClientNumber != nQuestions - 1 {
            scene.currentClientNumber += 1
            scene.currentEqLabel.text = "\(scene.clients[scene.currentClientNumber].eq)"
        }
        
        // se todos os clientes tiverem as suas perguntas resolvidas
        else {
            scene.currentEqLabel.text = "All questions done!"
        }
        //Remover e readicionar as hitBoxes da equação
        addHitBoxes(scene: scene)
        addSeedBags(scene: scene)
    }
    
    
    func renderClients(scene: PhaseScene) {
        for (index, client) in scene.clients.enumerated() {
            client.position = CGPoint(x: 564+(75*index), y: 235)
            client.size = CGSize(width: client.size.width - CGFloat(index*(15)), height: client.size.height - CGFloat(index*(30)))
            client.zPosition = CGFloat(scene.clients.count - index)
            
            if index<3 {
                scene.addChild(client)
            }
        }
        
        scene.currentEqLabel.text = "\(scene.clients[scene.currentClientNumber].eq)"
    }
    
    
    // Função para mexer seeBagModels
    func moveSeedBag(_ node: SeedBagModel, _ touches: Set<UITouch>, stage: Int, initialPosition: Int, scene: PhaseScene){
        if stage == 0{
            if let touch = touches.first{
                let location = touch.location(in: scene.self)
                if node.contains(location){
                    scene.movableNode = node
                    scene.movableNode!.position = location
                }
            }
        }else if stage == 1{
            if let touch = touches.first {
                if scene.movableNode != nil{
                    scene.movableNode!.position = touch.location(in: scene.self)
                }
            }
        }else if stage == 2{
            if let touch = touches.first {
                if scene.movableNode != nil{
                    scene.movableNode!.position = touch.location(in: scene.self)
                    //Antes de deixar o movableNode em nil, eu chamo o grabNode, para que se o nó que o usuário estiver movendo, se prenda ao quadrado, se esse nó estive em cima do quadrado
                    grabNode(touches: touches, scene: scene)
                    
//                    realocateSeedBag(initialPosition, scene) COMENTADO POIS AINDA NAO FUNCIONA
                    //Depois de realocar preciso atualizar as equações na tela
//                    showEquation(scene: scene)
                    
                    scene.movableNode = nil
                }
            }
        }
    }
    
    
    //Adiciona hitBoxes com base no tamanho da equação dada pelo cliente!
    func addHitBoxes(scene: PhaseScene){
        //Remover as hitBoxes da questão anterior
        if scene.hitBoxes.count != 0{
            for hitBox in scene.hitBoxes{
                scene.removeChildren(in: [hitBox])
            }
            scene.hitBoxes.removeAll()
        }
        
        //Adicionar no vetor novamente os nos dos quadrados
        for _ in scene.clients[scene.currentClientNumber].eq{
            let node = SKShapeNode(rectOf: CGSize(width: hitBoxWidth, height: hitBoxHeight))
            scene.hitBoxes.append(node)
        }
        //Adicionar na cena as hitBoxes
        for (index,hitBox) in scene.hitBoxes.enumerated(){
            hitBox.position = CGPoint(x: 50+(60*index), y: 40)
            hitBox.strokeColor = .red
            scene.addChild(hitBox)
        }
    }
    
    //Adiciona uma hitBox a mais no final da equação
    func addHitBoxOnTheFinal(scene: PhaseScene){
        let node = SKShapeNode(rectOf: CGSize(width: hitBoxWidth, height: hitBoxHeight)) //Crio mais uma hitbox
        node.position = CGPoint(x: 50+(60*scene.hitBoxes.count), y: 40) //Defino a posição dele com base na posição da ultima hitBox
        node.strokeColor = .red //Defino a cor dele de vermelho
        scene.hitBoxes.append(node) //Adiciono ela no vetor de hitBoxes
        scene.addChild(node) //Adiciono ela na cena
        
    }
    
    func addSeedBags(scene: PhaseScene){
        
        if scene.currentSeedBags.count != 0{
            for seedBag in scene.currentSeedBags{
                scene.removeChildren(in: [seedBag])
                print("tirou 1 filho")
            }
            scene.currentSeedBags.removeAll()
        }
        
        //Transformo a string da equação em um vetor de caracteres
        let equation = Array(scene.clients[scene.currentClientNumber].eq)
        
        for (index,char) in equation.enumerated(){
            if char.isNumber{
                scene.currentSeedBags.append(SeedBagModel(numero: Int(String(char)) ?? 300, incognita: false, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight))
            }else if char == "x"{
                //Se eu encontrar um X com um valor anterior a ele, eu adiciono um "*" entre a sacola do número e a sacola do x
                if index != 0{
                    if  equation[index-1].isNumber{
                        scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "*", imageNamed: "nothing", color: .clear, width: seedBagWidth, height: seedBagHeight))
                        addHitBoxOnTheFinal(scene: scene)
                    }
                }
                scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: true, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight))
                
            }else{
                scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: String(char), imageNamed: "nothing", color: .clear, width: seedBagWidth, height: seedBagHeight))
            }
        }
        //Depois de preparar o vetor, adiciono na cena
        showEquation(scene: scene)
//        for seedBags in scene.currentSeedBags{
//            print(seedBags.label.text!)
//        }
        
        
    }
    
    
    func grabNode(touches: Set<UITouch>, scene: PhaseScene){
        if let touch = touches.first{
            if scene.movableNode != nil{
                let location = touch.location(in: scene.self)
                for (index,hitBox) in scene.hitBoxes.enumerated(){
                    if hitBox.contains(location){
                        realocationPosition = index
                        scene.movableNode!.position = hitBox.position
                        
                    }
                }
            }
        }
    }
    
    func realocateSeedBag(_ initialPosition: Int, _ scene: PhaseScene){
        
        var fromLeft = false
        
        for i in initialPosition..<scene.currentSeedBags.count{ //Percorro o vetor da posicao que o nó esta sendo mexido até o final do vetor, se achar algum igual no caminho, ele esta trazendo da esquerda
            if scene.currentSeedBags[i].label.text == "="{
                fromLeft = true
            }
        }
        if fromLeft{//se eu estiver arrastado o elemento da esquerda para a direita
            let currentSeedBag = scene.currentSeedBags[initialPosition] //salvo o valor no qual estou pegando
            
            for i in (initialPosition+1..<realocationPosition){
                scene.currentSeedBags[i-1] = scene.currentSeedBags[i] //aloco todos os outros um quadrado antes
            }
            scene.currentSeedBags[realocationPosition] = currentSeedBag //coloco na posição de realocação o valor que eu tinha salvo
        }else{
            //se eu estiver arrastando o elemento da direita para a esquerda
            let currentSeedBag = scene.currentSeedBags[initialPosition]
            
            for i in (initialPosition-1..<realocationPosition).reversed(){ //Percorro o vetor desde a posição inicial -1 e vou ate a posicao de realocação, da esquerda para a direita
                scene.currentSeedBags[i+1] = scene.currentSeedBags[i]
            }
            scene.currentSeedBags[realocationPosition] = currentSeedBag
        }
    }
    
    func showEquation(scene: PhaseScene){
        if scene.currentSeedBags.count != 0{
            for seedBag in scene.currentSeedBags{
                scene.removeChildren(in: [seedBag])
            }
        }
        for (index,seedBag) in scene.currentSeedBags.enumerated(){
            seedBag.position = CGPoint(x: 50+(60*index), y: 40) //Posicao da sacola com o numero, mexo com o index para colocar na posição certa da equação
//            seedBag.label.position.y -= 15
            
            scene.addChild(seedBag)
        }
    }
    

}
    
//Sempre que eu arrastar algo para outra hitbox, eu tenho que atualizar o meu vetor de sementes, mas isso soh pode ser feito depois que dua sementes nao puderem ficar na mesma hitbox, ou seja, tem que ter o sistema de realocação feito ja



//so da para arrastar pra outro lado do igual
