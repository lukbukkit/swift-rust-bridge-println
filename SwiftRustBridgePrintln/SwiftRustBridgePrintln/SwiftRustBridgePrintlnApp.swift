//
//  SwiftRustBridgePrintlnApp.swift
//  SwiftRustBridgePrintln
//
//  Created by Lukas Arnold on 11.09.24.
//

import SwiftUI

@main
struct SwiftRustBridgePrintlnApp: App {
    @State var rustAppWrapper = RustAppWrapper(rust: RustApp())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(rustAppWrapper)
        }
    }
}

class RustAppWrapper: ObservableObject {
    var rust: RustApp
    
    init(rust: RustApp) {
        self.rust = rust
    }
}
