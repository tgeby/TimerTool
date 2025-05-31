//
//  ContentView.swift
//  TimerTool
//
//  Created by Thomas Eby on 5/29/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
            NavigationView {
                VStack {
                    Text("Options")
                        .fontWeight(.medium)
                        .font(.system(size: 50))
                            .dynamicTypeSize(.medium ... .xxLarge)
                        .padding()
                    NavigationLink(destination: EnterIntervalView()) {
                        Text("Click here to register a sequence of intervals for your watch app.")
                            .padding()
                    }

//                    NavigationLink(destination: TestView()) {
//                        Text("Test view")
//                            .padding()
//                    }
                }
            }
            Spacer().frame(height: 200)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
