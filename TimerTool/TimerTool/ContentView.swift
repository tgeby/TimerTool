//
//  ContentView.swift
//  TimerTool
//
//  Created by Thomas Eby on 5/29/25.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    
    
    @State private var watchActivated = false
    @State private var watchMessage = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world on iPhone!")
            TextField("Enter a message to send to watch: ", text: self.$watchMessage)
            Button(action: {
                WCSessionManager.shared.sendMessageToWatch(["message": watchMessage])
            }, label: {
                Text("Send message")
            })
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
