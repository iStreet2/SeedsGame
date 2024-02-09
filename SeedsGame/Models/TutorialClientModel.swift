//
//  TutorialClientModel.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 08/02/24.
//

import Foundation
import SpriteKit

@Observable class TutorialClientModel: SKSpriteNode {
	
	static let shared = TutorialClientModel()
	
	var wantsGalacticSeed = true
	
	var initialEq = "2+x=4"
	var eq = "2+x=4"
	
	let sprite = "M Roxo - Neutro"
	
	let rightAnswerFala = "Parabéns! É isso \nmesmo que eu queria."
	let wrongAnswerFala = "Poxa... Eu queria algo \ndiferente, mas vamos em frente!"
	
	let rightSideralFala = "Boa! Era a semente\nsideral mesmo!"
	let wrongSideralFala = "Olha... eu queria as siderais,\nmas essas vão dar pro gasto"
	
	let falas: [String] = ["Oi, senhor Bhas!\n ",
								  "É seu primeiro dia com a loja, né?\nMuito bonita!",
								  "Bom, vou querer\n2+x=4 sementes!",
								  "2+x=4\n ",
								  "Agora que temos tudo\nna bancada...",
								  "Movimento os sacos de semente\npara encontrar o valor de x.",
								  "Só não se esqueça de trocar os\noperadores, é só tocá-los.",
								  "Lembre-se de que você tem\nvárias ferramentas ao seu dispor!",
								  "O botão com uma seta\ndesfaz o seu último movimento.",
								  "O botão com o fogo\nreinicia a equação.",
								  "A alavanca efetua as\noperações possíveis.",
								  "Leve o tempo que for preciso\npara resolver essa equação.",
								  "Mas antes de me entregar \no saco de sementes...",
								  "Se atente aos balões de \nfala dos clientes.",
								  "Você precisa se lembrar qual tipo \nde sementes o cliente quer.",
								  "Quando o balão de fala for assim, \nentregue as sementes normais.",
								  "Quando o balão for assim, \nentregue as sementes siderais!",
								  "E aí, qual tipo de \nsementes eu quero?",
								  "Antes de eu ir...",
								  "Só um aviso... A minha prima Rose,\naquela que usa óculos.",
								  "Ela é jornalista, e ela quer o\nsegredo das suas sementes.",
								  "Pelo bem do seu negócio, NUNCA\ndê as sementes siderais pra ela",
								  "Confia em mim, a Rose é dose",
								  "Bom, vou te deixar voltar a\nseu trabalho agora"
	]
	
	// [3] = equação
	// [11] = Leve o tempo para resolver
	// [11+1] = resposta de exatidão do saco único
	// [12] = mas antes de entregar o saco...
	// [16] = mudar Sprite do balão para sideral
	// [17] = habilitar movimentação do saco para entregar a semente
	
	init() {
		let texture = SKTexture(imageNamed: "M Roxo - Neutro")
		let color: UIColor = .clear
		let size: CGSize = CGSize(width: 130, height: 233)
		
		super.init(texture: texture, color: color, size: size)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
