import SwiftUI
import AVKit

struct SplashView: View {
    @State private var viewModel = SplashViewModel()
    @State private var player: AVPlayer? = nil
    
    @State private var textOpacity = 0.0
    @State private var isAnimating = false
    private let textTitle = "Sky Logic"
    
    private let offsets: [(x: CGFloat, y: CGFloat, angle: Double)] = [
        (x: -120, y: -180, angle: -35),
        (x: 80,   y: -220, angle: 45),
        (x: -160, y: -50,  angle: -20),  
        (x: 0,    y: 0,    angle: 0),
        (x: 140,  y: -100, angle: 30),
        (x: -90,  y: 150,  angle: -40),
        (x: 160,  y: 180,  angle: 25),
        (x: -50,  y: 220,  angle: -15),
        (x: 110,  y: 120,  angle: 50)
    ]
    
    var body: some View {
        if viewModel.isAnimationFinished {
            HomeView()
        } else {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                if let player = player {
                    VideoPlayer(player: player)
                        .disabled(true)
                        .ignoresSafeArea()
                        .aspectRatio(contentMode: .fill)
                }
                
                HStack(spacing: 2) {
                    ForEach(Array(textTitle.enumerated()), id: \.offset) { index, letter in
                        Text(String(letter))
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                            .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                            .opacity(textOpacity)
                            .rotationEffect(.degrees(isAnimating ? 0 : getRotation(for: index)))

                            .offset(
                                x: isAnimating ? 0 : getXOffset(for: index),
                                y: isAnimating ? 0 : getYOffset(for: index)
                            )
                    }
                }
            }
            .onAppear {
                if player == nil {
                    if let url = Bundle.main.url(forResource: "weather_splash", withExtension: "mp4") {
                        let avPlayer = AVPlayer(url: url)
                        avPlayer.isMuted = true
                        self.player = avPlayer
                        avPlayer.play()
                    }
                }
                
                withAnimation(.interactiveSpring(response: 1.8, dampingFraction: 0.7, blendDuration: 0)) {
                    textOpacity = 1.0
                    isAnimating = true
                }
                
                viewModel.startSplashTimeout(seconds: 3.0)
            }
        }
    }
    
    private func getXOffset(for index: Int) -> CGFloat {
        guard index < offsets.count else { return CGFloat.random(in: -100...100) }
        return offsets[index].x
    }
    
    private func getYOffset(for index: Int) -> CGFloat {
        guard index < offsets.count else { return CGFloat.random(in: -150...150) }
        return offsets[index].y
    }
    
    private func getRotation(for index: Int) -> Double {
        guard index < offsets.count else { return Double.random(in: -30...30) }
        return offsets[index].angle
    }
}
