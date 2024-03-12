import Foundation
import DependenciesMacros

@DependencyClient
public struct ApiClient{
    public var apiRequest: @Sendable(ServerRoute.Api.Route) async throws -> (Data, URLResponse)
    public var authenticate: @Sendable(ServerRoute.AuthenticateRequest) async throws -> UserResponse
    public var request: @Sendable(ServerRoute) async throws -> (Data, URLResponse)
    public var baseUrl: @Sendable () -> URL = { URL(string: "/")! }
    public var setBaseUrl: @Sendable (URL) async -> Void
    public var currentUser: @Sendable () -> User?

    public func apiRequest(route: ServerRoute.Api.Route, file: StaticString = #file, line: UInt = #line) async throws -> (Data, URLResponse){
        do {
            let (data, response) = try await self.apiRequest(route)
            #if DEBUG
            Log.log(data: data, response: response as? HTTPURLResponse)
            #endif
            return (data, response)
        } catch{
            throw ApiError(error: error)
        }
    }
    
    public func apiRequest<A: Decodable>(route: ServerRoute.Api.Route, as: A.Type, file: StaticString = #file, line: UInt = #line) async throws -> A{
        let (data, _) = try await self.apiRequest(route: route, file: file, line: line)
        do {
            return try apiDecode(A.self, from: data)
            
        } catch{
            throw ApiError(error: error)
        }
    }
    
    public func request(route: ServerRoute) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await self.request(route)
            #if DEBUG
            Log.log(data: data, response: response as? HTTPURLResponse)
            #endif
            return (data, response)
        } catch{
            throw ApiError(error: error)
        }
    }
}
