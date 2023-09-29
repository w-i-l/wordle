//
//  GridView.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import SwiftUI

fileprivate struct CellView: View {
    
    let color: Color
    let text: String?
    let isRotating: Bool
    
    var body: some View {
        ZStack {
            // clear part
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color("gray.border"))
                    .background(color.cornerRadius(12))
                
                Text(text ?? "")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                    .fontWeight(.heavy)
                    .rotation3DEffect(.degrees(isRotating ? 180 : 0), axis: (x: 1, y: 0, z: 0))
            }
        }
        .rotation3DEffect(.degrees(isRotating ? 180 : 0), axis: (x: 1, y: 0, z: 0))
        .animation(.default, value: isRotating)
    }
}

struct GridView: View {
    
    private var cellDimension: CGFloat {
        let padding: CGFloat = 50
        return (UIScreen.main.bounds.width - 2 * padding ) / 5
    }
    
    private let words: [String]
    
    @StateObject private var viewModel: GridViewModel = .init()
    @State private var offset: CGFloat = .zero
    @State private var shouldRotate: Bool = false
    
    init(textToDisplay: String) {
        self.words = textToDisplay.split(separator: "\n").map { String($0) }
    }
    
    var body: some View {
        VStack {
            ForEach(0..<6, id: \.self) { row in
                HStack {
                    ForEach(0..<5, id: \.self) { column in
                        let pattern = viewModel.patterns[row, column]
                        let color = pattern == nil ? Color.black : pattern!.getColor()
                        CellView(
                            color: color,
                            text: words.index(row: row, column: column),
                            isRotating: viewModel.shouldRotateMatrix[row, column]!
                        )
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
                .onChange(of: viewModel.lastRow) { newValue in
                    guard newValue == 0 else { return }
                    let wordToGuess = AppService.shared.wordToGuess.value
                    viewModel.shouldRotateMatrix = (0..<6).map { _ in
                        Array(repeating: true, count: 5)
                    }
                    AppService.shared.wordToGuess.value = wordToGuess
                    viewModel.shouldRotateMatrix = (0..<6).map { _ in
                        Array(repeating: false, count: 5)
                    }
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
