//
//  ContentView.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    var body: some View {
        
        VStack {
            Spacer()
            Text("Input text")
                .foregroundColor(.gray)
            
            Text(viewModel.stream)
                .foregroundColor(.white)
            
            Spacer()
            KeyboardView()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

class ContentViewModel: BaseViewModel {
    @Published var stream = ""
    
    override init() {
        
        super.init()
        
        KeyboardService.shared.stream
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stream in
                self?.stream = stream
            }
            .store(in: &bag)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
