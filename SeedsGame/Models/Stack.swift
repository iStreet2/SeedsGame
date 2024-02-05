//
//  Stack.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 23/01/24.
//

import Foundation

struct Stack {
	var items: [String] = []
	
	
	func top() -> String {
		return items.last ?? ""
	}
	
	
	func isEmpty() -> Bool {
		return items.count == 0
	}
	
	
	mutating func push(_ s: String) {
		items.append(s)
	}
	
	
	mutating func pop() -> String {
		if !isEmpty() {
			return items.removeLast()
		}
		return ""
	}
	
	
	mutating func clear() {
		items.removeAll()
	}
	
	
}

