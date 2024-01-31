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
	
	
	//MARK: Junta números
	static public func joinAllNumbers(_ equation: String) -> [String] {
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
	
	
	
	//MARK: Junta X com números
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
		
		print("joinedResultEquation = \(resultEquation)")
		
		return resultEquation
	}
	
	
	
	//MARK: Separa em filas
	//Separa a equação em duas filas, uma de valores da incognita e outra dos números
	func equationSeparator(_ equation: [String], i: inout Int, dif: Int){
		let operandos = ["+", "-", "/", "*"]
		
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
		
	}
	
	
	// devolve resultado da equação
	func evaluate(eq: String) -> String {
		let expression: NSExpression = NSExpression(format: eq)
		let result: Double = expression.expressionValue(with: nil, context: nil) as! Double
		var sResult = String(Int(result))
		
		if Array(sResult)[0] == "+" {
			return String(sResult.remove(at: sResult.startIndex))
		}
		return sResult
	}
	
	
	func checkPlus(Q: Queue) -> String {
		if Q.items.isEmpty {
			return "0"
		}
		var ResultEquation = ""
		for item in Q.items {
			ResultEquation += item
		}
		if Array(ResultEquation)[0] == "+" {
			ResultEquation.remove(at: ResultEquation.startIndex)
		}
		var ResultString = evaluate(eq: ResultEquation) 
		print("Resultado de \(ResultEquation) = \(ResultString)")
		return ResultString
	}
	
	
	//MARK: faz resultado
	func equationEvaluator(_ equation: [String]) -> String {
		var i = 0
		var resultString = ""
		let operandos = ["+", "-", "/", "*"]
		
		// primeira metade
		equationSeparator(equation, i: &i, dif: i)
		// primeira metade da equação está feita e separada nas diferentes filas
		
		//MARK: Parte 1
		var xFirstResultString = checkPlus(Q: xQ)
		var numFirstResultString = checkPlus(Q: numQ)
		
		
		// segunda metade da equação
		var j = i + 1
		xQ.clear()
		numQ.clear()
		
		
		equationSeparator(equation, i: &j, dif: j-i)
		
		//MARK: Parte 2
		var xSecondResultString = checkPlus(Q: xQ)
		var numSecondResultString = checkPlus(Q: numQ)
		
		if Int(numFirstResultString)! >= 0 && xFirstResultString != "0" {
			numFirstResultString = "+" + numFirstResultString
		}
		
		if Int(numSecondResultString)! >= 0 && xSecondResultString != "0" {
			numSecondResultString = "+" + numSecondResultString
		}
		print("\n-----\nxFirst: \(xFirstResultString)\nnumFirst: \(numFirstResultString)\nxSecond: \(xSecondResultString)\nnumSecond: \(numSecondResultString)\n-----")
		resultString = buildResultString(xFirst: xFirstResultString, numFirst: numFirstResultString, xSecond: xSecondResultString, numSecond: numSecondResultString)
		
		return resultString
	}
	
	func buildResultString(xFirst: String, numFirst: String, xSecond: String, numSecond: String) -> String {
		var resultString = ""
		
		if xFirst != "0" {
			switch xFirst {
			case "1":
				resultString += "x"
			default:
				resultString += xFirst + "x"
			}
		}
		
		if numFirst != "0" && numFirst != "+0" {
			resultString += numFirst
		}
		
		if xFirst == "0" && numFirst == "0" {
			resultString += "0"
		}
		
		// METADE
		resultString += "="
		
		if xSecond != "0" {
			switch xSecond {
			case "1":
				resultString += "x"
			default:
				resultString += xSecond + "x"
			}
		}
		
		if numSecond != "0" && numSecond != "+0" {
			resultString += numSecond
		}
		
		if xSecond == "0" && numSecond == "0" {
			resultString += "0"
		}
		
		print("BuildResultString() -> \(resultString)")
		return resultString
	}
	
	
	//MARK: Chama tudo e devolve
	// função principal pra preparar a equação pra ela conseguir ser "juntada" pelo botão de juntar
	func prepareEq(_ equation: String) -> String {
		print("Preparing Equation!")
		if equation.isEmpty {
			return ""
		}
		
		var joinedEquation = OperationAction.joinAllNumbers(equation)
		var joinedXEquation = joinXwithNum(joinedEquation)
		
		var resultEquation = equationEvaluator(joinedXEquation)
		
		return resultEquation
	}
	
}


extension String {
	var isNumber: Bool {
		return self.range(
			of: "^[0-9]*$", // 1
			options: .regularExpression) != nil
	}
}
