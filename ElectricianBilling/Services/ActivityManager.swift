import Foundation
import Combine

class ActivityManager: ObservableObject {

    static let shared = ActivityManager()

    @Published var activities: [Activity] = []

    private let activitiesKey = "saved_activities"

    private init() {
        loadActivities()
    }

    func addActivity(_ activity: Activity) {
        activities.append(activity)
        saveActivities()
    }

    func updateActivity(_ activity: Activity) {
        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
            activities[index] = activity
            saveActivities()
        }
    }

    func deleteActivity(_ activity: Activity) {
        activities.removeAll { $0.id == activity.id }
        saveActivities()
    }

    func deleteActivities(at offsets: IndexSet) {
        activities.remove(atOffsets: offsets)
        saveActivities()
    }

    func clearAllActivities() {
        activities.removeAll()
        saveActivities()
    }

    func getActivities(for dateRange: ClosedRange<Date>? = nil) -> [Activity] {
        guard let dateRange = dateRange else {
            return activities
        }

        return activities.filter { activity in
            dateRange.contains(activity.timestamp)
        }
    }

    // MARK: - Persistence

    private func saveActivities() {
        if let encoded = try? JSONEncoder().encode(activities) {
            UserDefaults.standard.set(encoded, forKey: activitiesKey)
        }
    }

    private func loadActivities() {
        if let data = UserDefaults.standard.data(forKey: activitiesKey),
           let decoded = try? JSONDecoder().decode([Activity].self, from: data) {
            activities = decoded
        }
    }
}
