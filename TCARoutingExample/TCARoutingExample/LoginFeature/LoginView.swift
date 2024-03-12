import SwiftUI
import ComposableArchitecture

@ViewAction(for: LoginFeature.self)
struct LoginView: View {
    @Perception.Bindable var store: StoreOf<LoginFeature>

    init(store: StoreOf<LoginFeature>) {
        self.store = store
    }
    
    var body: some View {
        VStack{
            TextField("Email", text: $store.userName)
                .frame(height: 40)
            
            TextField("Password", text: $store.password)
                .frame(height: 40)
            
            Button("Login") {
                send(.signIn)
            }
            .frame(height: 40)
        }
    }
}

#Preview {
    LoginView(store: Store(initialState: LoginFeature.State(), reducer: {
        LoginFeature()
    }))
}
