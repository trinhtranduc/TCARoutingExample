import Foundation
import ComposableArchitecture
import UserDefaultsDependency

@Reducer
struct LoginFeature{
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.userDefaults) var userDefaults

    @ObservableState
    struct State: Equatable{
        var userName: String = ""
        var password: String = ""
    }
    
    enum Action: ViewAction{
        case loginResponse(Result<UserResponse, Error>)
        case homeFeature(PresentationAction<HomeFeature.Action>)
        case view(View)
        
        public enum View: BindableAction{
            case binding(BindingAction<State>)
            case signIn
        }
    }
    
    var body: some ReducerOf<Self>{
        Reduce { state, action in
            switch action{
            case .view(.signIn):
                print (state.userName)
                print (state.password)

                return .run { [state = state] send in
                    await send(.loginResponse(
                        Result{
                            try await self.apiClient.authenticate(.init(userName: "test@gmail.com", password: "12345678"))
                        })
                    )
                }
            case .view(.binding):
                return .none
            case let .loginResponse(.success(user)):
                print (user)
                return .none
            case let .loginResponse(.failure(error)):
                print (error)
                return .none
            case .homeFeature(_):
                return .none
            }
        }
    }
}

