import Intents
import CoreLocation

class IntentHandler: INExtension {

    override func handler(for intent: INIntent) -> Any {
        if intent is INSendMessageIntent {
            return RecordActivityIntentHandler()
        }
        return self
    }
}

// Handler for recording activities via Siri
class RecordActivityIntentHandler: NSObject, INSendMessageIntentHandling {

    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        guard let content = intent.content, !content.isEmpty else {
            completion(INSendMessageIntentResponse(code: .failure, userActivity: nil))
            return
        }

        // Get current location
        LocationManager.shared.requestLocation { location in
            guard let location = location else {
                completion(INSendMessageIntentResponse(code: .failure, userActivity: nil))
                return
            }

            // Create activity with description from Siri
            let activity = Activity(
                description: content,
                timestamp: Date(),
                location: location,
                duration: 3600, // Default 1 hour, can be adjusted
                hourlyRate: 75.0
            )

            // Save activity
            ActivityManager.shared.addActivity(activity)

            let response = INSendMessageIntentResponse(code: .success, userActivity: nil)
            completion(response)
        }
    }

    func confirm(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        completion(INSendMessageIntentResponse(code: .ready, userActivity: nil))
    }

    func resolveRecipients(for intent: INSendMessageIntent, with completion: @escaping ([INSendMessageRecipientResolutionResult]) -> Void) {
        // Use a dummy recipient for our custom Siri shortcut
        let recipient = INPerson(personHandle: INPersonHandle(value: "WorkActivity", type: .unknown), nameComponents: nil, displayName: "Work Activity", image: nil, contactIdentifier: nil, customIdentifier: "work_activity")
        completion([INSendMessageRecipientResolutionResult.success(with: recipient)])
    }

    func resolveContent(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let content = intent.content, !content.isEmpty {
            completion(INStringResolutionResult.success(with: content))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
}
