import SwiftUI
import ComposableArchitecture

@main
struct TCARoutingExampleApp: App {
    let store = Store(initialState: AppViewFeature.State()) {
        AppViewFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}
