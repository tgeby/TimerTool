//
//  ContentView.swift
//  TimerTool Watch App
//
//  Created by Thomas Eby on 5/29/25.
//

import SwiftUI
import HealthKit

struct ContentView: View {

    @ObservedObject var viewModel: IntervalViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                NavigationLink(destination: ExerciseSelectorView(viewModel: viewModel)) {
                    Text("Use a timer")
                        .frame(width: 150, height: 60)
                        .background(Color(red: 80/255, green: 200/255, blue: 120/255))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: LibraryView(viewModel: viewModel)) {
                    Text("Manage library")
                        .frame(width: 150, height: 60)
                        .background(Color(red: 80/255, green: 200/255, blue: 120/255))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .frame(maxHeight: .infinity)
            .padding()
        }
        .onAppear() {
            requestHealthKitAccess()
        }
    }
    private func requestHealthKitAccess() {
        let healthStore = HKHealthStore()
        let typesToShare: Set = [HKObjectType.workoutType()]
        let typesToRead: Set = [HKObjectType.workoutType()]
        print("Requesting HealthKit access...")
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if success {
                print("✅ HealthKit authorization granted.")
            } else if let error = error {
                print("❌ HealthKit authorization failed: \(error.localizedDescription)")
            } else {
                print("❌ HealthKit authorization failed.")
            }
            
        }
    }
}

#Preview {
    ContentView(viewModel: IntervalViewModel())
}
