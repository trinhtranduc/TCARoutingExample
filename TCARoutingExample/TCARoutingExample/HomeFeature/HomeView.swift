import Foundation
import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    @Perception.Bindable var store: StoreOf<HomeFeature>

    init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    var body: some View {
        VStack{
        }
        .onAppear{
            store.send(.loadData)
        }
    }
}

#Preview {
    HomeView(store: Store(initialState: HomeFeature.State(), reducer: {
        HomeFeature()
    }))
}
