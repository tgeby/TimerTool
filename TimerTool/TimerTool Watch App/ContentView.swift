//
//  ContentView.swift
//  TimerTool Watch App
//
//  Created by Thomas Eby on 5/29/25.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 80/255, green: 200/255, blue: 120/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    NavigationLink(destination: ExerciseView()) {
                        Text("Use a timer")
                            .frame(width: 150, height: 60)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: LibraryView()) {
                        Text("Manage library")
                            .frame(width: 150, height: 60)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(maxHeight: .infinity)
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
