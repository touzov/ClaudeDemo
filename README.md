# Electrician Billing App with Siri Integration

A comprehensive iOS application designed for electricians to track billable contract work activities using Siri voice commands. The app captures detailed work information including GPS location, time, and detailed descriptions, then generates professional invoices in HTML or PDF format.

## Features

### Core Functionality
- **Siri Integration**: Record work activities hands-free using voice commands while on-site
- **GPS Location Tracking**: Automatically captures the precise location of each work activity
- **Time Stamping**: Records the exact date and time of each activity
- **Activity Management**: View, edit, and manage all recorded work activities
- **Contact Integration**: Select clients directly from your iPhone's address book
- **Invoice Generation**: Create professional invoices in HTML or PDF format
- **Email Invoices**: Send invoices directly to clients via email

### Invoice Features
- Detailed line items for each activity
- GPS coordinates for each work location
- Customizable hourly rates
- Activity duration tracking
- Subtotal, tax, and total calculations
- Professional HTML and PDF formatting
- Customizable business information
- Invoice numbering system
- Due date tracking

## Requirements

- iOS 14.0 or later
- Xcode 12.0 or later
- Swift 5.3 or later
- iPhone with GPS capability
- Location Services enabled
- Contacts access permission
- Siri enabled

## Installation

### Option 1: Open in Xcode

1. Clone this repository:
```bash
git clone https://github.com/yourusername/ElectricianBilling.git
cd ElectricianBilling
```

2. Open the project in Xcode:
   - If you have an Xcode project file (.xcodeproj), double-click it
   - Otherwise, create a new project in Xcode and add all the Swift files

3. Configure your development team:
   - Select the project in the Project Navigator
   - Go to "Signing & Capabilities"
   - Select your development team

4. Add required capabilities:
   - Location Services (When In Use)
   - Contacts
   - Siri

5. Build and run on your iPhone device or simulator

### Option 2: Manual Setup

If you don't have an Xcode project file, create one:

1. Open Xcode and select "Create a new Xcode project"
2. Choose "iOS" > "App" template
3. Set the following:
   - Product Name: ElectricianBilling
   - Team: Your development team
   - Organization Identifier: com.yourcompany
   - Interface: Storyboard
   - Language: Swift
   - Lifecycle: UIKit App Delegate

4. Add all the Swift files from the repository to your project:
   - AppDelegate.swift
   - SceneDelegate.swift
   - Models folder (Activity.swift, Client.swift, Invoice.swift)
   - Services folder (LocationManager.swift, ActivityManager.swift, ContactManager.swift, InvoiceGenerator.swift)
   - ViewControllers folder (ActivitiesViewController.swift, ClientSelectionViewController.swift, InvoiceViewController.swift)
   - Intents folder (IntentHandler.swift, RecordActivityIntent.swift)

5. Replace the default Info.plist with the provided one

6. Add the Intents Extension:
   - File > New > Target
   - Select "Intents Extension"
   - Add the intent files from the Intents folder

## Project Structure

```
ElectricianBilling/
├── AppDelegate.swift              # App lifecycle management
├── SceneDelegate.swift            # Scene lifecycle management
├── Info.plist                     # App configuration and permissions
│
├── Models/
│   ├── Activity.swift             # Work activity data model
│   ├── Client.swift               # Client data model
│   └── Invoice.swift              # Invoice data model
│
├── Services/
│   ├── LocationManager.swift      # GPS location tracking
│   ├── ActivityManager.swift     # Activity data persistence
│   ├── ContactManager.swift      # Address book integration
│   └── InvoiceGenerator.swift    # HTML and PDF generation
│
├── ViewControllers/
│   ├── ActivitiesViewController.swift        # Main activity list
│   ├── ClientSelectionViewController.swift   # Client picker
│   └── InvoiceViewController.swift           # Invoice preview and sending
│
└── Intents/
    ├── IntentHandler.swift         # Siri intent handling
    ├── RecordActivityIntent.swift  # Custom intent definition
    └── Info.plist                  # Extension configuration
```

## Usage

### Recording Activities

#### Method 1: Using Siri (Recommended for on-site work)

1. Enable Siri on your iPhone
2. Say: "Hey Siri, send a message to Work Activity saying [describe your work]"
   - Example: "Hey Siri, send a message to Work Activity saying installed new circuit breaker panel in main electrical room"
3. The app will automatically:
   - Capture your current GPS location
   - Record the current time
   - Save the activity description
   - Set default duration (1 hour, adjustable later)

#### Method 2: Manual Entry

1. Open the app
2. Tap the "+" button in the top right
3. Enter the activity description
4. Enter duration in hours (e.g., 1.5 for 1 hour 30 minutes)
5. Enter your hourly rate
6. Tap "Save"

The app will capture the current GPS location automatically.

### Generating Invoices

1. From the Activities screen, tap the "Invoice" button
2. Select a client from your contacts
   - Use the search bar to find clients quickly
   - Only contacts with email addresses are shown
3. Review the invoice preview
   - Toggle between HTML and PDF formats
   - Tap the gear icon to customize business information and tax rate
4. Tap "Send" to email the invoice
   - Choose HTML or PDF format
   - The email will be pre-filled with the client's email and a professional message
   - Review and send

### Managing Business Information

1. When viewing an invoice preview, tap the gear icon
2. Update your business details:
   - Business Name
   - Address
   - Phone Number
   - Email Address
   - Tax Rate (%)
3. Tap "Save"

This information will appear on all future invoices.

## Permissions

The app requires the following permissions:

### Location Services
**Why**: To record GPS coordinates of work locations for billing accuracy and job site tracking.
**Usage**: Location is captured when recording each activity.

### Contacts
**Why**: To select clients from your address book for invoicing.
**Usage**: Only accessed when you tap "Invoice" to select a client.

### Siri
**Why**: To enable hands-free recording of work activities while on-site.
**Usage**: Processes voice commands to create activity records.

All permissions must be granted for full functionality. The app will prompt you for permissions on first use.

## Siri Shortcuts Setup

To use Siri for recording activities:

1. Open the Shortcuts app on your iPhone
2. Create a new shortcut
3. Add action: "Send Message"
4. Set recipient to "Work Activity"
5. Set message to "Ask for Input" with prompt "Describe your work activity"
6. Save the shortcut
7. Add a Siri phrase like "Record work activity"

Now you can say: "Hey Siri, record work activity" and describe what you did.

## Customization

### Changing Default Hourly Rate

In `Activity.swift`, line 16:
```swift
var hourlyRate: Double = 75.0  // Change to your default rate
```

### Changing Default Duration

In `IntentHandler.swift`, line 29:
```swift
duration: 3600,  // Change to your default (in seconds)
```

### Changing Invoice Number Format

In `Invoice.swift`, `generateInvoiceNumber()` method:
```swift
return "INV-\(dateString)-\(random)"  // Customize format
```

### Changing PDF Page Size

In `InvoiceGenerator.swift`, line 169:
```swift
let pageSize = CGSize(width: 612, height: 792)  // US Letter
// For A4: CGSize(width: 595, height: 842)
```

## Data Storage

- Activities are stored locally using UserDefaults
- Data persists between app launches
- No cloud sync (add CloudKit for multi-device sync)
- No external database required

## Troubleshooting

### Siri Not Working
1. Ensure Siri is enabled: Settings > Siri & Search
2. Check app permissions: Settings > Siri & Search > ElectricianBilling
3. Grant Siri access when the app prompts

### Location Not Captured
1. Check Location Services: Settings > Privacy > Location Services
2. Ensure app has "While Using" permission
3. Try moving to a location with better GPS signal

### Can't Send Email
1. Configure Mail app: Settings > Mail > Accounts
2. Add at least one email account
3. Ensure you have internet connection

### Contacts Not Showing
1. Grant Contacts permission: Settings > Privacy > Contacts
2. Ensure contacts have email addresses
3. Check that contacts are synced to your iPhone

## Future Enhancements

Potential features for future versions:
- CloudKit sync for multi-device support
- Expense tracking (materials, mileage)
- Photo attachments for work completed
- Time tracking with start/stop timer
- Recurring client management
- Payment tracking and reminders
- Custom invoice templates
- Multi-currency support
- Offline mode with sync when online
- Apple Watch companion app
- Widget for quick activity recording

## License

This project is provided as-is for educational and commercial use.

## Support

For issues, questions, or feature requests, please contact:
- Email: support@yourcompany.com
- GitHub Issues: https://github.com/yourusername/ElectricianBilling/issues

## Credits

Developed for electricians and contractors who need a simple, effective way to track billable work and generate professional invoices on the go.

---

**Note**: This app is designed for iPhone devices. iPad support can be added by adjusting the UI layouts for larger screens.
