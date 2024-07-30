//
//  ContentView.swift
//  TCATutorials
//
//  Created by uunwon on 7/30/24.
//

import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    // 동적 멤버 조회를 통해 Store 에서 직접 상태를 읽을 수 있고,
    // send(_:) 를 통해 Store 에 액션을 보낼 수 있음
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    CounterView(store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
        }
    )
}
