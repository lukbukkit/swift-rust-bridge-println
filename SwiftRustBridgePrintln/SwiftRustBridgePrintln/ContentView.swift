//
//  ContentView.swift
//  SwiftRustBridgePrintln
//
//  Created by Lukas Arnold on 11.09.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var rustApp: RustAppWrapper
    
    @State var counter = 0
    @State var result: String?
    
    var body: some View {
        ScrollView {
            Image(systemName: "ladybug")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .padding()
            Text("Disconnect your iPhone from your Mac, enable flight mode, and wait for the message \"Lost connection to debugger\" on your Mac.")
                .padding()
            
            Button {
                print("Hello from Swift before Rust invocation")    // Does not cause a crash
                result = rustApp.rust.hello().toString()            // Causes the crash (comment out this line to test)
                print("Hello from Swift after Rust invocation")
                counter += 1
            } label: {
                Text("After 30s, press to crash")
            }
            .padding()
            
            Text("Invocations: \(counter)")
            Text("Last Rust Response")
            Text(result ?? "None")
                .font(.footnote)
                .padding(.horizontal, 5)
        }
    }
}

#Preview {
    ContentView()
}
