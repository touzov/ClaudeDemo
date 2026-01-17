import Foundation
import CoreLocation

struct Activity: Codable, Identifiable {
    let id: UUID
    let description: String
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    var duration: TimeInterval // in seconds
    var hourlyRate: Double

    init(id: UUID = UUID(), description: String, timestamp: Date = Date(), location: CLLocation, duration: TimeInterval = 0, hourlyRate: Double = 75.0) {
        self.id = id
        self.description = description
        self.timestamp = timestamp
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.duration = duration
        self.hourlyRate = hourlyRate
    }

    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    var formattedLocation: String {
        return String(format: "%.6f, %.6f", latitude, longitude)
    }

    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }

    var cost: Double {
        let hours = duration / 3600.0
        return hours * hourlyRate
    }

    var formattedCost: String {
        return String(format: "$%.2f", cost)
    }

    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
