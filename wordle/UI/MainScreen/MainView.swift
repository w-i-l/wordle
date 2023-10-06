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
    @State private var showAdminPasswordTextField = false
    @State private var enteredPassword = ""
    var body: some View {
        ZStack {
            VStack {
                
                Image("logo")
                    .resizable()
                    .frame(height: 50)
                    .padding(20)
                
                Spacer()
                
                if viewModel.hasUserAdminRights {
                    HStack {
                        Text(viewModel.wordToGuess)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            
                        Button {
                            viewModel.hasUserAdminRights = false
                        } label: {
                            Text("Disable admin")
                                .foregroundColor(.blue)
                                .font(.system(size: 18, weight: .light))
                        }

                    }
                    
                } else {
                    Button {
                        showAdminPasswordTextField = true
                    } label: {
                        Text("Enable admin rights")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 16, weight: .ultraLight))
                    }
                }
                
                
                GridView(textToDisplay: viewModel.stream)
                
                Spacer()
                
                KeyboardView()
                    .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
            
            if viewModel.didGameEnded == true && !AppService.shared.patterns.value.isEmpty {
                ModalView(didGameEnded: $viewModel.didGameEnded)
            }
        }
        /// TODO: admin panel 
        .sheet(isPresented: $showAdminPasswordTextField) {
            TextField("", text: $enteredPassword)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.gray.cornerRadius(12))
                .padding(10)
            
            Button {
                if enteredPassword == "123456" {
                    viewModel.hasUserAdminRights = true
                    showAdminPasswordTextField = false
                    enteredPassword = ""
                }
            } label: {
                Text("Submit")
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .bold))
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(20)
            }

        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
