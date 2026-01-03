//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by Sarthak Goel on 12/14/25.
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    var matches: [Match]
    
    var body: some View {
        let mid = (matches.count + 1) / 2
        
        VStack(alignment: .leading) {
            HStack {
                ForEach(matches[..<mid].indices, id: \.self) { index in
                    matchMarker(peg: index)
                }
                
                if(matches.count == 0) {
                    matchMarker(peg: 0)
                    matchMarker(peg: 1)
                }
                
            }
            HStack {
                ForEach(matches[mid...].indices, id: \.self) { index in
                    matchMarker(peg: index)
                    
                    if matches.count % 2 != 0 && index == matches.count - 1 {
                        matchMarker(peg: index + 1)
                    }
                }
                
                if(matches.count == 0) {
                    matchMarker(peg: 2)
                    matchMarker(peg: 3)
                }
            }
        }
    }
    
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count{ $0 == .exact }
        let foundCount = matches.count{ $0 != .nomatch }
        
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}

struct MatchMarkersPreview: View {
    var matches: [Match]
    
    var body: some View {
        HStack {
            ForEach(matches, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
            }
            
            MatchMarkers(matches: matches)
        }
    }
}

#Preview {
    VStack(alignment: .leading) {
        MatchMarkersPreview(matches: [.exact, .inexact, .inexact])
            .frame(height: 42)
            .padding()
        
        MatchMarkersPreview(matches: [.exact, .nomatch, .nomatch])
            .frame(height: 42)
            .padding()
        
        MatchMarkersPreview(matches: [.exact, .inexact, .inexact, .exact])
            .frame(height: 42)
            .padding()
        
        MatchMarkersPreview(matches: [.exact, .inexact, .nomatch, .exact])
            .frame(height: 42)
            .padding()
        
        MatchMarkersPreview(matches: [.exact, .inexact, .nomatch, .nomatch])
            .frame(height: 42)
            .padding()
        
        MatchMarkersPreview(matches: [.exact, .inexact, .inexact, .exact, .inexact])
            .frame(height: 42)
            .padding()
        
        MatchMarkersPreview(matches: [.exact, .inexact, .inexact, .nomatch, .nomatch])
            .frame(height: 42)
            .padding()
        
        MatchMarkersPreview(matches: [.exact, .exact, .exact, .nomatch, .inexact])
            .frame(height: 42)
            .padding()
        
        MatchMarkersPreview(matches: [.exact, .inexact, .inexact, .exact, .exact, .inexact])
            .frame(height: 42)
            .padding()
    }
}
