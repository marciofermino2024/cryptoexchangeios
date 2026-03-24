//
//  Untitled.swift
//  CryptoExchangeIOS
//
//  Created by Marcio on 27/02/26.
//

import SwiftUI

@main
struct CryptoExchangeIOSApp: App {
    @StateObject private var appContainer = AppContainer.makeDefault()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appContainer)
        }
    }
}
