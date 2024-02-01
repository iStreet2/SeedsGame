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
    
    let operators = ["+","-","*","/","(",")"]
    
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
    
    var emptySeedBag = SeedBagModel(numero: 0, incognita: false, isOperator: false, operatorr: "", imageNamed: "nothing", color: .clear, width: 50, height: 70)
    
    var actions: [Action] = []
    var phases: [PhaseScene] = []
    var currentPhase = 0
    
//    @State var life = 3
//    @State var points = 0
    
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
              addSeedBags(scene: phases[currentPhase])
              addHitBoxesFromEquation(scene: phases[currentPhase])
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
		
		for (_, client) in scene.clients.enumerated() {
			
			// Aumenta
			let scaleAction = SKAction.scale(by: 1.2, duration: 0.5)
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
		 addSeedBags(scene: scene)
		 addHitBoxesFromEquation(scene: scene)
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
        }else if stage == 2{ //TOUCHES ENDED!!!!!
            if let touch = touches.first {
                if scene.movableNode != nil{
                    scene.movableNode!.position = touch.location(in: scene.self)
                    
                    //Antes de deixar o movableNode em nil, eu chamo o grabNode, para que se o nó que o usuário estiver movendo, se prenda ao quadrado, se esse nó estive em cima do quadrado
                    
                    if grabNode(touches: touches, scene: scene){ //Se o nó foi soltado em alguma hitBox que consiga segurar ele
                        
                        if tradeIsPossible(scene: scene){ //E se a troca for possível, ou seja, ele jogar para o outro lado da equação
                            
                            //Eu preciso checar se ele deixar o saco em algum lado que tem um zero, o zero tem que sumir
                            
                            //                        removeZeroIfItNeedsTo(scene: scene)
                            
                            let fromLeft = checkFromLeft(scene: scene) //Checa se o elemento esta sendo arrastado da esquerda
                            
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
                        }
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
        for _ in scene.currentSeedBags{
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
        let equation = OperationAction.joinAllNumbers(scene.currentEqLabel.text!)
        
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
    
	func updateCurrentEqLabel(scene: PhaseScene) {
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
                
                realocateToLeft(scene: scene, from: initialPosition+1, to: scene.currentSeedBags.count-1) //realoco todos os elementos para a esquerda da posicao inicial ate o final do vetor
                
                scene.currentSeedBags[scene.currentSeedBags.count-1] = currentSeedBag //coloco na posição finao do vetor
            }
            else{//se eu estiver arrastando o elemento da direita para a esquerda
                let equalPosition = getEqual(scene: scene) //Procuro onde esta o sinal de igual para colocar o elemento atual nessa posição
                
                let currentSeedBag = scene.currentSeedBags[initialPosition] //salvo o valor que estou pegando
            
                realocateToRight(scene: scene, from: equalPosition-1, to: initialPosition) //realoco para a direita todos os elementos a partir do igual ate a posição inicial do saco
                
                scene.currentSeedBags[equalPosition] = currentSeedBag //coloco na posição anterior do igual o elemento que estava segurando
            }
            
        }else{ //Se nao for possivel realizar a troca, eu reseto a posição do nó
            resetPosition(scene: scene)
        }
    }
    
    //Se, ao mandar ou uma multiplicação, ou uma divisão, tiver mais de 1 número do outro lado, eu preciso colocar parênteses no começo e no final desse lado da equação
    
    func realocateFromLeft(scene: PhaseScene){ //Realoca com sinal os elementos
        
        if self.initialPosition != 0{
            //Se, quando eu for realocar um elemento, antes dele ouver algum sinal, esse sinal tem que ir junto
            if operators.contains(scene.currentSeedBags[self.initialPosition-1].label.text!){
                if scene.currentSeedBags[self.initialPosition-1].label.text! == "*"{ //Se esse sinal for multiplicação
                    
                    if scene.currentSeedBags[self.initialPosition-2].label.text! == ")"{ //se antes do sinal de multiplicação for um parenteses fechando
                        
                        //Remover parenteses da esquerda!
                        
                    }
                    
                    if getNumRightEqual(scene) > 1{ //Se a quantidade de numeros do lado direito da equação for maior que 1
                        //Adiciono os parênteses!
                        addParenthesesRight(scene)
                    }
                }
                
                realocateSeedBag(self.initialPosition-1,scene) //Realoco o sinal, que esta uma posição anterior ao numero
                realocateSeedBag(self.initialPosition-1, scene) //Como eu realoquei o sinal, a posição que esta o numero agora é outra, a que estava o sinal antes, 1 anterior, por isso subtraio 1 dele
            }
        }else if scene.currentSeedBags[self.initialPosition+1].label.text! == "*"{ //Se depois do numero tiver um * e depois do * tiver um "?", entao eu preciso levar junto esse *
            if scene.currentSeedBags[self.initialPosition+2].label.text! == "?"{ //Se depois * tiver um "?"
                
                if getNumRightEqual(scene) > 1{ //Se a quantidade de numeros do lado direito da equação for maior que 1
                    //Adiciono os parênteses!
                    addParenthesesRight(scene)
                }
                
                realocateSeedBag(self.initialPosition+1,scene) //Realoco o sinal que esta na frente da posição inicial
                realocateSeedBag(self.initialPosition,scene) //Realoco o número, que permanece na posição inicial
                
            }
        }
        else{ //Se não houver um sinal antes, eu preciso criar um sinal de mais, criar uma hitbox, e realocar
            addHitBoxAtTheEnd(scene: scene) //adiciono uma hitbox ao final
            scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "+", imageNamed: "nothing", color: .clear, width: seedBagWidth, height: seedBagHeight)) //adiciono ao final do vetor um sinal de mais
            realocateSeedBag(self.initialPosition, scene) //realoco apenas o elemento que o usuario passou
        }
    }
    
    func realocateFromRight(scene: PhaseScene){ //realoca com sinal os elementos
        //Se quando eu for realocar um elemento, antes dele ouver algum sinal, esse sinal tem que ir junto
        
        if operators.contains(scene.currentSeedBags[self.initialPosition-1].label.text!){ //Se na posição anterior do número que eu estou vendo, tiver um sinal
            if scene.currentSeedBags[self.initialPosition-1].label.text! == "*"{ //Se esse sinal for multiplicação
                
                if scene.currentSeedBags[self.initialPosition-2].label.text! == ")"{ //Se antes da multiplicação tiver um parenteses fechando
                    
                    //Removo os parenteses da direita!
                }
                
                
                if getNumLeftEqual(scene) > 1{ //Se a quantidade de numeros do lado direito da equação for maior que 1
                    //Adiciono os parênteses!
                    addParenthesesLeft(scene)
                }
            }
            
            realocateSeedBag(self.initialPosition-1,scene)  //Eu pego o sinal, realoco ele pra esquerda
            realocateSeedBag(self.initialPosition, scene)   //O número permanece na mesma posição, entao realoco ele
            
        }else if scene.currentSeedBags[self.initialPosition+1].label.text! == "*"{ //Se depois do numero tiver um * e depois do * tiver um "?", entao eu preciso levar junto esse *
            if scene.currentSeedBags[self.initialPosition+2].label.text! == "?"{
                
                if getNumRightEqual(scene) > 1{ //Se a quantidade de numeros do lado esquerdo da equação for maior que 1
                    //Adiciono os parênteses!
                    addParenthesesLeft(scene)
                }
                
                realocateSeedBag(self.initialPosition+1,scene) //Realoco o sinal que esta na frente da posição inicial
                realocateSeedBag(self.initialPosition+1,scene) //Ao realocar o sinal, que estava numa posição a frente do numero, o número vai para essa posição que estava o sinal, portando o numero agora esta a uma posição a frente tambem, por isso passo o initialPosition + 1
            }
        }
        else{ //Se não houver um sinal antes, eu preciso criar um sinal de mais, criar uma hitbox, e realocar
            addHitBoxAtTheEnd(scene: scene) //adiciono uma hitbox ao final
            scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "+", imageNamed: "nothing", color: .clear, width: seedBagWidth, height: seedBagHeight)) //adiciono ao final do vetor um sinal de mais
            //            self.initialPosition += 1
            realocateSeedBag(scene.currentSeedBags.count-1,scene) //realoco o sinal que eu acabei de inserir na ultima posição
            realocateSeedBag(self.initialPosition+1, scene) //realoco o elemento que o usuario passou
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
    
    func checkFromLeft(scene: PhaseScene) -> Bool{ //Checo se o elemento que esta sendo arrastado esta vindo da esquerda para a direita
        for i in initialPosition..<scene.currentSeedBags.count{ //Percorro o vetor da posicao que o nó esta sendo mexido até o final do vetor, se achar algum igual no caminho, ele esta trazendo da esquerda
            if scene.currentSeedBags[i].label.text == "="{
                return true
            }
        }
        return false
    }
    
    func addZeroIfItNeedsTo(scene: PhaseScene){
        let equalPosition = getEqual(scene: scene)
        
        if equalPosition == 0{ //Se o igual esta na primeira posição
            let zero = SeedBagModel(numero: 0, incognita: false, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight) //Crio o zero que vai ser adicionado
            scene.currentSeedBags.append(zero) //Dou um append na lista com esse zero
            addHitBoxAtTheEnd(scene: scene) //Coloco mais uma hitBox
            
            realocateToRight(scene: scene, from: 0, to: scene.currentSeedBags.count-1) //Realoco para a direita o vetor inteiro
            
            scene.currentSeedBags[0] = zero //coloco na posição zero o zero
            self.eqHasZeroLeft = true //Agora a equação tem um zero
            
        }else if equalPosition == scene.currentSeedBags.count-1{ //Se o igual esta na ultima posição
            addHitBoxAtTheEnd(scene: scene) //adiciono uma hitbox ao final da equação
            let zero = SeedBagModel(numero: 0, incognita: false, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: seedBagWidth, height: seedBagHeight) //Crio o zero que vai ser adicionado
            scene.currentSeedBags.append(zero) //adiciono o zero ao final, pront :)
            self.eqHasZeroRight = true
            
        }
    }
    
    func removeZeroIfItNeedsTo(scene: PhaseScene){ //Função não funciona direito :D
        
        if eqHasZeroRight{
            if scene.currentSeedBags[scene.currentSeedBags.count-1].label.text == "0"{ //Se a o valor da ultima posição do vetor for 0
                scene.removeChildren(in: [scene.currentSeedBags[scene.currentSeedBags.count-1]]) //Removo da cena
                scene.currentSeedBags.removeLast() //Eu removo do vetor
                removeHitBoxAtTheEnd(scene: scene) //Removo a ultima hitBox
                eqHasZeroRight = false
            }
        }
        else if eqHasZeroLeft{ //E O PROBLMEA ESTA AQUI!
            if scene.currentSeedBags[0].label.text == "0"{ //Se o primeiro elemento no vetor das sementes vale 0

                //Movo todos os objetos uma posição para trás
                for i in 0..<scene.currentSeedBags.count-1{
                    scene.currentSeedBags[i] = scene.currentSeedBags[i+1]
                }
                //Removo a ultima hitbox
                removeHitBoxAtTheEnd(scene: scene)
                //Aqui removo a semente da ultima posição
                scene.removeChildren(in: [scene.currentSeedBags[scene.currentSeedBags.count-1]]) //MAS EU TIRO DA CENA, PQ NAO FUNCIONA???? aaah eu tiro da cena o ultimo elemento, nao o zero
                
                scene.currentSeedBags.removeLast() //COMO EU ESTOU REMOVENDO DA LISTA, NA HORA DE LIMPAR A LISTA ELE CHECA MENOS 1 ELEMENTO
                
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
        //Preciso realocar todos os elementos 1 pra frente, mas antes, alocar um espaço a mais no final do vetor, adicionar uma hitbox ao final, e criar um saco de semente com um parenteses, e colocar na posição 1 pra frente do igual, depois adicionar mais uma hitbox no final e dar append no vetor de um seedBag com parenteses fechados
        
        let equalPosition = getEqual(scene: scene) //Acho a posição do "="
        scene.currentSeedBags.append(emptySeedBag) //Adiciono um elemento vazio para criar um espaço no final do vetor
        realocateToRight(scene: scene, from: equalPosition+1, to: scene.currentSeedBags.count-1) //Realoco todos os elementos 1 posicao para a direita
        addHitBoxAtTheEnd(scene: scene) //adiciono uma hitbox no final para aguentar a adição de 1 elemento
        scene.currentSeedBags[equalPosition+1] = SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "(", imageNamed: "nothing", color: .clear, width: seedBagWidth, height: seedBagHeight) //Adiciono o parenteses logo depois do igual
        
        addHitBoxAtTheEnd(scene: scene) //adiciono outra hitbox para o parenteses do final
        scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: ")", imageNamed: "nothing", color: .clear, width: seedBagWidth, height: seedBagHeight)) //adiciono o parenteses no final :D
        
    }
    
    func addParenthesesLeft(_ scene: PhaseScene){
        //Primeiro vou adicionar um elemento vazio ao final para aumentar a quantidade do vetor em 1, vou realocar todos os elementos um para a direita para adicionar o parenteses no inicio do vetor, depois vou adicionar uma hitBox no final do vetor, depois adiciono novamente um elemento vazio ao final, depois localizo a posição do igual e realoco todos os elementos a partir do igual (incluindo o igual) para a direita, depois localizo o igual novamente e adiciono o parenteses 1 posicao antes do igual
         
        scene.currentSeedBags.append(emptySeedBag) //adiciono uma posicao ao vetor
        realocateToRight(scene: scene, from: 0, to: scene.currentSeedBags.count-1) //Realoco todos os elementos 1 para a direita
        self.initialPosition += 1 //como realoquei todos elementos para a direita, a posicao do meu nó muda
        addHitBoxAtTheEnd(scene: scene) //Adiciono uma hitBox
        scene.currentSeedBags[0] = SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: "(", imageNamed: "nothing", color: .clear, width: seedBagWidth, height: seedBagHeight)
        
        scene.currentSeedBags.append(emptySeedBag) //adiciono uma posicao ao vetor
        var equalPosition = getEqual(scene: scene) //pego a posição do igual
        realocateToRight(scene: scene, from: equalPosition-1, to: scene.currentSeedBags.count-1) //Realoco todos os elementos depois do igual, incluindo o igual, para a direita
        self.initialPosition += 1 //como realoquei todos elementos para a direita, a posicao do meu nó muda
        equalPosition = getEqual(scene: scene) //Pego a posição do igual novamente
        scene.currentSeedBags[equalPosition-1] = SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: ")", imageNamed: "nothing", color: .clear, width: seedBagWidth, height: seedBagHeight) //Adiciono 1 posição antes do igual um parênteses
        addHitBoxAtTheEnd(scene: scene)
    }
    
    func removeParenthesesRight(_ scene: PhaseScene){
        //Ok, vamos la, aqui eu preciso remover os parenteses da direita eba, entao primeiro preciso localizar os parenteses, achar a posição de cada um, depois remover daquela posição, depois de remover, retirar a hitbox daquela posição, e ajustar o initialPosition :D, vamo la
        
        scene.currentSeedBags.remove(at: getParenthesesLocation(scene).0) //removo o parenteses que abre
        removeHitBoxAtTheEnd(scene: scene)
        
    }
    
    func renderClientResponse(_ scene: PhaseScene) {
        
        let client = scene.clients[scene.currentClientNumber]
        let clientSprite = client.clientSprites[client.clientSpriteID] // String
        let rose = client.clientSpriteID == 11
        
		 let clientAnswer = scene.currentEqLabel.text!
		 let correctAnswer = String(scene.phaseMap[currentPhase+1]![scene.currentClientNumber].1)
		 
		 let refactoredClientAnswer = refactorClientAnswer(answer: clientAnswer, scene)
		 
		// ACERTOU!
        if Float(refactoredClientAnswer) == Float(correctAnswer) {
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
    
    func realocateToRight(scene: PhaseScene, from: Int, to: Int){ //Realoca todos os elementos 1 pra direita
        for i in stride(from: to-1, through: from, by: -1){
            scene.currentSeedBags[i+1] = scene.currentSeedBags[i]
        }
    }
    
    func realocateToLeft(scene: PhaseScene, from: Int, to: Int){ //Realoca todos os elementos 1 para a esquerda
        for i in from...to{
            scene.currentSeedBags[i-1] = scene.currentSeedBags[i]
        }
    }
    
    func getParenthesesLocation(_ scene: PhaseScene) -> (Int,Int){
        var open = 1000
        var close = 1000
        for (index,seedBag) in scene.currentSeedBags.enumerated(){
            if seedBag.label.text == "("{
                open = index
            }else if seedBag.label.text == ")"{
                close = index
            }
        }
        return (open,close)
    }
	
	
	func refactorClientAnswer(answer: String, _ scene: PhaseScene) -> String {
		var i = 0
		let equation = Array(scene.currentEqLabel.text!)
		
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
}

//Se, ao soltar da direita para a esquerda um numero, e duas posicoes antes desse numero, tiver um ")", remover os parenteses da direita

//Se, ao soltar um elemento da esquerda para a direita, ates da multiplicacao tiver um ")", remover parenteses da esquerda
