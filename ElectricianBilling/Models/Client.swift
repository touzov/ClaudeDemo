import Foundation
import Contacts

struct Client: Codable, Identifiable {
    let id: String
    let name: String
    let email: String?
    let phone: String?
    let address: String?

    init(id: String = UUID().uuidString, name: String, email: String? = nil, phone: String? = nil, address: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
    }

    init(contact: CNContact) {
        self.id = contact.identifier
        self.name = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
        self.email = contact.emailAddresses.first?.value as String?
        self.phone = contact.phoneNumbers.first?.value.stringValue

        if let postalAddress = contact.postalAddresses.first?.value {
            let formatter = CNPostalAddressFormatter()
            self.address = formatter.string(from: postalAddress)
        } else {
            self.address = nil
        }
    }
}
