//
//  SplashViewModel.swift
//  WeatherApp
//
//  Created by TaqieAllah on 27/05/2026.
//

import Foundation

@Observable
class SplashViewModel {
    var isAnimationFinished: Bool = false
    
    func startSplashTimeout(seconds: Double = 5.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.isAnimationFinished = true
        }
    }
}
