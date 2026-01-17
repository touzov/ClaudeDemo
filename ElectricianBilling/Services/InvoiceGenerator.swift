import Foundation
import UIKit
import PDFKit

class InvoiceGenerator {

    static let shared = InvoiceGenerator()

    private init() {}

    // MARK: - HTML Generation

    func generateHTML(for invoice: Invoice, businessInfo: BusinessInfo) -> String {
        let html = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Invoice \(invoice.invoiceNumber)</title>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
                    line-height: 1.6;
                    color: #333;
                    max-width: 800px;
                    margin: 0 auto;
                    padding: 20px;
                    background-color: #f5f5f5;
                }
                .invoice-container {
                    background-color: white;
                    padding: 40px;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                }
                .header {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 40px;
                    border-bottom: 3px solid #007AFF;
                    padding-bottom: 20px;
                }
                .company-info h1 {
                    margin: 0 0 10px 0;
                    color: #007AFF;
                    font-size: 28px;
                }
                .company-info p {
                    margin: 5px 0;
                    color: #666;
                }
                .invoice-info {
                    text-align: right;
                }
                .invoice-info h2 {
                    margin: 0 0 10px 0;
                    font-size: 24px;
                }
                .invoice-info p {
                    margin: 5px 0;
                }
                .client-info {
                    margin-bottom: 30px;
                    background-color: #f8f9fa;
                    padding: 20px;
                    border-radius: 6px;
                }
                .client-info h3 {
                    margin: 0 0 10px 0;
                    color: #007AFF;
                }
                .activities-table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-bottom: 30px;
                }
                .activities-table th {
                    background-color: #007AFF;
                    color: white;
                    padding: 12px;
                    text-align: left;
                    font-weight: 600;
                }
                .activities-table td {
                    padding: 12px;
                    border-bottom: 1px solid #ddd;
                }
                .activities-table tr:hover {
                    background-color: #f8f9fa;
                }
                .location {
                    font-size: 12px;
                    color: #666;
                }
                .totals {
                    float: right;
                    width: 300px;
                    margin-top: 20px;
                }
                .totals table {
                    width: 100%;
                    border-collapse: collapse;
                }
                .totals td {
                    padding: 10px;
                    text-align: right;
                }
                .totals .label {
                    text-align: left;
                    font-weight: 600;
                }
                .totals .total-row {
                    border-top: 2px solid #007AFF;
                    font-size: 18px;
                    font-weight: bold;
                    color: #007AFF;
                }
                .notes {
                    clear: both;
                    margin-top: 40px;
                    padding-top: 20px;
                    border-top: 1px solid #ddd;
                }
                .footer {
                    margin-top: 40px;
                    text-align: center;
                    color: #666;
                    font-size: 14px;
                }
            </style>
        </head>
        <body>
            <div class="invoice-container">
                <div class="header">
                    <div class="company-info">
                        <h1>\(businessInfo.name)</h1>
                        <p>\(businessInfo.address)</p>
                        <p>Phone: \(businessInfo.phone)</p>
                        <p>Email: \(businessInfo.email)</p>
                    </div>
                    <div class="invoice-info">
                        <h2>INVOICE</h2>
                        <p><strong>Invoice #:</strong> \(invoice.invoiceNumber)</p>
                        <p><strong>Date:</strong> \(invoice.formattedCreatedDate)</p>
                        <p><strong>Due Date:</strong> \(invoice.formattedDueDate)</p>
                    </div>
                </div>

                <div class="client-info">
                    <h3>Bill To:</h3>
                    <p><strong>\(invoice.client.name)</strong></p>
                    \(invoice.client.email.map { "<p>\($0)</p>" } ?? "")
                    \(invoice.client.phone.map { "<p>\($0)</p>" } ?? "")
                    \(invoice.client.address.map { "<p>\($0)</p>" } ?? "")
                </div>

                <table class="activities-table">
                    <thead>
                        <tr>
                            <th>Description</th>
                            <th>Date/Time</th>
                            <th>Duration</th>
                            <th>Rate</th>
                            <th>Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        \(generateActivityRows(invoice.activities))
                    </tbody>
                </table>

                <div class="totals">
                    <table>
                        <tr>
                            <td class="label">Subtotal:</td>
                            <td>\(invoice.formattedSubtotal)</td>
                        </tr>
                        \(invoice.taxRate > 0 ? """
                        <tr>
                            <td class="label">Tax (\(String(format: "%.1f", invoice.taxRate))%):</td>
                            <td>\(invoice.formattedTax)</td>
                        </tr>
                        """ : "")
                        <tr class="total-row">
                            <td class="label">Total:</td>
                            <td>\(invoice.formattedTotal)</td>
                        </tr>
                    </table>
                </div>

                \(invoice.notes.map { notes in
                    """
                    <div class="notes">
                        <h3>Notes:</h3>
                        <p>\(notes)</p>
                    </div>
                    """
                } ?? "")

                <div class="footer">
                    <p>Thank you for your business!</p>
                    <p>Payment is due by \(invoice.formattedDueDate)</p>
                </div>
            </div>
        </body>
        </html>
        """

        return html
    }

    private func generateActivityRows(_ activities: [Activity]) -> String {
        return activities.map { activity in
            """
            <tr>
                <td>
                    <strong>\(activity.description)</strong><br>
                    <span class="location">📍 Location: \(activity.formattedLocation)</span>
                </td>
                <td>\(activity.formattedTimestamp)</td>
                <td>\(activity.formattedDuration)</td>
                <td>$\(String(format: "%.2f", activity.hourlyRate))/hr</td>
                <td>\(activity.formattedCost)</td>
            </tr>
            """
        }.joined(separator: "\n")
    }

    // MARK: - PDF Generation

    func generatePDF(for invoice: Invoice, businessInfo: BusinessInfo) -> Data? {
        let html = generateHTML(for: invoice, businessInfo: businessInfo)

        let printFormatter = UIMarkupTextPrintFormatter(markupText: html)

        let printPageRenderer = UIPrintPageRenderer()
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)

        // Set page size (US Letter)
        let pageSize = CGSize(width: 612, height: 792) // 8.5" x 11" at 72 DPI
        let pageMargins = UIEdgeInsets(top: 36, left: 36, bottom: 36, right: 36)

        let printableRect = CGRect(
            x: pageMargins.left,
            y: pageMargins.top,
            width: pageSize.width - pageMargins.left - pageMargins.right,
            height: pageSize.height - pageMargins.top - pageMargins.bottom
        )

        let paperRect = CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height)

        printPageRenderer.setValue(NSValue(cgRect: paperRect), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: printableRect), forKey: "printableRect")

        let pdfData = NSMutableData()

        UIGraphicsBeginPDFContextToData(pdfData, paperRect, nil)

        for pageIndex in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: pageIndex, in: UIGraphicsGetPDFContextBounds())
        }

        UIGraphicsEndPDFContext()

        return pdfData as Data
    }

    // MARK: - Save to Files

    func saveHTML(_ html: String, filename: String) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(filename).appendingPathExtension("html")

        do {
            try html.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error saving HTML: \(error)")
            return nil
        }
    }

    func savePDF(_ data: Data, filename: String) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(filename).appendingPathExtension("pdf")

        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving PDF: \(error)")
            return nil
        }
    }
}

// MARK: - BusinessInfo

struct BusinessInfo: Codable {
    var name: String
    var address: String
    var phone: String
    var email: String

    static var `default`: BusinessInfo {
        return BusinessInfo(
            name: "Your Electrical Services",
            address: "123 Main Street, City, ST 12345",
            phone: "(555) 123-4567",
            email: "contact@yourelectrical.com"
        )
    }
}
