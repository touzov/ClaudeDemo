import UIKit
import MessageUI
import WebKit

class InvoiceViewController: UIViewController {

    var client: Client!
    var activities: [Activity] = []

    private var webView: WKWebView!
    private var formatControl: UISegmentedControl!
    private var sendButton: UIBarButtonItem!

    private let invoiceGenerator = InvoiceGenerator.shared
    private var currentInvoice: Invoice!
    private var businessInfo = BusinessInfo.default

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Invoice Preview"
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupFormatControl()
        setupWebView()

        // Create invoice
        currentInvoice = Invoice(client: client, activities: activities)

        // Load initial preview
        loadHTMLPreview()
    }

    private func setupNavigationBar() {
        sendButton = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendInvoiceTapped))
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsTapped))

        navigationItem.rightBarButtonItems = [sendButton, settingsButton]
    }

    private func setupFormatControl() {
        formatControl = UISegmentedControl(items: ["HTML", "PDF"])
        formatControl.selectedSegmentIndex = 0
        formatControl.addTarget(self, action: #selector(formatChanged), for: .valueChanged)

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        formatControl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(formatControl)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60),

            formatControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            formatControl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            formatControl.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupWebView() {
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadHTMLPreview() {
        let html = invoiceGenerator.generateHTML(for: currentInvoice, businessInfo: businessInfo)
        webView.loadHTMLString(html, baseURL: nil)
    }

    private func loadPDFPreview() {
        guard let pdfData = invoiceGenerator.generatePDF(for: currentInvoice, businessInfo: businessInfo) else {
            showAlert(title: "Error", message: "Failed to generate PDF")
            return
        }

        webView.load(pdfData, mimeType: "application/pdf", characterEncodingName: "", baseURL: URL(fileURLWithPath: ""))
    }

    @objc private func formatChanged() {
        if formatControl.selectedSegmentIndex == 0 {
            loadHTMLPreview()
        } else {
            loadPDFPreview()
        }
    }

    @objc private func settingsTapped() {
        let alert = UIAlertController(title: "Business Information", message: "Update your business details", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Business Name"
            textField.text = self.businessInfo.name
        }

        alert.addTextField { textField in
            textField.placeholder = "Address"
            textField.text = self.businessInfo.address
        }

        alert.addTextField { textField in
            textField.placeholder = "Phone"
            textField.text = self.businessInfo.phone
        }

        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.text = self.businessInfo.email
        }

        alert.addTextField { textField in
            textField.placeholder = "Tax Rate (%)"
            textField.keyboardType = .decimalPad
            textField.text = String(format: "%.1f", self.currentInvoice.taxRate)
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self else { return }

            if let name = alert.textFields?[0].text {
                self.businessInfo.name = name
            }
            if let address = alert.textFields?[1].text {
                self.businessInfo.address = address
            }
            if let phone = alert.textFields?[2].text {
                self.businessInfo.phone = phone
            }
            if let email = alert.textFields?[3].text {
                self.businessInfo.email = email
            }
            if let taxText = alert.textFields?[4].text, let taxRate = Double(taxText) {
                self.currentInvoice = Invoice(
                    client: self.client,
                    activities: self.activities,
                    taxRate: taxRate
                )
            }

            self.formatChanged()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    @objc private func sendInvoiceTapped() {
        let alert = UIAlertController(title: "Send Invoice", message: "Choose format", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Send as HTML", style: .default) { [weak self] _ in
            self?.sendInvoice(format: .html)
        })

        alert.addAction(UIAlertAction(title: "Send as PDF", style: .default) { [weak self] _ in
            self?.sendInvoice(format: .pdf)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sendButton
        }

        present(alert, animated: true, completion: nil)
    }

    private func sendInvoice(format: InvoiceFormat) {
        guard MFMailComposeViewController.canSendMail() else {
            showAlert(title: "Mail Not Available", message: "Please configure your mail account in Settings to send invoices.")
            return
        }

        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self

        if let email = client.email {
            mailComposer.setToRecipients([email])
        }

        mailComposer.setSubject("Invoice \(currentInvoice.invoiceNumber) from \(businessInfo.name)")

        let messageBody = """
        Dear \(client.name),

        Please find attached your invoice \(currentInvoice.invoiceNumber) for the electrical services performed.

        Total Amount: \(currentInvoice.formattedTotal)
        Due Date: \(currentInvoice.formattedDueDate)

        Thank you for your business!

        Best regards,
        \(businessInfo.name)
        """

        mailComposer.setMessageBody(messageBody, isHTML: false)

        switch format {
        case .html:
            let html = invoiceGenerator.generateHTML(for: currentInvoice, businessInfo: businessInfo)
            if let fileURL = invoiceGenerator.saveHTML(html, filename: "Invoice_\(currentInvoice.invoiceNumber)") {
                if let data = try? Data(contentsOf: fileURL) {
                    mailComposer.addAttachmentData(data, mimeType: "text/html", fileName: "Invoice_\(currentInvoice.invoiceNumber).html")
                }
            }

        case .pdf:
            if let pdfData = invoiceGenerator.generatePDF(for: currentInvoice, businessInfo: businessInfo) {
                mailComposer.addAttachmentData(pdfData, mimeType: "application/pdf", fileName: "Invoice_\(currentInvoice.invoiceNumber).pdf")
            }
        }

        present(mailComposer, animated: true, completion: nil)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension InvoiceViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            switch result {
            case .sent:
                self.showAlert(title: "Success", message: "Invoice sent successfully!")
            case .failed:
                self.showAlert(title: "Error", message: "Failed to send invoice: \(error?.localizedDescription ?? "Unknown error")")
            case .cancelled, .saved:
                break
            @unknown default:
                break
            }
        }
    }
}

// MARK: - InvoiceFormat

enum InvoiceFormat {
    case html
    case pdf
}
