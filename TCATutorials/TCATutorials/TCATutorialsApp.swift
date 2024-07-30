//
//  TCATutorialsApp.swift
//  TCATutorials
//
//  Created by uunwon on 7/30/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCATutorialsApp: App {
    // 앱을 구동하는 store 는 한 번만 생성해야 한다는 점을 유의하기
    static let store = Store(initialState: CounterFeature.State()) { 
        CounterFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            CounterView(store: TCATutorialsApp.store)
        }
    }
}
