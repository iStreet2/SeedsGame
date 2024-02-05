//
//  ButtonEnum.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 31/01/24.
//

import Foundation
import SwiftUI

enum SquareImages: String {
    case gameCenter = "Botao - GameCenter"
    case play = "Botao - Play"
    case home = "Botao - Home"
    case config = "Botao - Config"
    case close = "Botao - Fechar"
    case back = "Botao - Voltar"
    case pause = "Botao - Pause"
    
    var pressed: String {
        switch self {
        case .gameCenter: return "Botao - GameCenter Pressionado"
        case .play: return "Botao - Play Pressionado"
        case .home: return "Botao - Home Pressionado"
        case .config: return "Botao - Config Pressionado"
        case .close: return "Botao - Fechar Pressionado"
        case .back: return "Botao - Voltar Pressionado"
        case .pause: return "Botao - Pause Pressionado"
        }
    }
}

enum RectangleImages: String {
    case type1 = "Botao - Texto 1"
    case type2 = "Botao - Texto 2"
    case story = "Fundo Modo Historia"
    
    var pressed: String {
        switch self {
        case .type1: return "Botao - Texto 1 Pressionado"
        case .type2: return "Botao - Texto 2 Pressionado"
        case .story: return "Fundo Modo Historia Pressionado"
        }
    }
}

enum PhasesFrases: String {
    case win = "Successo nas \nVendas!"
    case failed = "Você faliu!"
    case uncoverd = "Você foi \ndescoberto!"
}

