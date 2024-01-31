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
    
    let operators = ["+","-","*","/"]
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    let seedBagWidth: Double = 50
    let seedBagHeight: Double  = 70
    
    let hitBoxWidth: Double = 50
    let hitBoxHeight: Double = 50
    
    var initialPosition = 0
    var realocationPosition = 0
    
    var eqHasZeroRight = false
    var eqHasZeroLeft = false
    
    var initialNodePosition = CGPoint(x: 0, y: 0)
    
    var actions: [Action] = []
    var phases: [PhaseScene] = []
    var currentPhase = 0
    
    let darknessMap: [Int : SKAction] = [0: SKAction.colorize(with: .black, colorBlendFactor: 0, duration: 0),
                                         1: SKAction.colorize(with: .black, colorBlendFactor: 0.2, duration: 0),
                                         2: SKAction.colorize(with: .black, colorBlendFactor: 0.4, duration: 0)]
    
    let undarknessMap: [Int : SKAction] = [0: SKAction.colorize(with: .black, colorBlendFactor: 0, duration: 1),
                                           1: SKAction.colorize(with: .black, colorBlendFactor: 0.2, duration: 1),
                                           2: SKAction.colorize(with: .black, colorBlendFactor: 0.4, duration: 1)]
    
    
    init() {
        let phases = [PhaseScene(phase: 1, width: width, height: height), PhaseScene(phase: 2, width: width, height: height)]
        self.phases = phases
    }
    
    
    func receiveAction(_ action: Action) {
		  actions.append(action)
		  let res = action.execute()
		  if res.contains("=") {
			  phases[currentPhase].currentEqLabel.text = res
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
		
		for (index, client) in scene.clients.enumerated() {
			
			let scaleAction = SKAction.scale(by: 1.2, duration: 0.5)
			client.run(scaleAction)
			
			let moveAction = SKAction.moveTo(x: client.position.x - 75, duration: 0.5)
			client.run(moveAction)
			
			for c in scene.currentClientNumber..<scene.clients.count {
				scene.clients[c].run(darknessMap[c - scene.currentClientNumber - 1] ?? SKAction.colorize(with: .black, colorBlendFactor: 0.6, duration: 0.5))
			}
			
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
		addHitBoxesFromEquation(scene: scene)
		addSeedBags(scene: scene)
	}
    
    
    
    func renderClients(scene: PhaseScene) {
		
		for (index, client) in scene.clients.enumerated() {
			if index < 3 {
				client.position = CGPoint(x: 564+(75*index), y: 235)
			} else {
				client.position = CGPoint(x: 775, y: 235)
			}
			client.run(SKAction.scale(by: 0.9 - (0.1*CGFloat(index)), duration: 0))
			client.zPosition = CGFloat(scene.clients.count - index)
			
			client.run(darknessMap[index] ?? SKAction.colorize(with: .black, colorBlendFactor: 0.6, duration: 0))
			
			
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
                    self.initialNodePosition = node.position
                    scene.movableNode = node
                    scene.movableNode!.position = location
                    self.initialPosition = initialPosition
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
                    
                    if grabNode(touches: touches, scene: scene){ //Se o nó foi soltado em alguma hitBox que consiga segurar ele
                        
                        //Eu preciso checar se ele deixar o saco em algum lado que tem um zero, o zero tem que sumir
                        removeZeroIfItNeedsTo(scene: scene)
                        
                        let fromLeft = checkFromLeft(scene: scene)
                        
                        if fromLeft{ //Se o usuário estiver arrastando da esquerda para a direita
                            realocateFromLeft(scene: scene) //Função que realoca os sinais também a partir da esquerda
                        }else{ //Se o usuário estiver arrastando da direita para a esquerda
                            realocateFromRight(scene: scene) //Função que realoca os sinais também a partir da direita
                        }
                        //Depois de realocar preciso checar se não tem algum lado sem nada
                        addZeroIfItNeedsTo(scene: scene)
                        
                        //Depois de realocar preciso atualizar as equações na tela
                        showEquation(scene: scene)
                        
                        scene.movableNode = nil
                        
//                        print("\ndepois de realocar tudo de remover o zero \n")
//                        for seedBags in scene.currentSeedBags{
//                                      print(seedBags.label.text!, terminator: "")
//                        }
                        
                    }else{ //Se nao ele só volta para sua posição inicial
                        resetPosition(scene: scene)
                    }
                }
            }
        }
    }
    
    func invertOperator(_ node: SeedBagModel, _ touches: Set<UITouch>, _ position: Int, _ scene: PhaseScene){
        
        if let touch = touches.first{
            let location = touch.location(in: scene.self)
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
                showEquation(scene: scene)
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
        for _ in scene.clients[scene.currentClientNumber].eq{
            let node = SKShapeNode(rectOf: CGSize(width: hitBoxWidth, height: hitBoxHeight))
            scene.hitBoxes.append(node)
        }
        //Adicionar na cena as hitBoxes
        for (index,hitBox) in scene.hitBoxes.enumerated(){
            hitBox.position = CGPoint(x: 50+(60*index), y: 100)
            hitBox.zPosition = 11
            hitBox.strokeColor = .red
            scene.addChild(hitBox)
        }
    }
    
    //Adiciona uma hitBox a mais no final da equação
    func addHitBoxAtTheEnd(scene: PhaseScene){
        let node = SKShapeNode(rectOf: CGSize(width: hitBoxWidth, height: hitBoxHeight)) //Crio mais uma hitbox
        node.position = CGPoint(x: 50+(60*scene.hitBoxes.count), y: 100) //Defino a posição dele com base na posição da ultima hitBox
        node.zPosition = 11
        node.strokeColor = .red //Defino a cor dele de vermelho
        scene.hitBoxes.append(node) //Adiciono ela no vetor de hitBoxes
        scene.addChild(node) //Adiciono ela na cena
        
    }
    
    func removeHitBoxAtTheEnd(scene: PhaseScene){
        scene.removeChildren(in: [scene.hitBoxes[scene.hitBoxes.count-1]]) //Removo da cena a hitBox do final
        scene.hitBoxes.removeLast() //Removo do vetor a hitbox do final
    }
    
    func removeFirstHitBox(scene: PhaseScene){
        scene.removeChildren(in: [scene.hitBoxes[0]]) //Removo da cena a hitbox do começo
        scene.hitBoxes.removeFirst() //removo do vetor
    }
    
    func addSeedBags(scene: PhaseScene){
        
        if scene.currentSeedBags.count != 0{
            for seedBag in scene.currentSeedBags{
                scene.removeChildren(in: [seedBag])
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
                        addHitBoxAtTheEnd(scene: scene)
                    }
                }
                scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: true, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight))
                
            }else{
                scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: String(char), imageNamed: "nothing", color: .clear, width: seedBagWidth, height: seedBagHeight))
            }
        }
        //Depois de preparar o vetor, adiciono na cena
        showEquation(scene: scene)
    }
    
    func updateCurrentEqLabel(scene: PhaseScene){
        var equation = ""
        for seedBag in scene.currentSeedBags{
            if seedBag.label.text == "?"{
                equation += "x"
            }else{
                equation += seedBag.label.text!
            }
        }
        print("\nNOVA EQUAÇÃO: \(equation)")
        scene.currentEqLabel.text = equation
    }
    
    func showEquation(scene: PhaseScene){
        updateCurrentEqLabel(scene: scene)
        
        if scene.currentSeedBags.count != 0{
            for seedBag in scene.currentSeedBags{
                scene.removeChildren(in: [seedBag])
            }
        }
        
//        print("\nadicionando na cena: ")
//        for seedBags in scene.currentSeedBags{
//            print(seedBags.label.text!, terminator: "")
//        }
        
        for (index,seedBag) in scene.currentSeedBags.enumerated(){
            seedBag.position = CGPoint(x: 50+(60*index), y: 100) //Posicao da sacola com o numero, mexo com o index para colocar na posição certa da equação
            seedBag.zPosition = 11
            
            scene.addChild(seedBag)
        }
    }
    
    
    func grabNode(touches: Set<UITouch>, scene: PhaseScene) -> Bool{
        if let touch = touches.first{
            if scene.movableNode != nil{
                let location = touch.location(in: scene.self)
                for (index,hitBox) in scene.hitBoxes.enumerated(){
                    if hitBox.contains(location){
                        realocationPosition = index
                        scene.movableNode!.position = hitBox.position
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func realocateSeedBag(_ initialPosition: Int, _ scene: PhaseScene){ //Nessa função, o destino de realocação do nó é sempre no ultimo elemento do lado para onde esta sendo realocada.
        
        var fromLeft = false
        var possible = true
        
        for i in initialPosition..<scene.currentSeedBags.count{ //Percorro o vetor da posicao que o nó esta sendo mexido até o final do vetor, se achar algum igual no caminho, ele esta trazendo da esquerda
            if scene.currentSeedBags[i].label.text == "="{
                fromLeft = true
                for j in realocationPosition..<scene.currentSeedBags.count{
                    if scene.currentSeedBags[j].label.text == "="{//Porém, se eu encontrar um igual novamente, partindo da posição de realocação, significa que o usuário esta tentando mexer no mesmo lado, o que nao é possivel
                        possible = false
                    }
                }
            }
        }
        
        if !fromLeft{ //Se ele nao achou nenhum "igual" a direita do saco que esta mexendo, signifca que o elemento que ele esta mexendo esta a direita do igual, entao preciso checar se onde ele quer soltar esta do lado esquerdo do igual, se nao estiver, nao posso deixar ele mexer
            possible = false
            for i in realocationPosition..<scene.currentSeedBags.count{
                if scene.currentSeedBags[i].label.text == "="{
                    possible = true
                }
            }
        }
        
        if possible{
            if fromLeft{//se eu estiver arrastado o elemento da esquerda para a direita
                let currentSeedBag = scene.currentSeedBags[initialPosition] //salvo o valor no qual estou pegando
                
                for i in (initialPosition+1..<scene.currentSeedBags.count){ //for a partir do elemento que estou alocando ate o final do vetor.
                    scene.currentSeedBags[i-1] = scene.currentSeedBags[i] //aloco todos os outros um quadrado antes
                }
                scene.currentSeedBags[scene.currentSeedBags.count-1] = currentSeedBag //coloco na posição finao do vetor
            }
            else{//se eu estiver arrastando o elemento da direita para a esquerda
                let equalPosition = findEqual(scene: scene) //Procuro onde esta o sinal de igual para colocar o elemento atual nessa posição
                
                let currentSeedBag = scene.currentSeedBags[initialPosition] //salvo o valor que estou pegando
                
                for i in stride(from: initialPosition-1, through: equalPosition-1, by: -1){ //Percorro o vetor desde a posição inicial -1 e vou ate a posição do igual, da esquerda para a direita
                    if i >= 0{
                        scene.currentSeedBags[i+1] = scene.currentSeedBags[i] //movo um lugar de todos esses elementos
                    }
                }
                scene.currentSeedBags[equalPosition] = currentSeedBag //coloco na posição anterior do igual o elemento que estava segurando
            }
            
        }else{ //Se nao for possivel realizar a troca, eu reseto a posição do nó
            resetPosition(scene: scene)
        }
    }
    
    func realocateFromLeft(scene: PhaseScene){ //Realoca com sinal os elementos
        
        if tradeIsPossible(scene: scene){
            if self.initialPosition != 0{
                //Se, quando eu for realocar um elemento, antes dele ouver algum sinal, esse sinal tem que ir junto
                if operators.contains(scene.currentSeedBags[self.initialPosition-1].label.text!){
                    realocateSeedBag(self.initialPosition-1,scene)
                    realocateSeedBag(self.initialPosition-1, scene)
                }
            }else{ //Se não houver um sinal antes, eu preciso criar um sinal de mais, criar uma hitbox, e realocar
                addHitBoxAtTheEnd(scene: scene) //adiciono uma hitbox ao final
                scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "+", imageNamed: "nothing", color: .clear, width: seedBagWidth, height: seedBagHeight)) //adiciono ao final do vetor um sinal de mais
                realocateSeedBag(self.initialPosition, scene) //realoco apenas o elemento que o usuario passou
            }
        }
    }
    
    func realocateFromRight(scene: PhaseScene){ //realoca com sinal os elementos
        //Se quando eu for realocar um elemento, antes dele ouver algum sinal, esse sinal tem que ir junto
        
        if tradeIsPossible(scene: scene){
            if operators.contains(scene.currentSeedBags[self.initialPosition-1].label.text!){
                realocateSeedBag(self.initialPosition-1,scene)
                realocateSeedBag(self.initialPosition, scene)
            }
            else{ //Se não houver um sinal antes, eu preciso criar um sinal de mais, criar uma hitbox, e realocar
                addHitBoxAtTheEnd(scene: scene) //adiciono uma hitbox ao final
                scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "+", imageNamed: "nothing", color: .clear, width: seedBagWidth, height: seedBagHeight)) //adiciono ao final do vetor um sinal de mais
                //            self.initialPosition += 1
                realocateSeedBag(scene.currentSeedBags.count-1,scene) //realoco o sinal que eu acabei de inserir na ultima posição
                realocateSeedBag(self.initialPosition+1, scene) //realoco o elemento que o usuario passou
            }
        }
        
    }
    
    func resetPosition(scene: PhaseScene){
        scene.movableNode?.position = initialNodePosition
    }
    
    func findEqual(scene: PhaseScene) -> Int{
        for i in 0..<scene.currentSeedBags.count{
            if scene.currentSeedBags[i].label.text == "="{
                return i
            }
        }
        return 0
    }
    
    func checkFromLeft(scene: PhaseScene) -> Bool{
        for i in initialPosition..<scene.currentSeedBags.count{ //Percorro o vetor da posicao que o nó esta sendo mexido até o final do vetor, se achar algum igual no caminho, ele esta trazendo da esquerda
            if scene.currentSeedBags[i].label.text == "="{
                return true
            }
        }
        return false
    }
    
    func addZeroIfItNeedsTo(scene: PhaseScene){
        let equalPosition = findEqual(scene: scene)
        
        if equalPosition == 0{ //Se o igual esta na primeira posição
            let zero = SeedBagModel(numero: 0, incognita: false, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight) //Crio o zero que vai ser adicionado
            scene.currentSeedBags.append(zero) //Dou um append na lista com esse zero
            addHitBoxAtTheEnd(scene: scene) //Coloco mais uma hitBox
            
            for i in stride(from: scene.currentSeedBags.count-2, through: 0, by: -1){ // Percorro o vetor inteiro, levando todos os elementos a uma posição a frente
                scene.currentSeedBags[i+1] = scene.currentSeedBags[i] //movo um lugar de todos esses elementos
            }
            scene.currentSeedBags[0] = zero //coloco na posição zero o zero
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
                scene.removeChildren(in: [scene.currentSeedBags[scene.currentSeedBags.count-1]]) //Removo da cena
                scene.currentSeedBags.removeLast() //Eu removo do vetor
                removeHitBoxAtTheEnd(scene: scene) //Removo a ultima hitBox
                eqHasZeroRight = false
            }
        }
        else if eqHasZeroLeft{
            if scene.currentSeedBags[0].label.text == "0"{ //Se o primeiro elemento no vetor das sementes vale 0
                
//                print("antes de remover o zero \n")
//                for seedBags in scene.currentSeedBags{
//                              print(seedBags.label.text!, terminator: "")
//                }
                
                //Movo todos os objetos uma posição para trás
                for i in 0..<scene.currentSeedBags.count-1{
                    scene.currentSeedBags[i] = scene.currentSeedBags[i+1]
                }
                //Removo a ultima hitbox
                removeHitBoxAtTheEnd(scene: scene)
                //Aqui removo a semente da ultima posição
                
                scene.removeChildren(in: [scene.currentSeedBags[scene.currentSeedBags.count-1]]) //MAS EU TIRO DA CENA, PQ NAO FUNCIONA???? aaah eu tiro da cena o ultimo elemento, nao o zero
                
                scene.currentSeedBags.removeLast() //COMO EU ESTOU REMOVENDO DA LISTA, NA HORA DE LIMPAR A LISTA ELE CHECA MENOS 1 ELEMENTO
                
//                print("\ndepois de remover o zero \n")
//                for seedBags in scene.currentSeedBags{
//                              print(seedBags.label.text!, terminator: "")
//                }
                
                eqHasZeroLeft = false
            }
        }
    }
    
    func tradeIsPossible(scene: PhaseScene) -> Bool{
        var fromLeft = false
        var possible = true
        
        for i in initialPosition..<scene.currentSeedBags.count{ //Percorro o vetor da posicao que o nó esta sendo mexido até o final do vetor, se achar algum igual no caminho, ele esta trazendo da esquerda
            if scene.currentSeedBags[i].label.text == "="{
                fromLeft = true
                for j in realocationPosition..<scene.currentSeedBags.count{
                    if scene.currentSeedBags[j].label.text == "="{//Porém, se eu encontrar um igual novamente, partindo da posição de realocação, significa que o usuário esta tentando mexer no mesmo lado, o que nao é possivel
                        possible = false
                    }
                }
            }
        }
        
        if !fromLeft{ //Se ele nao achou nenhum "igual" a direita do saco que esta mexendo, signifca que o elemento que ele esta mexendo esta a direita do igual, entao preciso checar se onde ele quer soltar esta do lado esquerdo do igual, se nao estiver, nao posso deixar ele mexer
            possible = false
            for i in realocationPosition..<scene.currentSeedBags.count{
                if scene.currentSeedBags[i].label.text == "="{
                    possible = true
                }
            }
        }
        
        return possible
    }
    
    func renderClientResponse(_ scene: PhaseScene) {
        
        let client = scene.clients[scene.currentClientNumber]
        let clientSprite = client.clientSprites[client.clientSpriteID] // String
        let rose = client.clientSpriteID == 11
        
        // ACERTOU!
        if scene.currentEqLabel.text! == String(scene.phaseMap[currentPhase+1]![scene.currentClientNumber].1) {
            print("EEEEITA PENGA \(String(scene.phaseMap[currentPhase+1]![scene.currentClientNumber].1))")
            
            var resultSprite: String = ""
            if rose {
                resultSprite = clientSprite!.replacingOccurrences(of: "Neutro", with: "Bravo (acerto)")
            }
            else {
                resultSprite = clientSprite!.replacingOccurrences(of: "Neutro", with: "Feliz")
            }
            
            client.texture = SKTexture(imageNamed: resultSprite)
        }
        // errou...
        else {
            print("vishh \(String(scene.phaseMap[currentPhase+1]![scene.currentClientNumber].1))")
            
            
            var resultSprite: String = ""
            if rose {
                resultSprite = clientSprite!.replacingOccurrences(of: "Neutro", with: "Feliz (erro)")
            }
            else {
                resultSprite = clientSprite!.replacingOccurrences(of: "Neutro", with: "Bravo")
            }
            
            client.texture = SKTexture(imageNamed: resultSprite)
        }
    }
}

//Sempre que eu arrastar algo para outra hitbox, eu tenho que atualizar o meu vetor de sementes, mas isso soh pode ser feito depois que dua sementes nao puderem ficar na mesma hitbox, ou seja, tem que ter o sistema de realocação feito ja



//so da para arrastar pra outro lado do igual
