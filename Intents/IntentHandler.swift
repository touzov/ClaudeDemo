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

        // Get current location
        LocationManager.shared.requestLocation { location in
            guard let location = location else {
                completion(RecordActivityIntentResponse(code: .failure, userActivity: nil))
                return
            }

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
