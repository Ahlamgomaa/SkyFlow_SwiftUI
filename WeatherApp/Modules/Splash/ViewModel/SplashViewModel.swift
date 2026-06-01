

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
