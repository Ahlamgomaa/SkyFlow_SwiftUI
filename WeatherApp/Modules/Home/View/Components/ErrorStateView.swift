//
//  ErrorStateView.swift
//  WeatherApp
//
//  Created by TaqieAllah on 29/05/2026.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.blue)
            
            Text("Oops! Something went wrong")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            Button(action: onRetry) {
                Text("Retry")
                    .bold()
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.black.opacity(0.75).cornerRadius(16))
        .foregroundColor(.white)
        .padding(.horizontal, 32)
    }
}
