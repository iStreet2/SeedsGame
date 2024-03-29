//
//  GameEngine.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation
import SwiftUI
import SpriteKit
import CoreData


@Observable class GameEngine {
    
    static let shared = GameEngine()
    
    var userEngine: UserEngine?
    
    let operators = ["+","-","*","/","(",")"]
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    let seedBagWidth: Double = 50*1.1
    let seedBagHeight: Double  = 70*1.1
    
    let hitBoxWidth: Double = 50*1.1
    let hitBoxHeight: Double = 50*1.1
    
    var realocationPosition = 0
    
    var eqHasZeroRight = false
    var eqHasZeroLeft = false
    
    var finalSeedCreated = false
    var finalSeedTransformed = false
    
    var initialNodePosition = CGPoint(x: 0, y: 0)
    
    var emptySeedBag = SeedBagModel(numero: 0, incognita: false, isOperator: false, operatorr: "", imageNamed: "nothing", color: .clear, width: 50, height: 70)
    
    var actions: [Action] = []
    //var phases: [PhaseScene] = []
    //    var currentPhase = 0
    
    var phaseFirstSetup = true
    
    var mementoStack = Stack()
    
    
    let darknessMap: [Int : SKAction] = [0: SKAction.colorize(with: .black, colorBlendFactor: 0, duration: 0),
                                         1: SKAction.colorize(with: .black, colorBlendFactor: 0.3, duration: 0),
                                         2: SKAction.colorize(with: .black, colorBlendFactor: 0.6, duration: 0)]
    
    let undarknessMap: [Int : SKAction] = [0: SKAction.colorize(with: .black, colorBlendFactor: 0, duration: 1),
                                           1: SKAction.colorize(with: .black, colorBlendFactor: 0.3, duration: 1),
                                           2: SKAction.colorize(with: .black, colorBlendFactor: 0.6, duration: 1)]
    
    let initialBagPosition = CGPoint(x: 200, y: 150)
    let bagSpacing = 55
    
    // MARK: variáveis de controle de vida e fim de fase
    var endOfPhase: Bool = false
    var gameOver: Bool = false
    var gameIsPaused: Bool = false
    var configurationPopUpIsPresented: Bool = false
    var gaveGalacticSeedsToRose = false
    
    init() {
    }
    
    
    func receiveAction(_ action: Action, _ scene: PhaseScene, isTutorial: Bool = false) {
        actions.append(action)
        let res = action.execute()
        if res.contains("=") {
            scene.currentEqLabel.text = res
            addSeedBags(scene: scene)
            addHitBoxesFromEquation(scene: scene)
        }
    }
    
    func tutorialReceiveAction(_ action: Action, _ scene: TutorialPhase, isTutorial: Bool = true) {
        actions.append(action)
        let res = action.execute()
        if res.contains("=") {
            scene.tutorialClient.eq = res
            tutorialAddSeedBags(scene: scene)
            addHitBoxesFromEquation(scene: scene)
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
        
        
        if scene.phase < 2{
            scene.scene?.view?.presentScene(PhaseScene(phase: scene.phase+1, width: width, height: height), transition: reveal)
        }
        else {
            // cena após as 3 fases
            scene.currentEqLabel.text = "All phases done!"
        }
        self.endOfPhase = false
        self.gameOver = false
    }
    
    
    func nextQuestion(scene: PhaseScene, isTutorial: Bool) {
        
        if !isTutorial {
            scene.removeChildren(in: [scene.brilhinho])
            //Essa função atrasa uma quantidade de segundos específicos
            
            self.mementoStack.clear()
            
            self.phaseFirstSetup = true
            
            let nQuestions = scene.clients.count
            
            for (_, client) in scene.clients.enumerated() {
                
                // Aumenta
                //			let scaleFactor = 1
                //
                //			let scaleAction = SKAction.scale(by: CGFloat(scaleFactor)/100, duration: 0.5)
                //			client.run(scaleAction)
                //			if scene.currentClientNumber+index < scene.clients.count {
                //				scene.clients[scene.currentClientNumber+index].run(SKAction.scale(by: 1 + 0.05*CGFloat(index), duration: 0.5))
                //			}
                let scaleAction = SKAction.scale(by: 1.05, duration: 0.5)
                client.run(scaleAction)
                
                // Move
                let moveAction = SKAction.moveTo(x: client.position.x - 75, duration: 0.5)
                client.run(moveAction)
                
                // Animação Lara
                let moveAction1 = SKAction.moveBy(x: 0, y: 100 * 0.02, duration: 0.5)
                let moveAction2 = SKAction.moveBy(x: 0, y: 100 * (-0.02), duration: 0.5)
                let moveSequence = SKAction.sequence([moveAction1, moveAction2])
                client.run(moveSequence)
                
                let rotateAction1 = SKAction.rotate(byAngle: 0.1, duration: 0.3)
                let rotateAction2 = SKAction.rotate(byAngle: -0.1, duration: 0.3)
                let rotateSequence = SKAction.sequence([rotateAction1, rotateAction2])
                client.run(rotateSequence)
                
                // Escurecer o cliente
                for c in scene.currentClientNumber..<scene.clients.count {
                    scene.clients[c].run(self.darknessMap[c - scene.currentClientNumber - 1] ?? SKAction.colorize(with: .black, colorBlendFactor: 0.6, duration: 0.5))
                }
                
                // remove o cliente atual
                if client.eq == scene.clients[scene.currentClientNumber].eq {
                    // Cliente da pergunta atual é despachado
                    scene.removeChildren(in: [client])
                }
            }
            
            // Remove os sacos e hitboxes da tela
            self.removeSeedBagsAndHitboxes(scene)
            
            // renderiza o sprite do próximo cliente no final da fila
            if (scene.currentClientNumber + 3) <= (nQuestions - 1) {
                scene.addChild(scene.clients[scene.currentClientNumber + 3])
            }
            
            // não deixa o número do cliente atual ser maior do que o número de clientes e vê se a pergunta é galática
            if scene.currentClientNumber != nQuestions - 1 {
                scene.currentClientNumber += 1
                scene.currentEqLabel.text = "\(scene.clients[scene.currentClientNumber].eq)"
                if scene.clients[scene.currentClientNumber].wantsGalacticSeeds {
                    scene.eqLabelBackground.texture = SKTexture(imageNamed: "GalacticEquationLabelBackground")
                } else {
                    scene.eqLabelBackground.texture = SKTexture(imageNamed: "equationLabelBackground")
                }
            }
            
            // se todos os clientes tiverem as suas perguntas resolvidas
            else {
                scene.currentEqLabel.text = "All questions done!"
                self.endOfPhase = true
            }
            
            if !scene.children.contains(scene.currentEqLabel) || !scene.children.contains(scene.eqLabelBackground) {
                scene.currentEqLabel.position = CGPoint(x: scene.frame.size.width / 2, y: 325)
                scene.currentEqLabel.zPosition = 12
                
                scene.addChild(scene.eqLabelBackground)
                scene.addChild(scene.currentEqLabel)
            }
            self.finalSeedCreated = false
            
        }
        
    }
    
    func nextQuestionWithDelay(_ scene: PhaseScene){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.userEngine?.life == 0{
                self.gameOver = true
            }
            else{
                self.nextQuestion(scene: scene, isTutorial: false)
            }
        }
    }
    
    
    
    func removeSeedBagsAndHitboxes(_ scene: PhaseScene) {
        for seedbag in scene.currentSeedBags {
            scene.removeChildren(in: [seedbag])
        }
        for hitBox in scene.hitBoxes {
            scene.removeChildren(in: [hitBox])
        }
    }
    
    
    func renderClients(scene: PhaseScene, isTutorial: Bool = false) {
        
        let sceneWidth = scene.size.width
        let sceneHeight = scene.size.height
        
        if !isTutorial {
            for (index, client) in scene.clients.enumerated() {
                // se forem os três primeiros
                if index < 3 {
                    let positionX = Int(0.786 * sceneWidth)
                    let positionY = Int(0.602 * sceneHeight)
                    client.position = CGPoint(x: positionX + (75*index), y: positionY)
                }
                // restante dos clientes
                else {
                    let positionX = Int(sceneWidth + client.size.width / 2)
                    let positionY = Int(0.602 * sceneHeight)
                    client.position = CGPoint(x: positionX, y: positionY)
                }
                
                client.setScale(1 - (0.05*CGFloat(index))) // diminui os clientes
                client.zPosition = CGFloat(scene.clients.count - index)  // deixa um cliente atrás do outro
                
                client.run(darknessMap[index] ?? SKAction.colorize(with: .black, colorBlendFactor: 0.6, duration: 0))  // escurece o cliente
                
                // se forem os três clientes, eles são renderizados
                if index<3 {
                    scene.addChild(client)
                }
            }
            
            //
            scene.currentEqLabel.text = "\(scene.clients[scene.currentClientNumber].eq)"
        }
    }
    
    
    func moveFirstClientToFront(_ scene: PhaseScene) {
        let firstClient = scene.clients[scene.currentClientNumber]
        let action = SKAction.move(to: CGPoint(x: scene.size.width / 2, y: firstClient.position.y), duration: 1)
        
        let moveAction1 = SKAction.moveBy(x: 0, y: 100 * 0.02, duration: 0.5)
        let moveAction2 = SKAction.moveBy(x: 0, y: 100 * (-0.02), duration: 0.5)
        let moveSequence = SKAction.sequence([moveAction1, moveAction2])
        firstClient.run(moveSequence)
        
        let rotateAction1 = SKAction.rotate(byAngle: 0.1, duration: 0.3)
        let rotateAction2 = SKAction.rotate(byAngle: -0.1, duration: 0.3)
        let rotateSequence = SKAction.sequence([rotateAction1, rotateAction2])
        firstClient.run(rotateSequence)
        
        if firstClient.wantsGalacticSeeds {
            scene.brilhinho.zPosition = 14
            scene.brilhinho.position = CGPoint(x: scene.frame.size.width / 2 - 10, y: scene.frame.size.height / 2 + scene.frame.size.height / 4)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                scene.addChild(scene.brilhinho)
            }
        }
        
        scene.removeChildren(in: [scene.currentEqLabel, scene.eqLabelBackground])
        firstClient.run(action)
    }
    
    func initialMove(_ scene: PhaseScene){
        let firstClient = scene.clients[scene.currentClientNumber]
        
        let rotateAction1 = SKAction.rotate(byAngle: 0.1, duration: 0.3)
        let rotateAction2 = SKAction.rotate(byAngle: -0.1, duration: 0.3)
        let rotateSequence = SKAction.sequence([rotateAction1, rotateAction2])
        firstClient.run(rotateSequence)
    }
    
    // Função para mexer seeBagModels
    func moveSeedBag(_ node: SeedBagModel, _ touches: Set<UITouch>, stage: Int, initialPosition: Int, scene: PhaseScene, isTutorial: Bool) -> Bool{
        
        if stage == 0{
            if let touch = touches.first{
                let location = touch.location(in: scene.self)
                if node.contains(location){
                    self.initialNodePosition = node.position
                    scene.movableNode = node
                    if inParentheses(initialPosition, scene){
                        scene.movableNode = nil
                    }else{
                        scene.movableNode!.position = location
                        scene.movableNode!.zPosition = 12
                    }
                    return true
                }else{
                    return false
                }
            }
            
        }else if stage == 1{
            if let touch = touches.first {
                if scene.movableNode != nil{
                    scene.movableNode!.position = touch.location(in: scene.self)
                    return true
                }
            }
        }else if stage == 2{ //TOUCHES ENDED!!!!!
            if let touch = touches.first {
                if scene.movableNode != nil{
                    scene.movableNode!.position = touch.location(in: scene.self)
                    
                    //Antes de deixar o movableNode em nil, eu chamo o grabNode, para que se o nó que o usuário estiver movendo, se prenda ao quadrado, se esse nó estive em cima do quadrado
                    
                    if grabNode(touches: touches, scene: scene){ //Se o nó foi soltado em alguma hitBox que consiga segurar ele
                        
                        //Eu preciso checar se ele deixar o saco em algum lado que tem um zero, o zero tem que sumir
                        
                        removeZeroIfItNeedsTo(scene: scene)
                        
                        let fromLeft = fromLeft(scene) //Checa se o elemento esta sendo arrastado da esquerda
                        
                        if fromLeft{ //Se o usuário estiver arrastando da esquerda para a direita
                            realocateFromLeft(scene: scene) //Função que realoca os sinais também a partir da esquerda
                        }else{ //Se o usuário estiver arrastando da direita para a esquerda
                            realocateFromRight(scene: scene) //Função que realoca os sinais também a partir da direita
                        }
                        //Depois de realocar preciso checar se não tem algum lado sem nada
                        addZeroIfItNeedsTo(scene: scene)
                        
                        
                        //Depois de realocar preciso atualizar as equações na tela
                        showEquation(scene: scene, isTutorial: isTutorial)
                        
                        scene.movableNode = nil
                        
                    }else if finalSeedCreated{ //Se a semente final esta criada
                        
                        transformSeed(touches, scene) //Transformar
                        if grabResult(touches, scene){
                            renderClientResponse(scene)
                        }
                        
                    }
                    else{ //Se nao ele só volta para sua posição inicial
                        resetPosition(scene: scene)
                        scene.movableNode = nil
                    }
                    return true
                }
            }
        }
        return false
    }
    
    
    func tutorialMoveSeedBag(_ node: SeedBagModel, _ touches: Set<UITouch>, stage: Int, initialPosition: Int, scene: TutorialPhase, isTutorial: Bool){
        
        if stage == 0{
            if let touch = touches.first{
                let location = touch.location(in: scene.self)
                if node.contains(location){
                    self.initialNodePosition = node.position
                    scene.movableNode = node
                    if inParentheses(initialPosition, scene){
                        scene.movableNode = nil
                    }else{
                        scene.movableNode!.position = location
                        scene.movableNode!.zPosition = 30
                    }
                }
            }
        }else if stage == 1{
            if let touch = touches.first {
                if scene.movableNode != nil{
                    scene.movableNode!.position = touch.location(in: scene.self)
                }
            }
        }else if stage == 2{ //TOUCHES ENDED!!!!!
            if let touch = touches.first {
                if scene.movableNode != nil{
                    scene.movableNode!.position = touch.location(in: scene.self)
                    
                    //Antes de deixar o movableNode em nil, eu chamo o grabNode, para que se o nó que o usuário estiver movendo, se prenda ao quadrado, se esse nó estive em cima do quadrado
                    
                    if grabNode(touches: touches, scene: scene){ //Se o nó foi soltado em alguma hitBox que consiga segurar ele
                        
                        //Eu preciso checar se ele deixar o saco em algum lado que tem um zero, o zero tem que sumir
                        
                        removeZeroIfItNeedsTo(scene: scene)
                        
                        let fromLeft = fromLeft(scene) //Checa se o elemento esta sendo arrastado da esquerda
                        
                        if fromLeft{ //Se o usuário estiver arrastando da esquerda para a direita
                            realocateFromLeft(scene: scene) //Função que realoca os sinais também a partir da esquerda
                        }else{ //Se o usuário estiver arrastando da direita para a esquerda
                            realocateFromRight(scene: scene) //Função que realoca os sinais também a partir da direita
                        }
                        //Depois de realocar preciso checar se não tem algum lado sem nada
                        addZeroIfItNeedsTo(scene: scene)
                        
                        
                        //Depois de realocar preciso atualizar as equações na tela
                        tutorialShowEquation(scene: scene, isTutorial: isTutorial)
                        
                        scene.movableNode = nil
                        
                    }else if finalSeedCreated{ //Se a semente final esta criada
                        
                        transformSeed(touches, scene) //Transformar
                        if grabResult(touches, scene){
                            if scene.currentFala == 11 {
                                tutorialRenderClientResponse(scene, node: scene.tutorialClient)
                            } else if scene.currentFala > 11 && scene.isPlaying {
                                tutorialRenderGalacticClientResponse(scene, node: scene.tutorialClient)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    GameEngine.shared.removeSeedBagsAndHitboxes(scene)
                                }
                                scene.isPlaying = false
                            }
                        }
                        
                    }
                    else{ //Se nao ele só volta para sua posição inicial
                        resetPosition(scene: scene)
                        scene.movableNode = nil
                    }
                }
            }
        }
        
    }
    
    
    func invertOperator(_ node: SeedBagModel, _ touches: Set<UITouch>, _ position: Int, _ scene: PhaseScene, isTutorial: Bool = false) -> Bool{
                
        node.invertOperator(node, touches, position, scene)
        showEquation(scene: scene, isTutorial: isTutorial)
        return true
        
    }
    
    func tutorialInvertOperator(_ node: SeedBagModel, _ touches: Set<UITouch>, _ position: Int, _ scene: TutorialPhase, isTutorial: Bool = true) {
        if let touch = touches.first{
            let location = touch.location(in: scene.self)
            if scene.movableNode == nil{
                if node.contains(location){
                    //Inverto o sinal na label do laço
                    if node.label.text == "+"{
                        scene.currentSeedBags[position].label.text = "-"
                    }else if node.label.text == "-"{
                        scene.currentSeedBags[position].label.text = "+"
                    }else if node.label.text == "*"{
                        scene.currentSeedBags[position].label.text = "/"
                    }else if node.label.text == "/"{
                        scene.currentSeedBags[position].label.text = "*"
                    }
                    //Atualizo na tela
                    tutorialShowEquation(scene: scene, isTutorial: isTutorial)
                }
            }
        }
    }
    
    
    //Adiciona hitBoxes com base no tamanho da equação dada pelo cliente!
    func addHitBoxesFromEquation(scene: PhaseScene){
        //Remover as hitBoxes da questão anterior
        if scene.hitBoxes.count != 0{
            for hitBox in scene.hitBoxes{
                scene.removeChildren(in: [hitBox])
            }
            scene.hitBoxes.removeAll()
        }
        
        //Adicionar no vetor novamente os nos dos quadrados
        for _ in 0...10{
            let node = SKShapeNode(rectOf: CGSize(width: hitBoxWidth, height: hitBoxHeight))
            scene.hitBoxes.append(node)
        }
        //Adicionar na cena as hitBoxes
        for (index,hitBox) in scene.hitBoxes.enumerated(){
            hitBox.position = CGPoint(x: initialBagPosition.x+CGFloat((bagSpacing*index)), y: initialBagPosition.y)
            hitBox.zPosition = 11
            hitBox.strokeColor = .clear
            scene.addChild(hitBox)
        }
    }
    
    //Adiciona uma hitBox a mais no final da equação
    func addHitBoxAtTheEnd(scene: PhaseScene){
//        let node = SKShapeNode(rectOf: CGSize(width: hitBoxWidth, height: hitBoxHeight)) //Crio mais uma hitbox
//        node.position = CGPoint(x: initialBagPosition.x+CGFloat((bagSpacing*scene.hitBoxes.count)), y: initialBagPosition.y)//Defino a posição dele com base na posição da ultima hitBox
//        node.zPosition = 11
//        node.strokeColor = .clear //Defino a cor dele de vermelho
//        scene.hitBoxes.append(node) //Adiciono ela no vetor de hitBoxes
//        scene.addChild(node) //Adiciono ela na cena
        
    }
    
    func removeHitBoxAtTheEnd(scene: PhaseScene){
//        scene.removeChildren(in: [scene.hitBoxes[scene.hitBoxes.count-1]]) //Removo da cena a hitBox do final
//        scene.hitBoxes.removeLast() //Removo do vetor a hitbox do final
    }
    
    func removeFirstHitBox(scene: PhaseScene){
//        scene.removeChildren(in: [scene.hitBoxes[0]]) //Removo da cena a hitbox do começo
//        scene.hitBoxes.removeFirst() //removo do vetor
    }
    
    func addSeedBags(scene: PhaseScene, isTutorial: Bool = false){
        
        clearSeedsOfScene(scene)
        clearSeedOfList(scene)
        
        if !scene.currentEqLabel.text!.contains("!") {
            //Transformo a string da equação em um vetor de caracteres
            let equation = isTutorial ? OperationAction.joinAllNumbers(TutorialClientModel.shared.eq) : OperationAction.joinAllNumbers(scene.currentEqLabel.text!)
            
            for (index,char) in equation.enumerated(){
                if char.isNumber{
                    scene.currentSeedBags.append(SeedBagModel(numero: Int(String(char)) ?? 300, incognita: false, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight))
                }else if char == "x"{
                    //Se eu encontrar um X com um valor anterior a ele, eu adiciono um "*" entre a sacola do número e a sacola do x
                    if index != 0{
                        if  equation[index-1].isNumber{
                            scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "*", imageNamed: "operacoes", color: .clear, width: 44, height: 44))
                            addHitBoxAtTheEnd(scene: scene)
                        }
                    }
                    scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: true, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight))
                    
                }else if char == "="{
                    scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: String(char), imageNamed: "igual", color: .clear, width: 22.45, height: 30.73))
                }else if char == "("{
                    scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "(", imageNamed: "parenteses esq", color: .clear, width: 31.3, height: 44.44))
                }else if char == ")"{
                    scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: ")", imageNamed: "parenteses dir", color: .clear, width: 31.3, height: 44.44))
                }
                else {
                    scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: String(char), imageNamed: "operacoes", color: .clear, width: 44, height: 44))
                }
            }
            //Depois de preparar o vetor, adiciono na cena
            showEquation(scene: scene, isTutorial: isTutorial)
            
        }
    }
    
    func tutorialAddSeedBags(scene: TutorialPhase, isTutorial: Bool = true) {
        
        clearSeedsOfScene(scene)
        clearSeedOfList(scene)
        
        if !scene.currentEqLabel.text!.contains("!") {
            //Transformo a string da equação em um vetor de caracteres
            let equation = isTutorial ? OperationAction.joinAllNumbers(scene.tutorialClient.eq) : OperationAction.joinAllNumbers(scene.currentEqLabel.text!)
            
            for (index,char) in equation.enumerated(){
                if char.isNumber{
                    scene.currentSeedBags.append(SeedBagModel(numero: Int(String(char)) ?? 300, incognita: false, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight))
                }else if char == "x"{
                    //Se eu encontrar um X com um valor anterior a ele, eu adiciono um "*" entre a sacola do número e a sacola do x
                    if index != 0{
                        if  equation[index-1].isNumber{
                            scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "*", imageNamed: "operacoes", color: .clear, width: 44, height: 44))
                            addHitBoxAtTheEnd(scene: scene)
                        }
                    }
                    scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: true, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight))
                    
                }else if char == "="{
                    scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: String(char), imageNamed: "igual", color: .clear, width: 22.45, height: 30.73))
                }
                else {
                    scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: String(char), imageNamed: "operacoes", color: .clear, width: 44, height: 44))
                }
            }
            //Depois de preparar o vetor, adiciono na cena
            tutorialShowEquation(scene: scene, isTutorial: isTutorial)
            
        }
    }
    
    func updateCurrentEqLabel(scene: PhaseScene, isTutorial: Bool = false) {
        var equation = ""
        for (index, seedBag) in scene.currentSeedBags.enumerated() {
            if seedBag.label.text == "?" {
                equation += "x"
            }
            else if seedBag.label.text! == "*" {
                if scene.currentSeedBags[index+1].label.text! != "?" {
                    equation += "*"
                }
            }
            else {
                equation += seedBag.label.text!
            }
        }
        if isTutorial {
            TutorialClientModel.shared.eq = equation
        } else {
            scene.currentEqLabel.text = equation
        }
    }
    
    
    func tutorialUpdateCurrentEqLabel(scene: TutorialPhase, isTutorial: Bool = true) {
        var equation = ""
        for (index, seedBag) in scene.currentSeedBags.enumerated() {
            if seedBag.label.text == "?" {
                equation += "x"
            }
            else if seedBag.label.text! == "*" {
                if scene.currentSeedBags[index+1].label.text! != "?" {
                    equation += "*"
                }
            }
            else {
                equation += seedBag.label.text!
            }
        }
        scene.tutorialClient.eq = equation
    }
    
    func showEquation(scene: PhaseScene, isTutorial: Bool = false){
        
        
        updateCurrentEqLabel(scene: scene, isTutorial: isTutorial)
        
        
        clearSeedsOfScene(scene)
        
        for (index,seedBag) in scene.currentSeedBags.enumerated(){
            seedBag.position = CGPoint(x: initialBagPosition.x+CGFloat((bagSpacing*index)), y: initialBagPosition.y) //Posicao da sacola com o numero, mexo com o index para colocar na posição certa da equação
            
            seedBag.zPosition = 11
            
            scene.addChild(seedBag)
        }
    }
    
    
    func tutorialShowEquation(scene: TutorialPhase, isTutorial: Bool = true) {
        
        tutorialUpdateCurrentEqLabel(scene: scene, isTutorial: isTutorial)
        
        clearSeedsOfScene(scene)
        
        for (index, seedBag) in scene.currentSeedBags.enumerated() {
            seedBag.position = CGPoint(x: initialBagPosition.x+CGFloat((bagSpacing*index)), y: initialBagPosition.y) //Posicao da sacola com o numero, mexo com o index para colocar na posição certa da equação
            
            seedBag.zPosition = 11
            
            scene.addChild(seedBag)
        }
    }
    
    func clearSeedsOfScene(_ scene: PhaseScene){
        if scene.currentSeedBags.count != 0{
            for seedBag in scene.currentSeedBags{
                scene.removeChildren(in: [seedBag])
            }
        }
    }
    
    func clearSeedOfList(_ scene: PhaseScene){
        if scene.currentSeedBags.count != 0{
            scene.currentSeedBags.removeAll()
        }
    }
    
    
    func grabNode(touches: Set<UITouch>, scene: PhaseScene) -> Bool{
        if let touch = touches.first{
            if scene.movableNode != nil{
                let location = touch.location(in: scene.self)
                for (index,hitBox) in scene.hitBoxes.enumerated(){
                    if hitBox.contains(location){
                        realocationPosition = index
                        if tradeIsPossible(scene){ //Se a troca for possível, eu agarro
                            scene.movableNode!.position = hitBox.position
                            return true
                        }else{ //Porem se não for, eu não agarro e o movableNode se torna nulo, para não mexer mais
                            return false
                        }
                    }
                }
            }
        }
        return false
    }
    
    func realocateToOtherSide(_ position: Int, _ scene: PhaseScene){ //Nessa função, o destino de realocação do nó é sempre no ultimo elemento do lado para onde esta sendo realocado.
        
        if fromLeft(scene){//se eu estiver arrastado o elemento da esquerda para a direita
            let currentSeedBag = scene.currentSeedBags[position] //salvo o valor no qual estou pegando
            
            //Vamos la, aqui eu quero arrastar um elemento da esquerda para a direita :D
            scene.currentSeedBags.remove(at: position) //Removo da posição dele
            scene.currentSeedBags.append(currentSeedBag) //Coloco no final
            
        }
        else{ //Se eu estiver arrastando o elemento da direita para a esquerda
            let equalPosition = getEqual(scene: scene) //Procuro onde esta o sinal de igual para colocar o elemento atual nessa posição
            
            let currentSeedBag = scene.currentSeedBags[position] //salvo o valor que estou pegando
            
            scene.currentSeedBags.remove(at: position)
            scene.currentSeedBags.insert(currentSeedBag, at: equalPosition)
        }
    }
    
    func realocateFromLeft(scene: PhaseScene){ //Realoca com sinal os elementos
        
        if isIncognita(scene) && moreThanOneIncognita(scene){ //Se o que o usuário estiver mexendo for uma incognita, seja o "3" ou o "?" de um "3*?"
            //Se tiver mais de uma incognita na equação
            if scene.currentSeedBags[getMovableNodePosition(scene)].label.text! == "?" && scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text! == "*"{ //se o usuário estiver mexendo o "?" e tiver algum número multiplicando ele
                if getMovableNodePosition(scene)-2 == 0{ //Se antes do número que esta multiplicando o X nao tiver nenhum sinal, ou seja, o número estiver na posição zero
                    scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "+", imageNamed: "operacoes", color: .clear, width: 44, height: 44)) //Adiciono um sinal de "+" no final da equação
                    addHitBoxAtTheEnd(scene: scene)
                    realocateToOtherSide(getMovableNodePosition(scene)-2, scene) //Aloco o numero que esta multiplicando o x
                    realocateToOtherSide(getMovableNodePosition(scene)-1, scene) //Aloco o simbolo de multiplicação
                    realocateToOtherSide(getMovableNodePosition(scene), scene) //Realoco o x
                }else{ //Se tem um sinal
                    realocateToOtherSide(getMovableNodePosition(scene)-3, scene) //Realoco o sinal antes do numero que miltiplica o x
                    realocateToOtherSide(getMovableNodePosition(scene)-2, scene) //Aloco o numero que esta multiplicando o x
                    realocateToOtherSide(getMovableNodePosition(scene)-1, scene) //Aloco o simbolo de multiplicação
                    realocateToOtherSide(getMovableNodePosition(scene), scene) //Realoco o x
                }
            }else{//Se o x estiver sozinho
                if operators.contains(scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text!){ //Se tiver um sinal ao lado dele, - ou +, preciso realocar esse sinal depois o x
                    realocateToOtherSide(getMovableNodePosition(scene)-1, scene) //realoco o sinal
                    realocateToOtherSide(getMovableNodePosition(scene), scene) //realoco o x
                }else{
                    scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "+", imageNamed: "operacoes", color: .clear, width: 44, height: 44)) //Adiciono um sinal de "+" no final da equação
                    realocateToOtherSide(getMovableNodePosition(scene), scene) //realoco o x
                    addHitBoxAtTheEnd(scene: scene)
                }
            }
            
        }else if getMovableNodePosition(scene) != 0{
            //Se, quando eu for realocar um elemento, antes dele ouver algum sinal, esse sinal tem que ir junto
            if operators.contains(scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text!){
                if scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text! == "*" || scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text! == "/"{ //Se for "*" ou "/"
                    if scene.currentSeedBags[getMovableNodePosition(scene)-2].label.text! == ")"{ //se antes do sinal de multiplicação for um parenteses fechando
                        removeParentheses(scene) //Precisaria remover parenteses certo, tipo, saber de onde estou tirando o numero
                    }
                    
                    if getNumRightEqual(scene) > 1{ //Se a quantidade de numeros do lado direito da equação for maior que 1
                        //Adiciono os parênteses!
                        addParenthesesRight(scene) //Precisaria adicionar parenteses certo
                    }
                    realocateToOtherSide(getMovableNodePosition(scene)-1,scene) //Realoco o sinal, que esta uma posição anterior ao numero
                    realocateToOtherSide(getMovableNodePosition(scene), scene) //Realoco o número
                    
                }
                
                else if scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text! == "-" && scene.currentSeedBags[getMovableNodePosition(scene)+1].label.text! == "*"{ //Se antes tiver um menos e depois um vezes
                    realocateToOtherSide(getMovableNodePosition(scene)+1, scene) //Realoco o vezes
                    realocateToOtherSide(getMovableNodePosition(scene)-1, scene) //Realoco o menos
                    realocateToOtherSide(getMovableNodePosition(scene), scene) //Realoco o número
                    addParentheses(open: getMovableNodePosition(scene)-1, close: getMovableNodePosition(scene)+2, scene) //Adiciono um parênteses entre o menos e o final do numero
                }else{
                    realocateToOtherSide(getMovableNodePosition(scene)-1,scene) //Realoco o sinal, que esta uma posição anterior ao numero
                    realocateToOtherSide(getMovableNodePosition(scene), scene) //Realoco o número
                }
            }
        }else if scene.currentSeedBags[getMovableNodePosition(scene)+1].label.text! == "*" || scene.currentSeedBags[getMovableNodePosition(scene)+1].label.text! == "/"{ //Se depois do numero tiver um * ou um "/"
            if getNumRightEqual(scene) > 1{ //Se a quantidade de numeros do lado direito da equação for maior que 1
                //Adiciono os parênteses!
                addParenthesesRight(scene)
                
            }
            realocateToOtherSide(getMovableNodePosition(scene)+1,scene) //Realoco o sinal que esta na frente do numero
            realocateToOtherSide(getMovableNodePosition(scene), scene) //Realoco o número
        }
        else{ //Se não houver um sinal antes, eu preciso criar um sinal de mais, criar uma hitbox, e realocar
            addHitBoxAtTheEnd(scene: scene) //adiciono uma hitbox ao final
            scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "+", imageNamed: "operacoes", color: .clear, width: 44, height: 44)) //adiciono ao final do vetor um sinal de mais
            realocateToOtherSide(getMovableNodePosition(scene), scene) //Realoco o nó que esta sendo mexido
        }
    }
    
    func realocateFromRight(scene: PhaseScene){ //realoca com sinal os elementos
        
        if isIncognita(scene) && moreThanOneIncognita(scene){ //Se o que o usuário estiver mexendo for uma incognita, seja o "3" ou o "?" de um "3*?"
            //Se tiver mais de uma incognita na equação
            if scene.currentSeedBags[getMovableNodePosition(scene)].label.text! == "?" && scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text! == "*"{ //se o usuário estiver mexendo o "?" e tiver algum número multiplicando ele
                if scene.currentSeedBags[getMovableNodePosition(scene)-3].label.text! == "="{ //Se antes do número que esta multiplicando o X nao tiver nenhum sinal, ou seja, estiver do lado do igual, eu preciso adicionar o mais
                    scene.currentSeedBags.insert(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "+", imageNamed: "operacoes", color: .clear, width: 44, height: 44), at: getEqual(scene: scene)) //Adiciono um valor de mais antes do igual
                    addHitBoxAtTheEnd(scene: scene)
                    realocateToOtherSide(getMovableNodePosition(scene)-2, scene) //Aloco o numero que esta multiplicando o x
                    realocateToOtherSide(getMovableNodePosition(scene)-1, scene) //Aloco o simbolo de multiplicação
                    realocateToOtherSide(getMovableNodePosition(scene), scene) //Realoco o x
                }else{ //Se tem um sinal
                    realocateToOtherSide(getMovableNodePosition(scene)-3, scene) //Realoco o sinal antes do numero que miltiplica o x
                    realocateToOtherSide(getMovableNodePosition(scene)-2, scene) //Aloco o numero que esta multiplicando o x
                    realocateToOtherSide(getMovableNodePosition(scene)-1, scene) //Aloco o simbolo de multiplicação
                    realocateToOtherSide(getMovableNodePosition(scene), scene) //Realoco o x
                }
            }else{//Se o x estiver sozinho
                if operators.contains(scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text!){ //Se tiver um sinal ao lado dele, - ou +, preciso realocar esse sinal depois o x
                    realocateToOtherSide(getMovableNodePosition(scene)-1, scene) //realoco o sinal
                    realocateToOtherSide(getMovableNodePosition(scene), scene) //realoco o x
                }else{
                    scene.currentSeedBags.insert(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "+", imageNamed: "operacoes", color: .clear, width: 44, height: 44), at: getEqual(scene: scene)) //Adiciono um valor de mais antes do igual
                    realocateToOtherSide(getMovableNodePosition(scene), scene) //realoco o x
                    addHitBoxAtTheEnd(scene: scene)
                }
            }
            
        }
        
        //Se quando eu for realocar um elemento, antes dele ouver algum sinal, esse sinal tem que ir junto
        else if operators.contains(scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text!){ //Se na posição anterior do número que eu estou vendo, tiver um sinal
            if scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text! == "*" || scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text! == "/"{ //Se esse sinal for "*" ou "/"
                
                if scene.currentSeedBags[getMovableNodePosition(scene)-2].label.text! == ")"{ //Se antes da multiplicação tiver um parenteses fechando
                    removeParentheses(scene)
                }
                
                if getNumLeftEqual(scene) > 1{ //Se a quantidade de numeros do lado direito da equação for maior que 1
                    //Adiciono os parênteses!
                    addParenthesesLeft(scene)
                }
                realocateToOtherSide(getMovableNodePosition(scene)-1,scene) //Eu pego o sinal, realoco ele pra esquerda
                realocateToOtherSide(getMovableNodePosition(scene), scene)  //Realoco o número
                
            }else if scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text! == "-" && getMovableNodePosition(scene) != scene.currentSeedBags.count-1 && scene.currentSeedBags[getMovableNodePosition(scene)+1].label.text! == "*"{ //Se antes do numero tiver um "-" e depois um "*", e ele nâo for o ultimo elemento do vetor
                realocateToOtherSide(getMovableNodePosition(scene)+1, scene) //Realoco o vezes
                realocateToOtherSide(getMovableNodePosition(scene)-1, scene) //Realoco o menos
                realocateToOtherSide(getMovableNodePosition(scene), scene) //Realoco o número
                addParentheses(open: getMovableNodePosition(scene)-1, close: getMovableNodePosition(scene)+2, scene) //Adiciono um parênteses entre o menos e o final do numero
                
            }else{
                realocateToOtherSide(getMovableNodePosition(scene)-1,scene) //Eu pego o sinal, realoco ele pra esquerda
                realocateToOtherSide(getMovableNodePosition(scene), scene)  //Realoco o número
            }
            
        }else if getMovableNodePosition(scene) != scene.currentSeedBags.count-1{ //Se não for a ultima posição do vetor
            if scene.currentSeedBags[getMovableNodePosition(scene)+1].label.text! == "*" || scene.currentSeedBags[getMovableNodePosition(scene)+1].label.text! == "/"{ //Se depois do numero tiver um * ou um "/"
                
                if getNumLeftEqual(scene) > 1{ //Se a quantidade de numeros do lado esquerdo da equação for maior que 1
                    //Adiciono os parênteses!
                    addParenthesesLeft(scene)
                }
                
                realocateToOtherSide(getMovableNodePosition(scene)+1,scene) //Realoco o sinal que esta na frente da posição inicial
                realocateToOtherSide(getMovableNodePosition(scene),scene) //Realoco o número
            }
            else{ //Se não houver um sinal antes, eu preciso criar um sinal de mais, criar uma hitbox, e realocar
                addHitBoxAtTheEnd(scene: scene) //adiciono uma hitbox ao final
                scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "+", imageNamed: "operacoes", color: .clear, width: 44, height: 44)) //adiciono ao final do vetor um sinal de mais
                //            self.initialPosition += 1
                realocateToOtherSide(scene.currentSeedBags.count-1,scene) //realoco o sinal que eu acabei de inserir na ultima posição
                realocateToOtherSide(getMovableNodePosition(scene), scene) //realoco o elemento que o usuario passou
            }
        }
        else{ //Se não houver um sinal antes, eu preciso criar um sinal de mais, criar uma hitbox, e realocar
            addHitBoxAtTheEnd(scene: scene) //adiciono uma hitbox ao final
            scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "+", imageNamed: "operacoes", color: .clear, width: 44, height: 44)) //adiciono ao final do vetor um sinal de mais
            //            self.initialPosition += 1
            realocateToOtherSide(scene.currentSeedBags.count-1,scene) //realoco o sinal que eu acabei de inserir na ultima posição
            realocateToOtherSide(getMovableNodePosition(scene), scene) //realoco o elemento que o usuario passou
        }
    }
    
    
    func isIncognita(_ scene: PhaseScene) -> Bool{
        
        if getMovableNodePosition(scene) < scene.currentSeedBags.count-2 && scene.currentSeedBags[getMovableNodePosition(scene)].label.text!.isNumber && scene.currentSeedBags[getMovableNodePosition(scene)+1].label.text! == "*" && scene.currentSeedBags[getMovableNodePosition(scene)+2].label.text! == "?"{ //Aqui eu estou checando valores depois do numero, entao esse numero só nao pode ser o ultimo da equação!
            return true
        }
        
        if getMovableNodePosition(scene) > 1 && scene.currentSeedBags[getMovableNodePosition(scene)].label.text! == "?" && scene.currentSeedBags[getMovableNodePosition(scene)-1].label.text! == "*" && scene.currentSeedBags[getMovableNodePosition(scene)-2].label.text!.isNumber{ //Aqui eu checo valores antes do nó, entao ele nao pode estar na posicao 0 nem 1
            return true
        }
        else if scene.currentSeedBags[getMovableNodePosition(scene)].label.text! == "?"{
            return true
        }
    
        return false
    }
    
    func isIncognitaEspecifc(index: Int, _ scene: PhaseScene) -> Bool{
        
        if index < scene.currentSeedBags.count-2 && scene.currentSeedBags[index].label.text!.isNumber && scene.currentSeedBags[index+1].label.text! == "*" && scene.currentSeedBags[index+2].label.text! == "?"{
            return true
        }
        
        else if index > 1 && scene.currentSeedBags[index].label.text! == "?" && scene.currentSeedBags[index-1].label.text! == "*" && scene.currentSeedBags[index-2].label.text!.isNumber{
            return true
        }
        else if scene.currentSeedBags[index].label.text! == "?"{
            return true
        }
        
        return false
    }
    
    
    func moreThanOneIncognita(_ scene: PhaseScene) -> Bool{
        var count = 0
        for seedBag in scene.currentSeedBags{
            if seedBag.label.text == "?"{
                count += 1
            }
        }
        if count > 1{
            return true
        }else{
            return false
        }
    }
    
    func resetPosition(scene: PhaseScene){
        scene.movableNode?.position = initialNodePosition
    }
    
    func getEqual(scene: PhaseScene) -> Int{
        for i in 0..<scene.currentSeedBags.count{
            if scene.currentSeedBags[i].label.text == "="{
                return i
            }
        }
        return 0
    }
    
    func fromLeft(_ scene: PhaseScene) -> Bool{ //Checo se o elemento que esta sendo arrastado esta vindo da esquerda para a direita
        
        if getEqual(scene: scene) > getMovableNodePosition(scene){
            return true
        }else{
            return false
        }
    }
    
    func addZeroIfItNeedsTo(scene: PhaseScene){
        let equalPosition = getEqual(scene: scene)
        
        if equalPosition == 0{ //Se o igual esta na primeira posição
            let zero = SeedBagModel(numero: 0, incognita: false, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight) //Crio o zero que vai ser adicionado
            scene.currentSeedBags.insert(zero, at: 0) //Adiciono o zero na posição zero
            addHitBoxAtTheEnd(scene: scene) //Coloco mais uma hitBox
            self.eqHasZeroLeft = true //Agora a equação tem um zero
            
        }else if equalPosition == scene.currentSeedBags.count-1{ //Se o igual esta na ultima posição
            addHitBoxAtTheEnd(scene: scene) //adiciono uma hitbox ao final da equação
            let zero = SeedBagModel(numero: 0, incognita: false, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight) //Crio o zero que vai ser adicionado
            scene.currentSeedBags.append(zero) //adiciono o zero ao final, pront :)
            self.eqHasZeroRight = true
        }
    }
    
    func removeZeroIfItNeedsTo(scene: PhaseScene){
        
        if eqHasZeroRight{
            if scene.currentSeedBags[scene.currentSeedBags.count-1].label.text == "0"{ //Se a o valor da ultima posição do vetor for 0
                scene.removeChildren(in: [scene.currentSeedBags[scene.currentSeedBags.count-1]])
                scene.currentSeedBags.removeLast() //Eu removo do vetor
                removeHitBoxAtTheEnd(scene: scene) //Removo a ultima hitBox
                eqHasZeroRight = false
            }
        }
        else if eqHasZeroLeft{ //E O PROBLMEA ESTA AQUI!
            if scene.currentSeedBags[0].label.text == "0"{ //Se o primeiro elemento no vetor das sementes vale 0
                scene.removeChildren(in: [scene.currentSeedBags[0]])
                scene.currentSeedBags.removeFirst() //Removo o zero do vetor
                removeHitBoxAtTheEnd(scene: scene) //Removo uma hitbox
                eqHasZeroLeft = false //Equação não tem mais zero a esquerda
            }
        }
    }
    
    func tradeIsPossible(_ scene: PhaseScene) -> Bool{
        if fromLeft(scene){
            if realocationPosition > getEqual(scene: scene){ //Se a posição de realocação estiver depois do igual, em uma posição maior
                return true //possível realizar a troca
            }
        }
        
        if !fromLeft(scene){
            if realocationPosition < getEqual(scene: scene){ //Se a posição de realocação estiver depois do igual, em uma posição menor
                return true //possível realizar a troca
            }
        }
        return false
    }
    
    func getNumRightEqual(_ scene: PhaseScene) -> Int{
        let equalPosition = getEqual(scene: scene) //Acho a posição do "="
        var num = 0
        for i in equalPosition..<scene.currentSeedBags.count{ //A partir dessa posição até o final do vetor
            if scene.currentSeedBags[i].label.text!.isNumber{
                num += 1
            }else if scene.currentSeedBags[i].label.text! == "?"{
                num += 1
            }
        }
        return num
    }
    
    func getNumLeftEqual(_ scene: PhaseScene) -> Int{
        let equalPosition = getEqual(scene: scene) //Acho a posição do "="
        var num = 0
        for i in stride(from: equalPosition, through: 0, by: -1){ //A partir dessa posição até o final do vetor
            if scene.currentSeedBags[i].label.text!.isNumber{
                num += 1
            }else if scene.currentSeedBags[i].label.text! == "?"{
                num += 1
            }
        }
        return num
    }
    
    func addParenthesesRight(_ scene: PhaseScene){
        
        let equalPosition = getEqual(scene: scene) //Acho a posição do "="
        scene.currentSeedBags.insert(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "(", imageNamed: "parenteses esq", color: .clear, width: 31.3, height: 44.44), at: equalPosition+1)//Adiciono o parenteses logo depois do igual
        addHitBoxAtTheEnd(scene: scene) //adiciono uma hitbox no final para aguentar a adição de 1 elemento
        addHitBoxAtTheEnd(scene: scene) //adiciono outra hitbox para o parenteses do final
        scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: ")", imageNamed: "parenteses dir", color: .clear, width: 31.3, height: 44.44)) //adiciono o parenteses no final :D
    }
    
    func addParenthesesLeft(_ scene: PhaseScene){
        
        scene.currentSeedBags.insert(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "(", imageNamed: "parenteses esq", color: .clear, width: 31.3, height: 44.44), at: 0) //Insiro na primeira posição um parênteses fechando
        addHitBoxAtTheEnd(scene: scene) //Adiciono uma hitBox
        
        let equalPosition = getEqual(scene: scene) //pego a posição do igual
        scene.currentSeedBags.insert(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: ")", imageNamed: "parenteses dir", color: .clear, width: 31.3, height: 44.44), at: equalPosition)
        addHitBoxAtTheEnd(scene: scene)
    }
    
    func addParentheses(open: Int, close: Int, _ scene: PhaseScene){
        scene.currentSeedBags.insert(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "(", imageNamed: "parenteses esq", color: .clear, width: 31.3, height: 44.44), at: open)
        addHitBoxAtTheEnd(scene: scene)
        scene.currentSeedBags.insert(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: ")", imageNamed: "parenteses dir", color: .clear, width: 31.3, height: 44.44), at: close)
        addHitBoxAtTheEnd(scene: scene)
        
    }
    
    func removeParentheses(_ scene: PhaseScene){ //Remove os parenteses
        
        clearSeedsOfScene(scene)
        scene.currentSeedBags.remove(at: getParenthesesLocation(scene).0) //removo o parenteses que abre
        removeHitBoxAtTheEnd(scene: scene)
        scene.currentSeedBags.remove(at: getParenthesesLocation(scene).1) //removo o parenteses que fecha
        removeHitBoxAtTheEnd(scene: scene)
        
    }
    
    
    
    func tutorialRenderClientResponse(_ scene: TutorialPhase, node: SKSpriteNode) {
        
        let correctAnswer = 2
        let yourAnswer = scene.tutorialClient.eq
        print("Resposta: ", yourAnswer)
        
        var resultSprite = ""
        
        if Float(refactorClientAnswer(answer: yourAnswer, scene, isTutorial: true)) == Float(correctAnswer) {
            resultSprite = TutorialClientModel.shared.sprite.replacingOccurrences(of: "Neutro", with: "Feliz")
            scene.currentEqLabel.text! = scene.tutorialClient.rightAnswerFala
        }
        else {
            resultSprite = TutorialClientModel.shared.sprite.replacingOccurrences(of: "Neutro", with: "Bravo")
            scene.currentEqLabel.text! = scene.tutorialClient.wrongAnswerFala
        }
        node.texture = SKTexture(imageNamed: resultSprite)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
        }
    }
    
    
    func tutorialRenderGalacticClientResponse(_ scene: TutorialPhase, node: SKSpriteNode) {
        
        var resultSprite = ""
        if self.finalSeedTransformed {
            resultSprite = TutorialClientModel.shared.sprite.replacingOccurrences(of: "Neutro", with: "Feliz")
            resultSprite = TutorialClientModel.shared.sprite.replacingOccurrences(of: "Bravo", with: "Feliz")
            scene.currentEqLabel.text! = scene.tutorialClient.rightSideralFala
        }
        else {
            resultSprite = TutorialClientModel.shared.sprite.replacingOccurrences(of: "Neutro", with: "Bravo")
            resultSprite = TutorialClientModel.shared.sprite.replacingOccurrences(of: "Feliz", with: "Bravo")
            scene.currentEqLabel.text! = scene.tutorialClient.wrongSideralFala
        }
        node.texture = SKTexture(imageNamed: resultSprite)
    }
    
    func renderClientResponse(_ scene: PhaseScene) {
        
        
        let client = scene.clients[scene.currentClientNumber]
        let clientSprite = client.clientSprites[client.clientSpriteID] // String
        let rose = client.clientSpriteID == 11
        
        let clientAnswer = scene.currentEqLabel.text!
        let correctAnswer = String(scene.phaseMap[scene.phase]![scene.currentClientNumber].1)
        
        let refactoredClientAnswer = refactorClientAnswer(answer: clientAnswer, scene)
        
        
        
        // ACERTOU a conta
        if Float(refactoredClientAnswer) == Float(correctAnswer) {
            var resultSprite: String = ""
            
            // Deu as sementes galáticas pra Rose
            if rose && finalSeedTransformed {
                resultSprite = clientSprite!.replacingOccurrences(of: "Neutro", with: "Feliz (erro)")
                userEngine?.gaveGalacticSeedsToRose()
                gaveGalacticSeedsToRose = true
            }
            // Acertou a conta e não deu as sementes galáticas pra Rose
            else if rose && !finalSeedTransformed {
                resultSprite = clientSprite!.replacingOccurrences(of: "Neutro", with: "Bravo (acerto)")
                userEngine?.rightAnswerRoseNoGalactic()
            }
            // Acertou a conta e deu o tipo de sementes certo
            else if !rose && finalSeedTransformed == client.wantsGalacticSeeds {
                resultSprite = clientSprite!.replacingOccurrences(of: "Neutro", with: "Feliz")
                userEngine?.rightAnswerRightGalactic()
            }
            // Acertou a conta mas deu o tipo de sementes errado
            else if !rose && finalSeedTransformed != client.wantsGalacticSeeds {
                resultSprite = clientSprite!.replacingOccurrences(of: "Neutro", with: "Bravo")
                userEngine?.rightAnswerWrongGalactic()
            }
            
            client.texture = SKTexture(imageNamed: resultSprite)
            
            nextQuestionWithDelay(scene) //Se o cliente acertou, vai para a proxima perguntar normal
        }
        // errou a conta
        else {
            var resultSprite: String = ""
            
            // Deu as sementes galáticas pra Rose
            if rose && finalSeedTransformed {
                resultSprite = clientSprite!.replacingOccurrences(of: "Neutro", with: "Feliz (erro)")
                userEngine?.gaveGalacticSeedsToRose()
            }
            // Errou a conta mas não deu as sementes galáticas pra Rose
            else if rose && !finalSeedTransformed {
                resultSprite = clientSprite!.replacingOccurrences(of: "Neutro", with: "Bravo (acerto)")
                userEngine?.wrongAnswerRoseNoGalactic()
            }
            // Errou a conta mas acertou o tipo das sementes
            else if !rose && finalSeedTransformed == client.wantsGalacticSeeds {
                resultSprite = clientSprite!.replacingOccurrences(of: "Neutro", with: "Bravo")
                userEngine?.wrongAnswerRightGalactic()
            }
            // Errou a conta e errou o tipo das sementes
            else if !rose && finalSeedTransformed != client.wantsGalacticSeeds {
                resultSprite = clientSprite!.replacingOccurrences(of: "Neutro", with: "Bravo")
                userEngine?.wrongAnswerWrongGalactic()
            }
            
            if rose{ //Mas se ele errou, tem toda a logica de mostrar a resposta certa e o usuario ter que clicar
                showRightAnswer(scene, glow: true, correctAnswer: Float(correctAnswer)!)
            }
            if client.wantsGalacticSeeds{
                showRightAnswer(scene, glow: true, correctAnswer: Float(correctAnswer)!)
            }else{
                showRightAnswer(scene, glow: false, correctAnswer: Float(correctAnswer)!)
            }
            
            client.texture = SKTexture(imageNamed: resultSprite)
            
            if self.userEngine?.life == 0{ //Agora quando ele erra e perde todas as vidas, o jogo da game over
                self.gameOver = true
            }
        }
        
        finalSeedTransformed = false
    }
    
    
    func getParenthesesLocation(_ scene: PhaseScene) -> (Int,Int,Bool){
        var open = 0
        var close = 0
        var hasParentheses = false
        
        if fromLeft(scene){ //Se vier da esquerda o saco que estou mexendo, preciso achar parenteses apenas na esquerda
            let equalPosition = getEqual(scene: scene)
            for index in 0..<equalPosition{
                if scene.currentSeedBags[index].label.text == "("{
                    open = index
                    hasParentheses = true
                }else if scene.currentSeedBags[index].label.text == ")"{
                    close = index
                }
            }
        }
        else{ //Se vier da direita, preciso achar sacos apenas na direita
            let equalPosition = getEqual(scene: scene)
            for index in equalPosition..<scene.currentSeedBags.count{
                if scene.currentSeedBags[index].label.text == "("{
                    open = index
                    hasParentheses = true
                }else if scene.currentSeedBags[index].label.text == ")"{
                    close = index
                }
            }
        }
        return (open,close,hasParentheses)
    }
    
    func getMovableNodePosition(_ scene: PhaseScene) -> Int{ //Retorna a posição de onde está o nó que esta sendo mexido
        for (index,seedBag) in scene.currentSeedBags.enumerated(){
            if seedBag == scene.movableNode!{
                return index
            }
        }
        return -1
    }
    
    func getNodePosition(_ text: String, _ scene: PhaseScene) -> Int{
        for (index,seedBag) in scene.currentSeedBags.enumerated(){
            if seedBag.label.text == text{
                return index
            }
        }
        return -1
    }
    
    func inParentheses(_ index: Int, _ scene: PhaseScene) -> Bool{ //Checa se o index recebido como parâmetro está entre parênteses
        let leftParentheses = getParenthesesLocation(scene).0
        let rightParentheses = getParenthesesLocation(scene).1
        let hasParentheses = getParenthesesLocation(scene).2
        
        if hasParentheses {
            if index > leftParentheses{
                if index < rightParentheses{
                    return true
                }
            }
        }
        return false
    }
    
    func resultIsReady(_ scene: PhaseScene) -> Bool{ //Retorna se o resultado esta pronto
        if scene.currentSeedBags.count == 3{
            if scene.currentSeedBags[0].label.text! == "?" && scene.currentSeedBags[2].label.text!.isNumber{
                return true
            }else if scene.currentSeedBags[2].label.text! == "?" && scene.currentSeedBags[0].label.text!.isNumber{
                return true
            }
        }else if scene.currentSeedBags.count == 4{ //Trata resultados negativos
            if scene.currentSeedBags[0].label.text! == "?" && scene.currentSeedBags[2].label.text! == "-" && scene.currentSeedBags[3].label.text!.isNumber {
                return true
            }else if scene.currentSeedBags[3].label.text! == "?" && scene.currentSeedBags[0].label.text == "-" && scene.currentSeedBags[1].label.text!.isNumber {
                return true
            }
        }
        return false
    }
    
    func createFinalSeedBag(_ scene: PhaseScene, isTutorial: Bool = false){
        
        for (index,seedBag) in scene.currentSeedBags.enumerated(){ //Varro o vetor de sementes
            if seedBag.label.text!.isNumber{ //Se for um numero o saco atual
                if scene.currentSeedBags.count == 4{
                    
                    if isTutorial {
                        TutorialClientModel.shared.eq = scene.currentSeedBags[index-1].label.text! + seedBag.label.text!
                        seedBag.label.text = TutorialClientModel.shared.eq
                    } else {
                        scene.currentEqLabel.text = scene.currentSeedBags[index-1].label.text! + seedBag.label.text!
                        seedBag.label.text = scene.currentEqLabel.text
                    }
                    clearSeedsOfScene(scene)
                    clearSeedOfList(scene)
                    scene.currentSeedBags.append(seedBag)
                    finalSeedCreated = true
                    showEquation(scene: scene, isTutorial: isTutorial)
                    
                }else{
                    scene.currentEqLabel = seedBag.label //A equação atual se torna apenas esse número
                    addSeedBags(scene: scene, isTutorial: isTutorial) //E o vetor vira esse número
                    finalSeedCreated = true
                }
            }
        }
    }
    
    func tutorialCreateFinalSeedBag(scene: TutorialPhase, isTutorial: Bool = true) {
        
        for (index,seedBag) in scene.currentSeedBags.enumerated(){ //Varro o vetor de sementes
            if seedBag.label.text!.isNumber{ //Se for um numero o saco atual
                if scene.currentSeedBags.count == 4{
                    
                    scene.tutorialClient.eq = scene.currentSeedBags[index-1].label.text! + seedBag.label.text!
                    seedBag.label.text = scene.tutorialClient.eq
                    
                    clearSeedsOfScene(scene)
                    clearSeedOfList(scene)
                    scene.currentSeedBags.append(seedBag)
                    finalSeedCreated = true
                    tutorialShowEquation(scene: scene, isTutorial: isTutorial)
                    
                } else {
                    scene.tutorialClient.eq = seedBag.label.text!
                    tutorialAddSeedBags(scene: scene, isTutorial: isTutorial) //E o vetor vira esse número
                    finalSeedCreated = true
                }
            }
        }
    }
    
    
    func refactorClientAnswer(answer: String, _ scene: PhaseScene, isTutorial: Bool = false) -> String {
        
        if OperationAction.joinAllNumbers(answer).count > 1 && !answer.contains("-") {
            
            var i = 0
            let equation = isTutorial ? Array(TutorialClientModel.shared.eq) : Array(scene.currentEqLabel.text!)
            
            var leftString = ""
            var rightString = ""
            
            while equation[i] != "=" {
                leftString += String(equation[i])
                i += 1
            }
            
            i += 1
            
            while i < equation.count {
                rightString += String(equation[i])
                i += 1
            }
            
            if leftString.contains("x") {
                return rightString
            }
            return leftString
        }
        return answer
    }
    
    
    func resetCurrentEquation(_ scene: PhaseScene, isTutorial: Bool = false) {
        if isTutorial {
            TutorialClientModel.shared.eq = TutorialClientModel.shared.initialEq
            addSeedBags(scene: scene, isTutorial: true)
            addHitBoxesFromEquation(scene: scene)
        }
        else {
            if !scene.children.contains(scene.currentEqLabel) {
                scene.currentEqLabel.text = "\(scene.clients[scene.currentClientNumber].eq)" // Volta o label para a equação inicial
                addSeedBags(scene: scene)
                addHitBoxesFromEquation(scene: scene)
            }
        }
        
    }
    
    func tutorialResetCurrentEquation(scene: TutorialPhase, isTutorial: Bool = true) {
        scene.tutorialClient.eq = scene.tutorialClient.initialEq
        tutorialAddSeedBags(scene: scene, isTutorial: true)
        addHitBoxesFromEquation(scene: scene)
    }
    
    func transformSeed(_ touches: Set<UITouch>, _ scene: PhaseScene){
        if let touch = touches.first{
            if scene.movableNode != nil{
                let location = touch.location(in: scene.self)
                if scene.blackHole.contains(location){ //Se o buraco negro contém a semente em cima dele ao soltar
                    //transformar a semente
                    resetPosition(scene: scene)
                    finalSeedTransformed = true
                    scene.currentSeedBags[0].texture = SKTexture(imageNamed: "GalacticSeedBag")
                    scene.animatePurplePoof()
                    hapitc()
                }
            }
        }
    }
    
    func grabResult(_ touches: Set<UITouch>, _ scene: PhaseScene) -> Bool{
        if let touch = touches.first{
            if scene.movableNode != nil{
                let location = touch.location(in: scene.self)
                if scene.deliveryPlace.contains(location){ //Se o usuário arrastar para entregar o resultado
                    scene.movableNode!.position = scene.deliveryPlace.position
                    scene.movableNode!.position.y = scene.deliveryPlace.position.y - 86
                    scene.openedEquation = false
                    return true
                }
            }
        }
        resetPosition(scene: scene)
        return false
    }
    
    
    func setGameIsPausedTRUE() {
        self.gameIsPaused = true
    }
    
    
    func setGameIsPausedFALSE() {
        self.gameIsPaused = false
    }
    
    
    func setConfigurationPopUpIsPresentedIsTRUE() {
        self.configurationPopUpIsPresented = true
    }
    
    func setConfigurationPopUpIsPresentedIsFALSE() {
        self.configurationPopUpIsPresented = false
    }
    
    func setEndOfPhaseTRUE() {
        self.endOfPhase = true
    }
    
    func setEndOGPhaseFALSE() {
        self.endOfPhase = false
    }
    
    func isRose(_ scene: PhaseScene) -> Bool{
        if scene.clients[scene.currentClientNumber].clientSpriteID == 11{
            return true
        }else{
            return false
        }
    }
    
    
    func removeAllChildren(_ scene: PhaseScene) {
        scene.removeAllChildren()
    }
    
    func showRightAnswer(_ scene: PhaseScene, glow: Bool, correctAnswer: Float){
        removeRightAnswer(scene)
        
        if glow{
            //Background
            scene.rightAnswerEqBackground.texture = SKTexture(imageNamed: "rightAnswerEqBackgroundGlow")
            scene.rightAnswerEqBackground.position = CGPoint(x: 420, y: 180)
            scene.rightAnswerEqBackground.zPosition = 12
            scene.addChild(scene.rightAnswerEqBackground)
            
            //Label
            addRightAnswerLabel(scene, correctAnswer: correctAnswer)
            
        }else{
            //Background
            scene.rightAnswerEqBackground.position = CGPoint(x: 420, y: 180)
            scene.rightAnswerEqBackground.zPosition = 12
            scene.addChild(scene.rightAnswerEqBackground)
            //Label
            addRightAnswerLabel(scene, correctAnswer: correctAnswer)
            
        }
        
        scene.rightAnswerShowed = true
    }
    
    func addRightAnswerLabel(_ scene: PhaseScene, correctAnswer: Float){
        //Label
        scene.rightAnswerEqLabel.append(SeedBagModel(numero: 0, incognita: true, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight))
        scene.rightAnswerEqLabel.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "", imageNamed: "igual", color: .clear, width: 22.45, height: 30.73))
        scene.rightAnswerEqLabel.append(SeedBagModel(numero: Int(correctAnswer), incognita: false, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight))
        
        scene.removeChildren(in: [scene.currentSeedBags[0]]) //remover o saco entregue para o cliente
        
        for index in 0..<3{
            scene.rightAnswerEqLabel[index].position = CGPoint(x: 360+CGFloat((bagSpacing*index)), y: 150) //Posicao da sacola com o numero, mexo com o index para colocar na posição certa da equação
            
            scene.rightAnswerEqLabel[index].zPosition = 14
            
            scene.addChild(scene.rightAnswerEqLabel[index])
        }
    }
    
    func removeRightAnswer(_ scene: PhaseScene){
        scene.rightAnswerShowed = false
        for rightAnswerEqLabel in scene.rightAnswerEqLabel {
            scene.removeChildren(in: [rightAnswerEqLabel])
        }
        scene.removeChildren(in: [scene.rightAnswerEqBackground])
    }
    
    func hapitc(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
