//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 1/1/26.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts = [Code]()
    let pegChoices: [Peg]
    
    init(pegChoices: [Peg] = [.red, .green, .yellow, .blue]) {
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
        masterCode.randomize(from: pegChoices)
        guess.resetPegs()
        attempts.removeAll()
    }
    
    func emptyAttempt() -> Bool {
        for index in guess.pegs.indices {
            if guess.pegs[index] != Code.missing {
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
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
}

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    init(kind: Kind, pegsCount: Int) {
        self.kind = kind
        pegs = Array(repeating: Code.missing, count: pegsCount)
    }
    
    static let missing: Peg = .clear
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegChoices.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    mutating func resetPegs() {
        pegs = Array(repeating: Code.missing, count: pegs.count)
    }
    
    var matches: [Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        
        return results
    }
}
