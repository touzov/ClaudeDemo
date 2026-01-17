import Foundation
import Intents

// Custom Intent for recording work activities via Siri
class RecordActivityIntent: NSObject, INIntent {
    @NSManaged public var activityDescription: String?
    @NSManaged public var duration: NSNumber?
}

class RecordActivityIntentResponse: INIntentResponse {
    @NSManaged public var code: RecordActivityIntentResponseCode
    @NSManaged public var activityDescription: String?

    init(code: RecordActivityIntentResponseCode, userActivity: NSUserActivity?) {
        self.code = code
        super.init()
    }
}

@objc public enum RecordActivityIntentResponseCode: Int {
    case unspecified = 0
    case ready
    case continueInApp
    case inProgress
    case success
    case failure
    case failureRequiringAppLaunch
}
