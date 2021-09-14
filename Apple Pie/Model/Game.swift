//
//  Game.swift
//  Game
//
//  Created by Никита Раташнюк on 13.09.2021.
//

import Foundation

struct Game {
    var word: String
    var remainingAttempts: Int
    private var usedLetters: [Character] = []
    
    var guessedWord: String {
        var wordToShow = ""
        for letter in word {
            if usedLetters.contains(Character(letter.uppercased())) {
                wordToShow += String(letter)
            } else {
                wordToShow += "_"
            }
        }
        
        return wordToShow
    }
    
    init(word: String, remainingAttempts: Int) {
        self.word = word
        self.remainingAttempts = remainingAttempts
    }
    
    mutating func playerGuessed(letter: Character) {
        usedLetters.append(letter)
        if !word.uppercased().contains(letter) {
            remainingAttempts -= 1
        }
    }
}
