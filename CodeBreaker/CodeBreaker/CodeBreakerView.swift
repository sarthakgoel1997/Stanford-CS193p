//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 12/13/25.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker(pegChoices: ["🙂", "😂", "❤️", "📆", "📂"])
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            restartButton
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    var restartButton: some View {
        Button("Restart Game") {
            withAnimation {
                game.restart()
            }
        }
        .font(.title2)
    }
    
    func coloredPeg(code: Code, index: Int) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .overlay {
                if code.pegs[index] == Code.missing {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.gray)
                }
            }
            .contentShape(Rectangle())
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(code.pegs[index].pegColor ?? .clear)
            .onTapGesture {
                if code.kind == .guess {
                    game.changeGuessPeg(at: index)
                }
            }
    }
    
    func emoji(code: Code, index: Int) -> some View {
        GeometryReader { geo in
            Text(code.pegs[index])
                .font(.system(size: geo.size.width * 0.8))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    if(code.pegs[index] == Code.missing) {
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if code.kind == .guess {
                        game.changeGuessPeg(at: index)
                    }
                }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                
                if CodeBreaker.currentGame == "color" {
                    coloredPeg(code: code, index: index)
                } else {
                    emoji(code: code, index: index)
                }
            }
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                    }
                }
        }
    }
}

#Preview {
    CodeBreakerView()
}
