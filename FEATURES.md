# Feature Overview

## Core Features

### 1. Siri Voice Recording ⚡️
Record work activities hands-free while on the job site using natural voice commands.

**Benefits:**
- Work hands-free while performing electrical work
- No need to stop and type on your phone
- Faster documentation
- More detailed descriptions (easier to speak than type)

**How it works:**
1. Say "Hey Siri, send a message to Work Activity saying [your description]"
2. App automatically captures GPS location and timestamp
3. Activity is saved immediately

### 2. GPS Location Tracking 📍
Every activity automatically captures the precise GPS coordinates of the work location.

**Benefits:**
- Verify work locations for client records
- Useful for insurance and liability purposes
- Track service areas and travel patterns
- Professional detail on invoices

**Data captured:**
- Latitude and longitude coordinates
- Displayed on invoices for transparency
- Can be used with mapping services

### 3. Detailed Activity Management 📝
Comprehensive tracking of all billable work activities.

**Features:**
- Description of work performed
- Date and time stamping
- Duration tracking (hours and minutes)
- Customizable hourly rates per activity
- Automatic cost calculation
- Edit or delete activities
- View activity history

### 4. Contact Book Integration 👥
Seamlessly select clients from your iPhone's native Contacts app.

**Benefits:**
- No duplicate data entry
- Always up-to-date client information
- Email addresses auto-populated
- Quick search functionality
- Professional client management

### 5. Professional Invoice Generation 📄
Create beautiful, detailed invoices in multiple formats.

**Invoice Includes:**
- Your business information (customizable)
- Client details
- Invoice number (auto-generated)
- Date and due date
- Detailed line items for each activity:
  - Work description
  - Date and time performed
  - GPS location
  - Duration
  - Hourly rate
  - Line item cost
- Subtotal calculation
- Tax calculation (customizable rate)
- Total amount due
- Optional notes field
- Professional formatting

### 6. Multiple Export Formats 💾
Generate invoices in HTML or PDF format.

**HTML Format:**
- Clean, professional web-ready design
- Easy to embed in emails
- Viewable in any web browser
- Responsive layout
- Print-friendly

**PDF Format:**
- Industry-standard format
- Professional appearance
- Easy to archive
- Universal compatibility
- Includes all invoice details

### 7. Direct Email Sending 📧
Send invoices directly to clients via email from within the app.

**Features:**
- Pre-filled recipient (client's email)
- Professional email template
- Invoice attached automatically
- Choose HTML or PDF attachment
- Customizable email message
- Sent from your configured Mail account

## Technical Features

### Data Persistence
- Local storage using UserDefaults
- No internet required for basic operation
- Activities persist between app launches
- No external server needed

### Privacy & Security
- All data stored locally on device
- Location only captured with permission
- Contacts only accessed with permission
- No data sent to external servers
- You control all information

### User Interface
- Native iOS design
- SwiftUI/UIKit implementation
- Intuitive navigation
- Search functionality
- Pull-to-refresh
- Swipe-to-delete activities

### Permissions
- Location Services (When In Use)
- Contacts access
- Siri integration
- Mail composer access

## Use Cases

### Perfect For:
- Electricians
- Contractors
- Plumbers
- HVAC technicians
- Handyman services
- Any field service professionals

### Typical Workflow:

1. **On Site:**
   - Arrive at job site
   - Use Siri to record: "Installed new GFCI outlet in kitchen"
   - Continue working, record more activities as needed

2. **Between Jobs:**
   - Review activities in the app
   - Adjust durations if needed
   - Add any missed activities manually

3. **End of Day/Week:**
   - Tap "Invoice" button
   - Select client from contacts
   - Review invoice preview
   - Customize business info and tax rate if needed
   - Send via email as HTML or PDF

4. **Client Receives:**
   - Professional invoice via email
   - Can see exactly what work was done, when, and where
   - Clear pricing breakdown
   - Easy to forward to accounting/payment

## Advantages Over Traditional Methods

### vs. Paper Invoices:
- ✅ Faster to create
- ✅ No handwriting errors
- ✅ Automatic calculations
- ✅ GPS verification included
- ✅ Professional appearance
- ✅ Instant delivery
- ✅ No lost paperwork

### vs. Desktop Software:
- ✅ Create invoices on-site
- ✅ No computer needed
- ✅ Immediate documentation
- ✅ Always with you
- ✅ Voice input option
- ✅ GPS integration

### vs. Generic Invoice Apps:
- ✅ Siri integration for hands-free use
- ✅ Designed for field workers
- ✅ GPS location tracking
- ✅ Optimized for electrical/contractor work
- ✅ Simple, focused feature set
- ✅ No subscription required

## Future Feature Ideas

Potential additions for version 2.0:
- Photo attachments for completed work
- Time tracking with start/stop timer
- Expense tracking (materials, mileage)
- Payment status tracking
- Recurring client management
- Multiple tax rates for different jurisdictions
- Custom invoice templates
- Cloud sync across devices
- Client signatures
- Work order management
- Scheduling/calendar integration
- Apple Watch companion app
- Home Screen widgets
- Estimate generation
- Material/parts database

---

**Current Version**: 1.0
**Platform**: iOS 14.0+
**Last Updated**: 2026
