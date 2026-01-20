import Intents
import CoreLocation

class IntentHandler: INExtension {

    override func handler(for intent: INIntent) -> Any {
        if intent is RecordActivityIntent {
            return RecordActivityIntentHandler()
        }
        return self
    }
}

// Handler for recording activities via Siri
class RecordActivityIntentHandler: NSObject, RecordActivityIntentHandling {

    func handle(intent: RecordActivityIntent, completion: @escaping (RecordActivityIntentResponse) -> Void) {
        guard let description = intent.activityDescription, !description.isEmpty else {
            completion(RecordActivityIntentResponse(code: .failure, userActivity: nil))
            return
        }

        // Use a timeout for location request to avoid hanging
        var hasCompleted = false
        let timeout: TimeInterval = 3.0 // 3 second timeout

        // Set a timeout timer
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            if !hasCompleted {
                hasCompleted = true
                // Use default location if we timeout
                let defaultLocation = CLLocation(latitude: 0.0, longitude: 0.0)
                self.saveActivity(description: description, location: defaultLocation, completion: completion)
            }
        }

        // Try to get current location
        LocationManager.shared.requestLocation { location in
            if !hasCompleted {
                hasCompleted = true
                // Use provided location or default if nil
                let finalLocation = location ?? CLLocation(latitude: 0.0, longitude: 0.0)
                self.saveActivity(description: description, location: finalLocation, completion: completion)
            }
        }
    }

    private func saveActivity(description: String, location: CLLocation, completion: @escaping (RecordActivityIntentResponse) -> Void) {
        // Create activity with description from Siri
        let activity = Activity(
            description: description,
            timestamp: Date(),
            location: location,
            duration: 3600, // Default 1 hour, can be adjusted
            hourlyRate: 75.0
        )

        // Save activity
        ActivityManager.shared.addActivity(activity)

        let response = RecordActivityIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }

    func confirm(intent: RecordActivityIntent, completion: @escaping (RecordActivityIntentResponse) -> Void) {
        completion(RecordActivityIntentResponse(code: .success, userActivity: nil))
    }

    func resolveActivityDescription(for intent: RecordActivityIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let description = intent.activityDescription, !description.isEmpty {
            completion(INStringResolutionResult.success(with: description))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
}
