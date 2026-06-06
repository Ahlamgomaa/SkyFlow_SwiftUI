
import Foundation

final class NetworkClientImp: NetworkClient {
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        let memoryCapacity = 20 * 1024 * 1024
        let diskCapacity = 100 * 1024 * 1024  
        
        configuration.urlCache = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity,
            diskPath: "weatherCache"
        )
        
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: configuration)
    }
    
    func fetch<T: Decodable>(url: URL) async throws -> T {
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
