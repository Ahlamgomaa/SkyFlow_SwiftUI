//
//  SplashView.swift
//  WeatherApp
//
//  Created by TaqieAllah on 27/05/2026.
//
import SwiftUI
import AVKit

struct SplashView: View {
    @State private var viewModel = SplashViewModel()
    
    private let player: AVPlayer? = {
        guard let url = Bundle.main.url(forResource: "weather_splash", withExtension: "mp4") else {
            return nil
        }
        let avPlayer = AVPlayer(url: url)
        avPlayer.isMuted = true
        return avPlayer
    }()
    
    var body: some View {
        if viewModel.isAnimationFinished {
            ContentView()
        } else {
            ZStack {
                Color.black                     .ignoresSafeArea()
                
                if let player = player {
                    VideoPlayer(player: player)
                        .disabled(true)
                        .ignoresSafeArea()
                        .onAppear {
                            player.play()
                        }
                }
            }
            .onAppear {
                viewModel.startSplashTimeout(seconds: 3.0)
            }
        }
    }
}

