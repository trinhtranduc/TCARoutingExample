import Foundation
import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store : StoreOf<AppViewFeature>
    
    init(store: StoreOf<AppViewFeature>){
        self.store = store
    }
    
    var body: some View {
        switch self.store.state{
        case .login:
            if let store = self.store.scope(state: \.login, action: \.login){
                NavigationStack{
                    LoginView(store: store )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        case .home:
            if let store = self.store.scope(state: \.home, action: \.home){
                HomeView(store: store)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(.white)
            }
        }
    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppViewFeature.State(), reducer: {
                AppViewFeature()
            }
        )
    )
}
