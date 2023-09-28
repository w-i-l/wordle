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
                    Color.clear
                }
            }
                .cornerRadius(12)
            
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
        }
        .frame(width: buttonType == .letter ? 30 : nil, height: 40)
        .onTapGesture {
            buttonAction()
        }
    }
}

struct KeyboardView: View {
    
    @StateObject private var viewModel = KeyboardViewModel()
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach( [
                ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                ["Z", "X", "C", "V", "B", "N", "M"]
            ], id: \.self[0]) { row in
                HStack {
                    
                    if row.first! == "Z" {
                        KeyboardButtonView(
                            text: "",
                            buttonType: .enter) {
                                viewModel.enter()
                            }
                    }
                    
                    ForEach(row, id: \.self) { letter in
                        KeyboardButtonView(
                            text: letter,
                            buttonType: .letter) {
                                viewModel.type(letter: letter)
                            }
                    }
                    
                    if row.first! == "Z" {
                        KeyboardButtonView(
                            text: "DEL",
                            buttonType: .delete) {
                                viewModel.delete()
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 5)
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView()
    }
}
