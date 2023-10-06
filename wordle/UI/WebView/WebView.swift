//
//  WebView.swift
//  wordle
//
//  Created by Mihai Ocnaru on 06.10.2023.
//

import Foundation
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: self.url) {
            let urlRequest = URLRequest(url: url)
            uiView.load(urlRequest)
        }
    }
}
