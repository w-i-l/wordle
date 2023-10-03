//
//  ModalView.swift
//  wordle
//
//  Created by Mihai Ocnaru on 03.10.2023.
//

import SwiftUI

struct ModalView: View {
    
    @StateObject private var viewModel: ModalViewModel = .init()
    @Binding var didGameEnded: Bool
    var body: some View {
        VStack(spacing: 10) {
            
            Text("Game finished")
                .foregroundColor(.gray)
                .font(.system(size: 28, weight: .heavy))
            
            HStack {
                
                Image(systemName: viewModel.didGameEnded == .lose ? "x.circle.fill" : "checkmark.circle.fill")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(viewModel.didGameEnded == .lose ? .red : .green)
                    .frame(width: 28, height: 28)
                
                Text(viewModel.didGameEnded == .lose ? "You lost!" : "You won!")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
            }
            
            Spacer()
            
            if viewModel.didGameEnded == .win {
                Text("Tries: ")
                    .foregroundColor(.gray)
                    .font(.system(size: 18, weight: .light))
                
                Text("\(AppService.shared.patterns.value.filter{$0.first != PatternType.none}.count)")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
            } else {
                Text("The seaarched word was: ")
                    .foregroundColor(.gray)
                    .font(.system(size: 18, weight: .light))
                Text("\(AppService.shared.wordToGuess.value)")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                
                Link(destination: viewModel.getURL()) {
                    Group {
                        Text("Learn more about it")
                            .font(.system(size: 18, weight: .medium))
                        Image(systemName: "arrow.right")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 16)
                    }
                }
                .foregroundColor(.blue.opacity(0.7))

            }
            Spacer()
            
            Button {
                didGameEnded = false
                AppService.shared.newGame()
            } label: {
                Text("Play again")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .padding(10)
                    .background(Color.blue.cornerRadius(12))
            }
            Spacer()
        }
        .padding(20)
        .frame(width: UIScreen.main.bounds.width * 2/3, height: UIScreen.main.bounds.height * 2/5)
        .background(Color.black)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.white)
        )
        .cornerRadius(12)
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(didGameEnded: .constant(false))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(MainView())
    }
}
