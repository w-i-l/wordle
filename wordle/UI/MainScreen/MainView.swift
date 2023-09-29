//
//  MainView.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import SwiftUI
import AlertToast

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            
            Image("logo")
                .resizable()
                .frame(height: 50)
                .padding(20)
            
            Spacer()
            
            Text(viewModel.wordToGuess)
                .foregroundColor(.white)
                .font(.subheadline)
            
            GridView(textToDisplay: viewModel.stream)
            
            Spacer()
            
            KeyboardView()
                .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .toast(
            isPresenting: $viewModel.didGameEnded,
            tapToDismiss: true) {
                AlertToast(
                    displayMode: .alert,
                    type: .systemImage("checkmark.circle.fill", .green),
                    title: "Game finished"
                )
            } completion: {
                AppService.shared.newGame()
            }

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
