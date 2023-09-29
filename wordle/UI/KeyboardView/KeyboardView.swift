//
//  KeyboardView.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import SwiftUI

fileprivate enum KeyboardButtonType {
    case letter
    case delete
    case enter
}

fileprivate struct KeyboardButtonView: View {
    
    let text: String
    let buttonType: KeyboardButtonType
    let dimension: (width: CGFloat, height: CGFloat)
    let buttonAction: () -> ()
    var body: some View {
        ZStack {
            Group {
                switch buttonType {
                case .letter:
                    Color("gray")
                case .delete:
                    Color.red
                case .enter:
                    Color.green
                }
            }
                .cornerRadius(12)
            
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
        }
        .frame(width: buttonType == .letter ? dimension.width : nil, height: dimension.height)
        .onTapGesture {
            buttonAction()
        }
    }
}

struct KeyboardView: View {
    
    @StateObject private var viewModel = KeyboardViewModel()
    
    private var keyboardButtonHeight: CGFloat = 45
    private var keyboarButtondWidth: CGFloat {
        (UIScreen.main.bounds.width - (10 * horizontalSpacing)) / 11
    }
    
    private var verticalSpacing: CGFloat = 4
    private var horizontalSpacing: CGFloat = 2
    var body: some View {
        VStack(spacing: verticalSpacing) {
            ForEach( [
                ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                ["Z", "X", "C", "V", "B", "N", "M"]
            ], id: \.self[0]) { row in
                HStack(spacing: horizontalSpacing * 2) {
                    
                    if row.first! == "Z" {
                        KeyboardButtonView(
                            text: "TRY",
                            buttonType: .enter,
                            dimension: (keyboarButtondWidth, keyboardButtonHeight)
                        ) {
                                viewModel.enter()
                            }
                    }
                    
                    ForEach(row, id: \.self) { letter in
                        KeyboardButtonView(
                            text: letter,
                            buttonType: .letter,
                            dimension: (keyboarButtondWidth, keyboardButtonHeight)
                        ) {
                                viewModel.type(letter: letter)
                            }
                    }
                    
                    if row.first! == "Z" {
                        KeyboardButtonView(
                            text: "DEL",
                            buttonType: .delete,
                            dimension: (keyboarButtondWidth, keyboardButtonHeight)
                        ) {
                                viewModel.delete()
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 5)
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView()
    }
}
