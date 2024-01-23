//
//  OperationActionModel.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation

class OperationAction: Action {
	
	var eq: [String]
	
	var xStack = Stack()
	var numStack = Stack()
	
	
	init(eq: String) {
		print("initializing equation action!")
		self.eq = ["0"]
		let exp = prepareEq(eq)
		
		self.eq = exp
	}
	
	// ["+..", "+", "-4", "=", "-.....", "+", "+10"]
	
	func execute() {
		print("executando ação!")
//		let currentNum = eq[0]
		
//		var allIsSameType = true
		
		// Lado esquerdo da equação
//		while currentNum != "=" {
//			if currentNum.contains(".") {
//				xStack.push(currentNum)
//			} else {
//				allIsSameType = false
//				numStack.push(currentNum)
//			}
//			
//		}
		
		// Lado direito da equação
		
		
	}
	
	
	// botao de juntar os valores
	func evaluate(eq: String) -> Double {
		let expression: NSExpression = NSExpression(format: eq)
		let result: Double = expression.expressionValue(with: nil, context: nil) as! Double
		return result
	}
	
	
	func prepareEq(_ equation: String) -> [String] {
		print("Preparing Equation!")
		if equation.isEmpty {
			return []
		}
		
		var joinedEquation = joinAllNumbers(equation)
		return joinedEquation
	}
	
	
	func joinAllNumbers(_ equation: String) -> [String] {
		print("Joining numbers!")
		var resultEquation: [String] = []
		let eq = Array(equation)
		
		var i = 0
		
		while i < eq.count {
			
			var currentNum = ""
			
			if eq[i].isNumber {
				currentNum.append(eq[i])
				
				var j = i + 1
				
				while j < eq.count {
					if eq[j].isNumber {
						currentNum.append(eq[j])
					}
					else {
						break
					}
					j += 1
				}
				i += j-i-1
			}
			else {
				currentNum.append(eq[i])
			}
			resultEquation.append(currentNum)
			i += 1
		}
		print("joinedResultEquation = \(resultEquation)")
		return resultEquation
	}
	
	
}


