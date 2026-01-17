import UIKit

class ClientSelectionViewController: UIViewController {

    private var tableView: UITableView!
    private var searchController: UISearchController!

    var selectedActivities: [Activity] = []
    private var clients: [Client] = []
    private var filteredClients: [Client] = []

    private let contactManager = ContactManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Client"
        view.backgroundColor = .systemBackground

        setupSearchController()
        setupTableView()
        loadContacts()
    }

    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search clients"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ClientCell")
        view.addSubview(tableView)
    }

    private func loadContacts() {
        contactManager.requestAccess { [weak self] granted, error in
            guard let self = self else { return }

            if granted {
                self.contactManager.fetchContacts { clients in
                    DispatchQueue.main.async {
                        self.clients = clients.sorted { $0.name < $1.name }
                        self.filteredClients = self.clients
                        self.tableView.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Contact Access Required", message: "Please grant access to contacts in Settings to select clients.")
                }
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func proceedToInvoice(with client: Client) {
        let vc = InvoiceViewController()
        vc.client = client
        vc.activities = selectedActivities
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ClientSelectionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredClients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath)
        let client = filteredClients[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text = client.name
        config.secondaryText = client.email
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let client = filteredClients[indexPath.row]
        proceedToInvoice(with: client)
    }
}

// MARK: - UISearchResultsUpdating

extension ClientSelectionViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredClients = clients
            tableView.reloadData()
            return
        }

        filteredClients = clients.filter { client in
            client.name.localizedCaseInsensitiveContains(searchText) ||
            (client.email?.localizedCaseInsensitiveContains(searchText) ?? false)
        }

        tableView.reloadData()
    }
}
