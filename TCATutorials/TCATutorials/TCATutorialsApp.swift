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
    var body: some Scene {
        WindowGroup {
            CounterView(store: Store(initialState: CounterFeature.State()) {
                    CounterFeature()
                }
            )
        }
    }
}
