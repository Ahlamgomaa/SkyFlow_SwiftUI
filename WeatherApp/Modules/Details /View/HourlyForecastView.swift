
import SwiftUI

struct HourlyForecastView: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            VideoBackgroundView(videoName: viewModel.backgroundVideoName)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        if let hours = viewModel.currentWeather?.forecast.forecastday.first?.hour {
                            ForEach(hours, id: \.time) { hour in
                                HourlyRowView(hour: hour)                            }
                        } else {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

