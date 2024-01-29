//
//  OperationActionModel.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation

class OperationAction: Action {
	
	var eq: String
	
	var xQ = Queue()
	var numQ = Queue()
	
	
	init(eq: String) {
		self.eq = eq
	}
	
	// ["+..", "+", "-4", "=", "-.....", "+", "+10"]
	
	func execute() -> String {
		print("executando ação!")
		return prepareEq(eq)
	}
	
	
	// devolve resultado de equação sem incógnita
	func evaluate(eq: String) -> String {
		let expression: NSExpression = NSExpression(format: eq)
		let result: Double = expression.expressionValue(with: nil, context: nil) as! Double
		var sResult = String(Int(result))
		
		if Array(sResult)[0] == "+" {
			return String(sResult.remove(at: sResult.startIndex))
		}
		return sResult
	}
	
	
	// função principal pra preparar a equação pra ela conseguir ser "juntada" pelo botão de juntar
	func prepareEq(_ equation: String) -> String {
		print("Preparing Equation!")
		if equation.isEmpty {
			return ""
		}
		
		var joinedEquation = joinAllNumbers(equation)
		var joinedXEquation = joinXwithNum(joinedEquation)
		
		var resultEquation = equationEvaluator(joinedXEquation)
		
		return resultEquation
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
	
	
	func joinXwithNum(_ equation: [String]) -> [String] {
		var i = 0
		var resultEquation: [String] = []
		
		
		while i < equation.count {
			var currentNum = ""
			
			// se for número e não for o último
			if equation[i].isNumber && i < equation.count - 1 {
				currentNum.append(equation[i])
				
				// se o próximo for x
				if equation[i+1] == "x" {
					currentNum.append("x")
					i += 1
				}
				i += 1
				resultEquation.append(currentNum)
			}
			
			else {
				currentNum.append(equation[i])
				resultEquation.append(currentNum)
				i += 1
			}
			
		}
		return resultEquation
	}
	
	
	func equationEvaluator(_ equation: [String]) -> String {
		var i = 0
		var resultString = ""
		let operandos = ["+", "-", "/", "*"]
		
		// primeira metade
		while i < equation.count && equation[i] != "=" {
			var currentNum = ""
			
			if equation[i].contains("x") {
				
				if i > 0 {
					if operandos.contains(equation[i-1]) {
						currentNum.append(equation[i-1])
					}
				}
				
				if equation[i].count == 1 {
					currentNum.append("1")
				} else {
					let number = equation[i].components(separatedBy: CharacterSet.decimalDigits.inverted).joined() // pegamos o número que estava com o X
					currentNum.append(number)
				}
				
				xQ.enqueue(currentNum)
				print("\(xQ)")
			}
			
			else if !operandos.contains(equation[i]) {
				if i > 0 {
					if operandos.contains(equation[i-1]) {
						currentNum.append(equation[i-1])
					}
				}
				
				currentNum.append(equation[i])
				
				numQ.enqueue(currentNum)
				print("\(numQ)")
			}
			
			i += 1
		}
		// primeira metade da equação está feita e separada nas diferentes filas
		
		// MARK: Avaliando partes com X
		var xFirstResultEquation = ""
		for item in xQ.items {
			xFirstResultEquation += item
		}
		if Array(xFirstResultEquation)[0] == "+" {
			xFirstResultEquation.remove(at: xFirstResultEquation.startIndex)
		}
		var xFirstResultString = evaluate(eq: xFirstResultEquation)
		print("Resultado de \(xFirstResultEquation) = \(xFirstResultString)")
		
		
		// MARK: Avaliando partes sem X
		var numFirstResultEquation = ""
		for item in numQ.items {
			numFirstResultEquation += item
		}
		if Array(numFirstResultEquation)[0] == "+" {
			numFirstResultEquation.remove(at: numFirstResultEquation.startIndex)
		}
		var numFirstResultString = evaluate(eq: numFirstResultEquation)
		print("Resultado de \(numFirstResultEquation) = \(numFirstResultString)")
		
		// segunda metade da equação
		var j = i + 1
		xQ.clear()
		numQ.clear()
		
		while j < equation.count {
			var currentNum = ""
			
			if equation[j].contains("x") {
				
				if j - i > 0 {
					if operandos.contains(equation[j-1]) {
						currentNum.append(equation[j-1])
					}
				}
				
				if equation[j].count == 1 {
					currentNum.append("1")
				} else {
					let number = equation[j].components(separatedBy: CharacterSet.decimalDigits.inverted).joined() // pegamos o número que estava com o X
					currentNum.append(number)
				}
				
				xQ.enqueue(currentNum)
				print("\(xQ)")
			}
			
			else if !operandos.contains(equation[j]) {
				if j > 0 {
					if operandos.contains(equation[j-1]) {
						currentNum.append(equation[j-1])
					}
				}
				
				currentNum.append(equation[j])
				
				numQ.enqueue(currentNum)
				print("\(numQ)")
			}
			
			j += 1
		}
		
		// MARK: Avaliando segunda parte com X
		var xSecondResultEquation = ""
		for item in xQ.items {
			xSecondResultEquation += item
		}
		if Array(xSecondResultEquation)[0] == "+" {
			xSecondResultEquation.remove(at: xSecondResultEquation.startIndex)
		}
		var xSecondResultString = evaluate(eq: xSecondResultEquation)
		print("Resultado de \(xSecondResultEquation) = \(xSecondResultString)")
		
		// MARK: Avaliando segunda parte sem X
		var numSecondResultEquation = ""
		for item in numQ.items {
			numSecondResultEquation += item
		}
		if Array(numSecondResultEquation)[0] == "+" {
			numSecondResultEquation.remove(at: numSecondResultEquation.startIndex)
		}
		var numSecondResultString = evaluate(eq: numSecondResultEquation)
		print("Resultado de \(numSecondResultEquation) = \(numSecondResultString)")
		
		if Int(numFirstResultString)! >= 0 {
			numFirstResultString = "+" + numFirstResultString
		}
		
		if Int(numSecondResultString)! >= 0 {
			numSecondResultString = "+" + numSecondResultString
		}
		resultString = xFirstResultString+"x" + numFirstResultString + "=" + xSecondResultString+"x" + numSecondResultString
		
		return resultString
	}
	
	
}


extension String {
	var isNumber: Bool {
		return self.range(
			of: "^[0-9]*$", // 1
			options: .regularExpression) != nil
	}
}
