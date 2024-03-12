import Foundation
import ComposableArchitecture
import UserDefaultsDependency

@Reducer
struct AppViewFeature{
    @Dependency(\.userDefaults) var userDefaults
    
    @ObservableState
    enum State: Equatable{
        case login(LoginFeature.State)
        case home(HomeFeature.State)
        init () {
            self = .login(LoginFeature.State())
        }
    }
    
    enum Action{
        case login(LoginFeature.Action)
        case home(HomeFeature.Action)
    }
    
    init () {}
    
    var body : some Reducer<State, Action>{
        Reduce{ state, action in
            switch action{
            case .login(.loginResponse(.success)):
                state = .home(HomeFeature.State())
                return .none
            case .login(.loginResponse(.failure)):
                return .none
            case .login(.homeFeature):
                print ("mainViewFeature -->")
                return .none
            case .login:
                return .none
            case .home:
                return .none
            }
        }
        .ifCaseLet(\.home, action: \.home) {
            HomeFeature()
        }
        .ifCaseLet(\.login, action: \.login) {
            LoginFeature()
        }
    }
}
