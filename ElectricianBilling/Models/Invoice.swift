import Foundation

struct Invoice: Codable, Identifiable {
    let id: UUID
    let invoiceNumber: String
    let client: Client
    let activities: [Activity]
    let createdDate: Date
    let dueDate: Date
    var notes: String?
    var taxRate: Double // percentage

    init(id: UUID = UUID(), invoiceNumber: String? = nil, client: Client, activities: [Activity], createdDate: Date = Date(), dueDate: Date? = nil, notes: String? = nil, taxRate: Double = 0.0) {
        self.id = id
        self.invoiceNumber = invoiceNumber ?? Invoice.generateInvoiceNumber()
        self.client = client
        self.activities = activities
        self.createdDate = createdDate
        self.dueDate = dueDate ?? Calendar.current.date(byAdding: .day, value: 30, to: createdDate)!
        self.notes = notes
        self.taxRate = taxRate
    }

    var subtotal: Double {
        return activities.reduce(0) { $0 + $1.cost }
    }

    var taxAmount: Double {
        return subtotal * (taxRate / 100.0)
    }

    var total: Double {
        return subtotal + taxAmount
    }

    var formattedSubtotal: String {
        return String(format: "$%.2f", subtotal)
    }

    var formattedTax: String {
        return String(format: "$%.2f", taxAmount)
    }

    var formattedTotal: String {
        return String(format: "$%.2f", total)
    }

    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdDate)
    }

    var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dueDate)
    }

    static func generateInvoiceNumber() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: Date())
        let random = Int.random(in: 1000...9999)
        return "INV-\(dateString)-\(random)"
    }
}
