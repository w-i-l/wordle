//
//  GridView.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import SwiftUI

struct GridView: View {
    
    private var cellDimension: CGFloat {
        let padding: CGFloat = 50
        return (UIScreen.main.bounds.width - 2 * padding ) / 5
    }
    
    private let words: [String]
    
    init(textToDisplay: String) {
        self.words = textToDisplay.split(separator: "\n").map { String($0) }
    }
    
    var body: some View {
        Grid {
            ForEach(0..<6, id: \.self) { row in
                GridRow(alignment: nil) {
                    ForEach(0..<5, id: \.self) { column in
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color("gray.border"))
                            
                            Text(words.index(row: row, column: column) ?? "")
                                .foregroundColor(.white)
                        }
                        .frame(width: cellDimension, height: cellDimension)
                    }
                }
            }
        }
    }
}

extension [String] {
    func index(row: Int, column: Int) -> String? {
        guard row >= 0 && row < self.count else { return nil }
        
        let string = self[row]
        
        guard column >= 0 && column < string.count else { return nil}
        let index = string.index(string.startIndex, offsetBy: column)
        return String(string[index])
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(textToDisplay: "ANAME\nMERAT\nLOPOL\nJUIOL\nFRECT\nJUIYD")
    }
}
