import Foundation
import ComposableArchitecture
import Combine
import URLRouting

private let encoder = { () -> JSONEncoder in
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    return encoder
}()

private let decoder = { () -> JSONDecoder in
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
}()

#if DEBUG
private let isDebug = true
#else
private let isDebug = false
#endif

extension DependencyValues {
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}

private let currentUserKey = "trinhtran.currentUserKey"

extension ApiClient: DependencyKey{
    public static var liveValue: ApiClient = Self.live()
    
    public static func live(baseURL: URL = URL(string: "https://example.com")!) -> Self{
        let router = ServerRouter(date: Date.init, decoder: decoder, encoder: encoder)
        
        actor Session{
            nonisolated let baseURL: Isolated<URL>
            nonisolated let currentUser: Isolated<User?>
            
            let router : ServerRouter
            
            init(baseURL: URL, router: ServerRouter) {
                self.baseURL = Isolated(
                    baseURL,
                    didSet: { _, newValue in }
                )
                
                self.currentUser = Isolated(
                    UserDefaults.standard.data(forKey: currentUserKey)
                        .flatMap({ try? decoder.decode(User.self, from: $0) }),
                    didSet: { _, newValue in
                        UserDefaults.standard.set(
                            newValue.flatMap { try? encoder.encode($0) },
                            forKey: currentUserKey
                        )
                    }
                )
                
                self.router = router
                
            }
            
            func apiRequest(route: ServerRoute.Api.Route) async throws -> (Data, URLResponse){
                try await TCARoutingExample.apiRequest(
                    accessToken: self.currentUser.value?.jwt == nil ? nil : "Bearer \(self.currentUser.value!.jwt)",
                    baseURL: baseURL.value,
                    route: route,
                    router: self.router
                )
            }
            
            func authenticate(request: ServerRoute.AuthenticateRequest) async throws -> UserResponse{
                let (data, reponse) = try await TCARoutingExample.request(
                    baseURL: self.baseURL.value,
                    route: ServerRoute.authenticate(
                        .init(
                            userName: request.userName, password: request.password
                        )
                    ) ,
                    router: router
                )
                
                Log.log(data: data, response: reponse as? HTTPURLResponse)
                
                let user = try apiDecode(UserResponse.self, from: data)
                self.currentUser.value = user.user
                
                return user
            }
            
            func request(route: ServerRoute) async throws -> (Data, URLResponse){
                try await TCARoutingExample.request(
                    baseURL: self.baseURL.value,
                    route: route,
                    router: self.router
                )
            }
            
            func setBaseURL(_ url: URL){
                self.baseURL.value = url
            }
            
            fileprivate func setCurrentUser(_ user: User) {
                self.currentUser.value = user
            }
        }
        
        let session = Session(baseURL: baseURL, router: router)
        return Self { route in
            try await session.apiRequest(route: route)
        } authenticate: { authenticateRequest in
            try await session.authenticate(request: authenticateRequest)
        } request: { route in
            try await session.request(route: route)
        } baseUrl: {
            session.baseURL.value
        } setBaseUrl: { url in
            await session.setBaseURL(url)
        } currentUser: {
            session.currentUser.value
        }
    }
}

private func apiRequest(accessToken: String?, baseURL: URL, route: ServerRoute.Api.Route, router: ServerRouter) async throws -> (Data, URLResponse){
    guard let token = accessToken else { throw URLError(.userAuthenticationRequired)}
    
    return try await request(baseURL: baseURL, route:
            .api(.init(token: token, route: route)),
                             router: router)
}

private func request(baseURL: URL, route: ServerRoute, router: ServerRouter) async throws -> (Data, URLResponse){
    guard let request = try? router
        .baseURL(baseURL.absoluteString)
        .request(for: route) else { throw URLError(.badURL)}
    Log.log(request: request)
    
    return try await URLSession.shared.data(for: request)
}

extension URLRequest {
    fileprivate mutating func setHeaders(token: String? = nil) {
        self.setValue(
            "Content-Type", forHTTPHeaderField: "Application-json")
        if let token = token{
            self.setValue(
                "Authentication", forHTTPHeaderField: "Bearer \(token)")
        }
    }
}
