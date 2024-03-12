import Foundation
import ComposableArchitecture

@Reducer
struct HomeFeature{
    @Dependency(\.apiClient) var apiClient
    
    @ObservableState
    struct State: Equatable{

    }
    
    enum Action{
        case dataResponse(Result<ScanItemResponse, Error>)
        case loadData
    }
    
    var body: some ReducerOf<Self>{
        Reduce { state, action in
            switch action{
            case .loadData:
                return .run { send in
                    await send(.dataResponse(
                        Result{
                            try await self.apiClient.apiRequest(route: .history(currentPage: 0, numberPerPage: 20), as: ScanItemResponse.self)
                        }
                    ))
                }
            case let .dataResponse(.success(item)):
                print (item)
                return .none
            case let .dataResponse(.failure(error)):
                print (error)
                return .none
            }
        }
    }
}

