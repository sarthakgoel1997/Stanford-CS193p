//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 1/1/26.
//

import SwiftUI

typealias Peg = String

let supportedColors: [String: Color] = [
    "red": .red,
    "blue": .blue,
    "green": .green,
    "yellow": .yellow,
    "black": .black,
    "orange": .orange,
    "pink": .pink,
    "purple": .purple,
    "brown": .brown,
    "cyan": .cyan
]

extension String {
    var pegColor: Color? {
        supportedColors[self]
    }
}

struct CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts = [Code]()
    var pegChoices: [Peg]
    var currentGame: GameType
    
    static let availableColors: [String] = Array(supportedColors.keys)
    static let availableEmojis: [String] = ["🙂", "📁", "🚀", "🔥", "😂", "🐕", "🚗", "⚽️"]
    
    enum GameType {
        case color
        case emoji
    }
    
    init(pegChoices: [Peg] = ["red", "green", "yellow", "blue"]) {
        if let _ = pegChoices[0].pegColor {
            currentGame = .color
        } else {
            currentGame = .emoji
        }
        
        self.pegChoices = pegChoices
        masterCode = Code(kind: .master, pegsCount: pegChoices.count)
        masterCode.randomize(from: pegChoices)
        
        guess = Code(kind: .guess, pegsCount: pegChoices.count)
        print(masterCode)
    }
    
    mutating func attemptGuess() {
        if emptyAttempt() || attemptAlreadyMade() {
            return
        }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
    
    mutating func restart() {
        randomizePegChoices()
        masterCode.randomize(from: pegChoices)
        guess.resetPegs(pegsCount: pegChoices.count)
        attempts.removeAll()
    }
    
    mutating func randomizePegChoices() {
        let count = Int.random(in: 3...6)
        let colorGame = Bool.random()
        
        if colorGame {
            currentGame = .color
            pegChoices = Array(CodeBreaker.availableColors.shuffled().prefix(count))
        } else {
            currentGame = .emoji
            pegChoices = Array(CodeBreaker.availableEmojis.shuffled().prefix(count))
        }
    }
    
    func emptyAttempt() -> Bool {
        for index in guess.pegs.indices {
            if guess.pegs[index] != Code.missingPeg {
                break
            }
            
            if(index == guess.pegs.count - 1) {
                return true
            }
        }
        return false
    }
    
    func attemptAlreadyMade() -> Bool {
        if attempts.contains(where: { attempt in
            attempt.pegs == guess.pegs
        }) {
            return true
        }
        return false
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
}

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    init(kind: Kind, pegsCount: Int) {
        self.kind = kind
        pegs = Array(repeating: Code.missingPeg, count: pegsCount)
    }
    
    static let missingPeg: Peg = ""
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        pegs = Array(repeating: Code.missingPeg, count: pegChoices.count)
        for index in pegChoices.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
    }
    
    mutating func resetPegs(pegsCount: Int) {
        pegs = Array(repeating: Code.missingPeg, count: pegsCount)
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs
        
        let backwardsExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return Match.exact
            } else {
                return .nomatch
            }
        }
        
        let exactMatches = Array(backwardsExactMatches.reversed())
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
    }
}
