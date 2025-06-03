//
//  WorkoutManager.swift
//  TimerTool Watch App
//
//  Created by Thomas Eby on 6/1/25.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    
    static let shared = WorkoutManager()
    
    private override init() {
        super.init()
    }
    
    private var healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    
    static var isWorkoutActive: Bool {
        get { UserDefaults.standard.bool(forKey: "WorkoutIsActive") }
        set { UserDefaults.standard.set(newValue, forKey: "WorkoutIsActive") }
    }
    
    func startWorkout() {
        if WorkoutManager.isWorkoutActive {
            print("Orphaned workout exists. Creating another workout session.")
        }
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .functionalStrengthTraining
        configuration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
            
            session?.delegate = self
            builder?.delegate = self
            
            builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
            
            session?.startActivity(with: Date())
            builder?.beginCollection(withStart: Date()) { (success, error) in
                // Your timer will run separately in the view
                if let error = error {
                    print("Failed to begin collection: \(error.localizedDescription)")
                } else {
                    print("Workout collection started.")
                    WorkoutManager.isWorkoutActive = true
                }
            }
        } catch {
            print("Failed to start workout session: \(error.localizedDescription)")
        }
    }
    
    func stopWorkout(force: Bool = false) {
        guard WorkoutManager.isWorkoutActive || force else {
            print("No active workout to stop.")
            return
        }
        
        guard let builder = builder else {
            print("No workout builder available.")
            return
        }
        
        print("Attempting to stop workout...")
        
        builder.endCollection(withEnd: Date()) { _, error in
            if let error = error {
                print("Error ending collection: \(error.localizedDescription)")
                return
            }

            if let session = self.session {
                print("Ending workout session...")
                session.end()
            } else {
                print("No session to end.")
            }

            builder.finishWorkout { _, error in
                if let error = error {
                    print("Failed to finish workout: \(error.localizedDescription)")
                } else {
                    print("Workout successfully finished.")
                }

                DispatchQueue.main.async {
                    WorkoutManager.isWorkoutActive = false
                    self.session = nil
                    self.builder = nil
                }
            }
        }
    }
    
    // MARK: - HKWorkoutSessionDelegate & BuilderDelegate (required stubs)
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Workout state changed from \(fromState) to \(toState)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed: \(error.localizedDescription)")
        stopWorkout(force: true)
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {}
}
