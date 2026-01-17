# Quick Start Guide

Get up and running with the Electrician Billing App in minutes!

## Step 1: Open in Xcode

1. Download or clone this repository
2. Open Xcode (version 12.0 or later)
3. Create a new iOS App project:
   - File > New > Project
   - Select "iOS" > "App"
   - Product Name: **ElectricianBilling**
   - Interface: **Storyboard**
   - Language: **Swift**
   - Lifecycle: **UIKit App Delegate**

## Step 2: Add the Source Files

1. Delete the default `ViewController.swift` file
2. Drag and drop all folders from this repository into your Xcode project:
   - `ElectricianBilling/` folder (contains all .swift files)
3. When prompted, check "Copy items if needed"
4. Replace the default `Info.plist` with the one from this repository

## Step 3: Add Intents Extension

1. In Xcode: File > New > Target
2. Select "Intents Extension"
3. Product Name: **ElectricianBillingIntents**
4. Click Finish
5. Replace the default IntentHandler.swift with the one from `ElectricianBilling/Intents/`
6. Add the other files from the Intents folder

## Step 4: Configure Signing

1. Select your project in the navigator
2. Select the "ElectricianBilling" target
3. Go to "Signing & Capabilities"
4. Select your Team (you need an Apple Developer account)
5. Repeat for "ElectricianBillingIntents" target

## Step 5: Add Capabilities

For the main app target, add these capabilities:
1. Click "+ Capability" button
2. Add "Siri"
3. Location permissions are already in Info.plist
4. Contacts permissions are already in Info.plist

## Step 6: Build and Run

1. Connect your iPhone via USB
2. Select your iPhone as the build target (not Simulator)
3. Click the Play button (or press Cmd+R)
4. Allow permissions when prompted:
   - Location Services
   - Contacts
   - Siri

## Step 7: Set Up Siri (Optional but Recommended)

### Method A: Use the INSendMessageIntent
1. Open the app
2. Say: "Hey Siri, send a message to Work Activity saying installed electrical panel"
3. Siri will save it as an activity!

### Method B: Create a Siri Shortcut
1. Open Shortcuts app on iPhone
2. Tap "+" to create new shortcut
3. Add "Send Message" action
4. Set recipient to "Work Activity"
5. Set message to "Ask for Input" (so Siri asks you to describe the work)
6. Save as "Record Work"
7. Now say: "Hey Siri, Record Work"

## Step 8: Test the App

1. **Add an Activity**:
   - Tap the "+" button
   - Enter: "Replaced faulty circuit breaker"
   - Duration: 1.5 (hours)
   - Rate: 75 ($/hour)
   - Tap Save

2. **Create an Invoice**:
   - Tap "Invoice" button
   - Select a contact (or add a test contact first)
   - Review the preview
   - Toggle between HTML and PDF

3. **Send an Invoice**:
   - Tap "Send"
   - Choose format
   - Send email (make sure Mail app is configured)

## Troubleshooting

**"No Provisioning Profiles Found"**
- You need an Apple Developer account ($99/year)
- Or use "Personal Team" for free (limited to 7 days per install)

**"App won't install on iPhone"**
- Make sure your iPhone is unlocked
- Trust your developer certificate: Settings > General > Device Management

**"Siri isn't working"**
- Enable Siri: Settings > Siri & Search
- Grant permission: Settings > Siri & Search > ElectricianBilling

**"Location not working on Simulator"**
- Simulator location: Features > Location > Custom Location
- Or test on a real device for accurate GPS

## Next Steps

1. Customize business information (tap gear icon in invoice preview)
2. Adjust default hourly rate in code (see README.md)
3. Add your contacts with email addresses
4. Start recording real work activities!

## Need Help?

Check the full README.md for detailed documentation, customization options, and troubleshooting.

Happy billing! ⚡️
