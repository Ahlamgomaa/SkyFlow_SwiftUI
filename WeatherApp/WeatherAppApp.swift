
import SwiftUI
import SwiftData

@main
struct WeatherAppApp: App {
    @State private var showHome = false
    
   
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteCity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showHome {
                    HomeView()
                        .transition(.opacity)
                } else {
                    SplashView()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showHome = true
                            }
                        }
                        .task {
                            try? await Task.sleep(nanoseconds: 2_000_000_000)
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showHome = true
                            }
                        }
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
