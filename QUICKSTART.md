# Quick Start Guide

Get up and running with the Electrician Billing App in minutes!

## Step 1: Open in Xcode

1. Download or clone this repository:
   ```bash
   git clone https://github.com/yourusername/ClaudeDemo.git
   cd ClaudeDemo
   ```
2. Open the Xcode project:
   - Double-click `ElectricianBilling.xcodeproj`
   - Or from terminal: `open ElectricianBilling.xcodeproj`
3. Wait for Xcode to index the project

The project is already set up with:
- ✅ All Swift source files
- ✅ Main app target
- ✅ Intents Extension target
- ✅ Info.plist with required permissions
- ✅ Assets catalog and launch screen

## Step 2: Configure Signing

1. Select your project in the navigator
2. Select the "ElectricianBilling" target
3. Go to "Signing & Capabilities"
4. Select your Team (you need an Apple Developer account)
5. Repeat for "Intents" target

## Step 3: Add Capabilities

For the main app target, add these capabilities:
1. Click "+ Capability" button
2. Add "Siri"
3. Location permissions are already in Info.plist
4. Contacts permissions are already in Info.plist

## Step 4: Build and Run

1. Connect your iPhone via USB
2. Select your iPhone as the build target (not Simulator)
3. Click the Play button (or press Cmd+R)
4. Allow permissions when prompted:
   - Location Services
   - Contacts
   - Siri

## Step 5: Set Up Siri (Optional but Recommended)

### Method A: Use Siri Shortcuts (Recommended)
1. Open the Shortcuts app on your iPhone
2. Tap "+" to create a new shortcut
3. Tap "Add Action"
4. Search for "Record Activity" (this is our custom intent)
5. The action will appear as "Record Work Activity"
6. Tap "activityDescription" and select "Ask Each Time"
7. Tap the settings icon (•••) at the top
8. Name it "Record Work" and add a custom Siri phrase
9. Now say: "Hey Siri, Record Work" and describe your activity

### Method B: Add to Siri from Settings
1. Go to Settings > Siri & Search
2. Tap "All Shortcuts"
3. Find "Record Work Activity"
4. Tap "+" to add a custom phrase like "Log work"
5. Now say: "Hey Siri, Log work" followed by your description

## Step 6: Test the App

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
