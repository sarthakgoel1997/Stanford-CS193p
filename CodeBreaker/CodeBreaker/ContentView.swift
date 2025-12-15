//
//  ContentView.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 12/13/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            pegs(colors: [.yellow, .blue, .green, .red])
            pegs(colors: [.yellow, .red, .green, .blue])
            pegs(colors: [.yellow, .green, .blue, .blue])
        }
        .padding()
    }
    
    func pegs(colors: Array<Color>) -> some View {
        HStack {
            ForEach(colors.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(colors[index])
            }
            MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
        }
    }
}

#Preview {
    ContentView()
}
