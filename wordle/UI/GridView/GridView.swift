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
    
    @StateObject private var viewModel: GridViewModel = .init()
    @State private var offset: CGFloat = .zero
    
    init(textToDisplay: String) {
        self.words = textToDisplay.split(separator: "\n").map { String($0) }
    }
    
    var body: some View {
        VStack {
            ForEach(0..<6, id: \.self) { row in
                HStack {
                    ForEach(0..<5, id: \.self) { column in
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color("gray.border"))
                                .background(
                                    (viewModel.patterns.index(row: row, column: column) == nil ? Color.clear : viewModel.patterns.index(row: row, column: column)?.getColor())
                                        .cornerRadius(12)
                                )
                            
                            Text(words.index(row: row, column: column) ?? "")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                                .fontWeight(.heavy)
                        }
                        .frame(width: cellDimension, height: cellDimension)
                        
                    }
                }
                .offset(x: viewModel.currentRow == row ? offset : .zero)
                .onChange(of: viewModel.invalidWordEntered) { newValue in
                    guard newValue else { return }
                    
                    withAnimation(.default.repeatCount(1, autoreverses: true)) {
                        offset -= 40
                    }
                    
                    withAnimation(.default) {
                        offset += 80
                    }

                    withAnimation(.default) {
                        offset = .zero
                    }

                    AppService.shared.invalidWordEntered.value = false
                }
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(textToDisplay: "ANAME\nMERAT\nLOPOL\nJUIOL\nFRECT\nJUIYD")
    }
}
