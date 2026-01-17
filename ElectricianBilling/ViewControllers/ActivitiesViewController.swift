import UIKit
import CoreLocation
import Combine

class ActivitiesViewController: UIViewController {

    private var tableView: UITableView!
    private var addButton: UIBarButtonItem!
    private var generateInvoiceButton: UIBarButtonItem!

    private let activityManager = ActivityManager.shared
    private let locationManager = LocationManager.shared
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Work Activities"
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupTableView()
        setupBindings()

        // Request location permission
        locationManager.requestLocationPermission()
    }

    private func setupNavigationBar() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addActivityTapped))
        generateInvoiceButton = UIBarButtonItem(title: "Invoice", style: .plain, target: self, action: #selector(generateInvoiceTapped))

        navigationItem.rightBarButtonItems = [addButton, generateInvoiceButton]
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: "ActivityCell")
        view.addSubview(tableView)
    }

    private func setupBindings() {
        activityManager.$activities
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    @objc private func addActivityTapped() {
        let alert = UIAlertController(title: "Record Activity", message: "Describe the work you performed", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Activity description"
        }

        alert.addTextField { textField in
            textField.placeholder = "Duration (hours)"
            textField.keyboardType = .decimalPad
        }

        alert.addTextField { textField in
            textField.placeholder = "Hourly rate ($)"
            textField.keyboardType = .decimalPad
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self,
                  let description = alert.textFields?[0].text, !description.isEmpty else {
                return
            }

            let durationText = alert.textFields?[1].text ?? "1.0"
            let rateText = alert.textFields?[2].text ?? "75.0"

            let duration = Double(durationText) ?? 1.0
            let rate = Double(rateText) ?? 75.0

            self.locationManager.requestLocation { location in
                let defaultLocation = CLLocation(latitude: 0, longitude: 0)
                let activity = Activity(
                    description: description,
                    timestamp: Date(),
                    location: location ?? defaultLocation,
                    duration: duration * 3600, // Convert hours to seconds
                    hourlyRate: rate
                )

                DispatchQueue.main.async {
                    self.activityManager.addActivity(activity)
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    @objc private func generateInvoiceTapped() {
        if activityManager.activities.isEmpty {
            showAlert(title: "No Activities", message: "Please add some activities before generating an invoice.")
            return
        }

        let vc = ClientSelectionViewController()
        vc.selectedActivities = activityManager.activities
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityManager.activities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityTableViewCell
        let activity = activityManager.activities[indexPath.row]
        cell.configure(with: activity)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let activity = activityManager.activities[indexPath.row]
        showActivityDetail(activity)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            activityManager.deleteActivities(at: IndexSet(integer: indexPath.row))
        }
    }

    private func showActivityDetail(_ activity: Activity) {
        let message = """
        Description: \(activity.description)
        Time: \(activity.formattedTimestamp)
        Location: \(activity.formattedLocation)
        Duration: \(activity.formattedDuration)
        Rate: $\(activity.hourlyRate)/hr
        Cost: \(activity.formattedCost)
        """

        showAlert(title: "Activity Details", message: message)
    }
}

// MARK: - ActivityTableViewCell

class ActivityTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with activity: Activity) {
        textLabel?.text = activity.description
        textLabel?.numberOfLines = 2

        detailTextLabel?.text = "\(activity.formattedTimestamp) • \(activity.formattedDuration) • \(activity.formattedCost)"
        detailTextLabel?.textColor = .secondaryLabel
        accessoryType = .disclosureIndicator
    }
}
