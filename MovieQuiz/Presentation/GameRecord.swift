//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Мария Солодова on 08.12.2022.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetter(than game: GameRecord) -> Bool {
        if correct > game.correct {
            return true
        } else {
            return false
        }
    }
}
