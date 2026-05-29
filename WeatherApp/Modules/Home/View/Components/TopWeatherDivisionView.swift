//
//  TopWeatherDivisionView.swift
//  WeatherApp
//
//  Created by TaqieAllah on 29/05/2026.
//

import SwiftUI

struct TopWeatherDivisionView: View {
    let weather: CurrentWeatherResponse
    let isMorning: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(weather.location.name)
                .font(.system(size: 34, weight: .regular))
            
            Text("\(Int(weather.current.tempC))°")
                .font(.system(size: 96, weight: .thin))
            
            Text(weather.current.condition.text)
                .font(.system(size: 20, weight: .medium))
                .opacity(0.8)
            
            AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
        }
        .foregroundColor(isMorning ? .black : .white)
        .padding(.top, 50)
    }
}
