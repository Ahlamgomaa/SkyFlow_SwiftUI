import SwiftUI

struct NoConnectionView: View {
    let viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "wifi.slash")
                    .font(.footnote)
                Text("NO INTERNET CONNECTION")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(viewModel.isMorning ? .black.opacity(0.9) : .white)

            }
            .foregroundColor(viewModel.isMorning ? .black.opacity(0.9) : .white)
            
            Divider()
                .background(viewModel.isMorning ? .black.opacity(0.9) : .white)
            
            VStack(spacing: 10) {
                Text("You're Offline")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(viewModel.isMorning ? .black.opacity(0.9) : .white)
                
                Text("You can still browse your saved locations from your favorites list.")
                    .font(.system(size: 14))
                    .foregroundColor(viewModel.isMorning ? .black.opacity(0.9) : .white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
            }
            .padding(.vertical, 8)
            
            NavigationLink(destination: FavoritesView(homeViewModel: viewModel)) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("Go to Favorites")
                        .fontWeight(.semibold)
                }
                .font(.system(size: 16))
                .foregroundColor(viewModel.isMorning ? .black.opacity(0.9) : .white)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.15))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
            }
            .buttonStyle(InteractiveScaleButtonStyle())
        }
        .padding(.all, 16)
        .background(Color(red: 0/255, green: 85/255, blue: 160/255).opacity(0.45))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}
