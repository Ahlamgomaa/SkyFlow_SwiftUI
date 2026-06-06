
import Foundation

protocol NetworkClient {
    func fetch<T: Decodable>(url: URL) async throws -> T
}
