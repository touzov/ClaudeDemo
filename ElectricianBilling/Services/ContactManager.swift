import Foundation
import Contacts

class ContactManager {

    static let shared = ContactManager()

    private let contactStore = CNContactStore()

    private init() {}

    func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        contactStore.requestAccess(for: .contacts) { granted, error in
            completion(granted, error)
        }
    }

    func fetchContacts(completion: @escaping ([Client]) -> Void) {
        let keys = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactPostalAddressesKey,
            CNContactIdentifierKey
        ] as [CNKeyDescriptor]

        let request = CNContactFetchRequest(keysToFetch: keys)

        var contacts: [Client] = []

        do {
            try contactStore.enumerateContacts(with: request) { contact, _ in
                let client = Client(contact: contact)
                // Only include contacts with email addresses
                if client.email != nil && !client.email!.isEmpty {
                    contacts.append(client)
                }
            }
            completion(contacts)
        } catch {
            print("Failed to fetch contacts: \(error)")
            completion([])
        }
    }

    func searchContacts(query: String, completion: @escaping ([Client]) -> Void) {
        fetchContacts { clients in
            let filtered = clients.filter { client in
                client.name.localizedCaseInsensitiveContains(query) ||
                (client.email?.localizedCaseInsensitiveContains(query) ?? false)
            }
            completion(filtered)
        }
    }
}
