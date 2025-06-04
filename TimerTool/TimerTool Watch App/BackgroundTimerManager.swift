//
//  BackgroundTimerManager.swift
//  TimerTool
//
//  Created by Thomas Eby on 6/3/25.
//
//
//  BackgroundTimerManager.swift
//  TimerTool Watch App
//

import Foundation
import HealthKit
import UserNotifications

class BackgroundTimerManager: NSObject, ObservableObject {
    static let shared = BackgroundTimerManager()
    
    private var healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    
    @Published var isBackgroundModeActive = false
    
    private override init() {
        super.init()
        requestNotificationPermission()
    }
    
    // MARK: - Background Mode Management
    
    func enableBackgroundMode(for activityType: HKWorkoutActivityType = .other) {
        guard !isBackgroundModeActive else { return }
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = activityType
        configuration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
            
            session?.delegate = self
            builder?.delegate = self
            
            // Start minimal workout session for background execution
            session?.startActivity(with: Date())
            builder?.beginCollection(withStart: Date()) { [weak self] success, error in
                DispatchQueue.main.async {
                    if success {
                        self?.isBackgroundModeActive = true
                        print("✅ Background mode enabled")
                    } else {
                        print("❌ Failed to enable background mode: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        } catch {
            print("❌ Failed to create workout session: \(error.localizedDescription)")
        }
    }
    
    func disableBackgroundMode() {
        guard isBackgroundModeActive else { return }
        
        builder?.endCollection(withEnd: Date()) { [weak self] _, error in
            self?.session?.end()
            self?.builder?.finishWorkout { _, _ in
                DispatchQueue.main.async {
                    self?.isBackgroundModeActive = false
                    self?.session = nil
                    self?.builder = nil
                    print("✅ Background mode disabled")
                }
            }
        }
    }
    
    // MARK: - Local Notifications for Additional Reliability
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted")
            } else {
                print("❌ Notification permission denied")
            }
        }
    }
    
    func scheduleIntervalNotifications(for sequence: IntervalSequence, startTime: Date) {
        // Clear existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        var cumulativeTime: TimeInterval = 0
        
        for (index, interval) in sequence.sequence.enumerated() {
            cumulativeTime += TimeInterval(interval.lengthInSeconds)
            
            let content = UNMutableNotificationContent()
            content.title = sequence.name
            content.body = interval.isRest ? "Rest period ended" : "Work period ended"
            content.sound = nil // Silent notification
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: cumulativeTime,
                repeats: false
            )
            
            let request = UNNotificationRequest(
                identifier: "interval_\(index)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func clearScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

// MARK: - HKWorkoutSessionDelegate

extension BackgroundTimerManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Background workout state: \(fromState) -> \(toState)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("❌ Background workout failed: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.isBackgroundModeActive = false
        }
    }
}

// MARK: - HKLiveWorkoutBuilderDelegate

extension BackgroundTimerManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {}
}
