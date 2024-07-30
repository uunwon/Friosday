//
//  CounterFeature.swift
//  TCATutorials
//
//  Created by uunwon on 7/30/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        var count = 0
        var fact: String?
        var isLoading = false
    }
    
    enum Action {
        case decrementButtonTapped
        case factButtonTapped
        case incrementButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                
                let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(state.count)")!)
                
                state.fact = String(decoding: data, as: UTF8.self)
                state.isLoading = false
                
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            }
        }
    }
}


