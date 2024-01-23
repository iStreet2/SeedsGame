//
//  Stack.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 23/01/24.
//

import Foundation

struct Stack {
	var items: [String] = []
	
	
	func peek() -> String {
		guard let topElement = items.first else { fatalError("This stack is empty.") }
		return topElement
	}
	
	
	mutating func pop() -> String {
		return items.removeFirst()
	}
	
	
	mutating func push(_ element: String) {
		items.insert(element, at: 0)
	}
	
	
}


extension Stack: CustomStringConvertible {
	var description: String {
		let topDivider = "---Stack---\n"
		
		let stackElements = self.items.joined(separator: "\n")
		
		let bottomDivider = "\n-----------\n"
		
		return topDivider + stackElements + bottomDivider
	}
}

