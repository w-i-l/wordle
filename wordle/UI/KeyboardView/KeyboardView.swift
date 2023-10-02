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
    
    private var specialButtonPressed: Bool {
        buttonType != .letter && showCellPressed
    }
    
    @State private var showCellPressed: Bool = false
    var body: some View {
        ZStack {
            
            // actual keyboard cell
            ZStack {
                Group {
                    switch buttonType {
                    case .letter:
                        Color("gray")
                    case .delete:
                        showCellPressed ? Color(red: 120, green: 47, blue: 41) : Color.red
                    case .enter:
                        showCellPressed ? Color(red: 120, green: 47, blue: 41) : Color.green
                    }
                }
                .cornerRadius(12)
                
                Text(text)
                    .foregroundColor(specialButtonPressed ? .gray : .white)
                    .font(.system(size: 20, weight: .bold))
            }
            
            .onTapGesture {
                showCellPressed = true
                buttonAction()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showCellPressed = false
                }
            }

            
            
            
            if showCellPressed && buttonType == .letter{
                VStack(spacing: 0) {
                    // actual keyboard cell
                    ZStack {
                        VStack(spacing: 0) {
                            Color("gray")
                                .frame(width: dimension.width * 1.5, height: dimension.height * 1.5)
                                .cornerRadius(12)
                            Color("gray")
                                .frame(width: dimension.width * 1, height: dimension.height)
                        }
                        
                        
                        Text(text)
                            .foregroundColor(.white)
                            .font(.system(size: 28, weight: .heavy))
                            .offset(y: -dimension.height / 2)
                    }
                    .frame(width: dimension.width, height: dimension.height * 1.5)
                }
                .offset(y: -dimension.height)
                .frame(width: buttonType == .letter ? dimension.width : nil, height: dimension.height)
            }
        }
        .frame(width: buttonType == .letter ? dimension.width : nil, height: dimension.height)
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
