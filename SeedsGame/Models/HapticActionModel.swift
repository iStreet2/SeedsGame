//
//  HapticActionModel.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation
import CoreHaptics
import SwiftUI


// MARK: Testado
// MARK: Nao funcionando
class HapticAction: Action {
	
	private var intensity: Float
	private var sharpness: Float
	private var relativeTime: TimeInterval
	
	
	init(_ intensity: Float, _ sharpness: Float, _ relativeTime: TimeInterval = 0) {
		self.intensity = intensity
		self.sharpness = sharpness
		self.relativeTime = relativeTime
	}
	
	func execute() -> String {
		
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return "500" }
		
		@State var engine: CHHapticEngine
		
		var events = [CHHapticEvent]()
		
		// criar o haptic e tocá-lo imediatamente
		let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
		let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
		let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
		events.append(event)
		
		// convertes os eventos em padrões e tocá-los, por padrão, imediatamente
		do {
			try engine = CHHapticEngine()
			try engine.start()
			
			do {
				let pattern = try CHHapticPattern(events: events, parameters: [])
				let player = try engine.makePlayer(with: pattern)
				try player.start(atTime: relativeTime)
			} catch {
				return "Failed to play pattern: \(error.localizedDescription)"
			}
			
		} catch {
			print("Error starting the engine: \(error.localizedDescription)")
		}
		
		return "200"
	}
	
	
}
