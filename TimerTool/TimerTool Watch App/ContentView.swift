//
//  ContentView.swift
//  TimerTool Watch App
//
//  Created by Thomas Eby on 5/29/25.
//

import SwiftUI
import WatchKit


struct ContentView: View {
    
    @ObservedObject var session = WCSessionManager.shared
        
    func buttonTapped() {
        print("Button pressed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            WKInterfaceDevice.current().play(.notification)
        })
    }
    

    var body: some View {
        ZStack {
            Color.blue
            VStack {
                ScrollView {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world on Apple Watch!")
                    Button(action: {buttonTapped()}) {
                        Text("Click me!")
                    }
                    if session.lastMessage.isEmpty {
                        Text("No message received from iPhone")
                    } else {
                        Text("Message received: \(session.lastMessage)")
                            .font(.system(size: 14)) // or .footnote or any small size
                            .lineLimit(nil) // allow unlimited lines
                            .minimumScaleFactor(0.5) // shrink font if needed
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // give it space to expand
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
