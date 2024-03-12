import Foundation
import ComposableArchitecture

public enum ServerRoute: Equatable{
    case api(Api)
    case authenticate(AuthenticateRequest)

    public struct Api: Equatable{
        public let token: String
        public let route: Route
        
        public init(token: String, route: Route) {
            self.token = token
            self.route = route
        }
        
        @CasePathable
        public enum Route: Equatable, Sendable{
            case history(currentPage: Int, numberPerPage: Int)
            case historyDetail(id: Int)
        }
    }
    
    public struct AuthenticateRequest: Codable, Equatable{
        public let userName: String
        public let password: String

        public init(userName: String, password: String) {
            self.userName = userName
            self.password = password
        }
        
        public init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          self.userName = try container.decode(String.self, forKey: .userName)
          self.password = try container.decode(String.self, forKey: .password)
        }
    }
}



