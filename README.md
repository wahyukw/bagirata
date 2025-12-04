# Bagirata - Bill Splitting App

<p align="center">
  <strong>A modern iOS bill-splitting application built with SwiftUI and Test-Driven Development</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" alt="iOS 17.0+">
  <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift 5.9">
  <img src="https://img.shields.io/badge/SwiftUI-5.0-green.svg" alt="SwiftUI 5.0">
  <img src="https://img.shields.io/badge/Tests-39%20passing-brightgreen.svg" alt="Tests">
  <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="License">
</p>

---

## 📖 Overview

Bagirata is a comprehensive bill-splitting iOS application that helps friends and groups accurately split restaurant bills, groceries, or any shared expenses. Built with modern iOS development practices including **Test-Driven Development (TDD)**, **MVVM architecture**, and **SwiftUI**.

### ✨ Key Highlights

- 🧪 **39 unit tests**
- 🏗️ **MVVM architecture** with clean separation of concerns
- 🎯 **Protocol-oriented design** for testability and flexibility
- 📱 **SwiftUI** for modern, declarative UI
- 🔄 **@Observable** for efficient state management
- 💾 **Persistent state** across navigation flow

---

## 🎬 Demo

<div>

### Watch the Full Demo

https://github.com/wahyukw/bagirata/blob/main/MVP.mov

*Complete walkthrough showcasing all features: bill creation, guest management, item assignment, and smart calculations*

</div>

---

## ✅ Features

### Current Implementation

#### 💰 Bill Creation Flow
- **Add Items**: Manually enter bill items with names and prices
- **Auto-calculated Tax**: Automatic 11% tax calculation based on subtotal
- **Optional Tip**: Add custom tip amount (defaults to $0)
- **Bill Naming**: Optional bill name for easy identification

#### 👥 Guest Management
- **Add Multiple Guests**: Add everyone splitting the bill
- **Avatar Assignment**: Random avatar generation for visual identification
- **Duplicate Prevention**: Case-insensitive duplicate name detection
- **Name Validation**: Automatic whitespace trimming and validation

#### 📋 Item Assignment
- **Interactive Checkboxes**: Tap to assign guests to items
- **Split Items**: Support for items shared by multiple people
- **Visual Feedback**: Red border indicators for unassigned items
- **Split Counter**: Shows "Split X ways" for shared items
- **Real-time Validation**: Cannot proceed until all items assigned

#### 💵 Smart Calculations
- **Proportional Tax**: Tax distributed based on each person's subtotal
- **Equal Tip Split**: Tip split equally among active guests only
- **Inactive Guest Handling**: Guests who are added but not assigned will not show in summary
- **Accurate Splitting**: Handles complex scenarios with split items

#### 📊 Results Summary
- **Detailed Breakdown**: Shows subtotal, tax, tip, and total per person
- **Item Listing**: Displays what each person ordered (with split indicators)
- **Share Functionality**: Export summary via iOS share sheet
- **Bill History**: View past bills from home screen

#### 🔄 Navigation & State
- **Persistent State**: Data preserved when navigating back/forward
- **@Environment Integration**: Shared state across navigation flow
- **Clean Navigation**: String-based navigation with proper state management

---

## 🏗️ Architecture

### MVVM Pattern
```
┌─────────────────────────────────────────┐
│              VIEW (SwiftUI)             │
│  - Displays data                        │
│  - Handles user interactions            │
│  - Minimal logic                        │
└────────────────┬────────────────────────┘
                 │ Binds to (@Observable)
┌────────────────▼────────────────────────┐
│           VIEWMODEL                     │
│  - Presentation logic                   │
│  - State management                     │
│  - Calls services                       │
│  - Validates user input                 │
└────────────────┬────────────────────────┘
                 │ Uses
┌────────────────▼────────────────────────┐
│        MODEL + SERVICES                 │
│  - Data structures                      │
│  - Business logic                       │
│  - Calculation engine                   │
└─────────────────────────────────────────┘
```

### Project Structure
```
Bagirata/
├── Models/
│   ├── Bill.swift
│   ├── BillItem.swift
│   ├── Guest.swift
│   └── GuestShare.swift
├── ViewModels/
│   ├── CreateBillViewModel.swift
│   ├── GuestViewModel.swift
│   ├── AssignItemsViewModel.swift
│   ├── ResultsViewModel.swift
│   └── BillState.swift
├── Views/
│   ├── HomeView.swift
│   ├── BillCardView.swift
│   ├── CreateBillView.swift
│   ├── AddItemsView.swift
│   ├── AddGuestsView.swift
│   ├── AssignItemsView.swift
│   ├── ResultsView.swift
│   ├── ItemAssignmentCard.swift
│   ├── GuestCheckboxRowView.swift
│   ├── GuestShareCard.swift
│   └── BreakdownRow.swift
├── Services/
│   ├── BillCalculator.swift
│   └── BillCalculationError.swift
└── Tests/
    ├── BillCalculatorTests.swift
    ├── CreateBillViewModelTests.swift
    ├── GuestViewModelTests.swift
    ├── AssignItemsViewModelTests.swift
    └── ResultsViewModelTests.swift
```

---

## 🧪 Testing Strategy

### Test-Driven Development (TDD)

This project follows the **Red-Green-Refactor** cycle:
```
🔴 RED: Write a failing test
   ↓
🟢 GREEN: Write minimal code to pass
   ↓
🔵 REFACTOR: Improve the code
   ↓
   REPEAT
```

### What We Test

- ✅ **Validation Logic**: Empty names, duplicate guests, unassigned items
- ✅ **State Changes**: Adding/removing items and guests
- ✅ **Business Logic**: Tax calculation, tip splitting, proportional distribution
- ✅ **Edge Cases**: Guests who don't order, split items, zero amounts
- ✅ **Error Handling**: Missing data, invalid states

### Running Tests
```bash
# Run all tests
cmd + U in Xcode

# Or via command line
xcodebuild test -scheme Bagirata -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## 🎯 Key Technical Implementations

### 1. Smart Tax Distribution

Tax is distributed **proportionally** based on what each person ordered:
```swift
// If Alice ordered 60% of the bill, she pays 60% of the tax
let guestTax = bill.taxAmount * (guestSubtotal / bill.subtotal)
```

### 2. Equal Tip Splitting

Tip is split **equally** only among active guests (those who ordered):
```swift
let activeGuestCount = bill.activeGuests.count
let guestTip = bill.tipAmount / Double(activeGuestCount)
```

### 3. Split Item Handling

Items can be assigned to multiple guests:
```swift
// Pizza split between 3 people
let shareCount = item.assignedTo.count  // 3
let perPersonCost = item.price / Double(shareCount)  // $20 / 3 = $6.67
```

### 4. State Persistence

Using `@Environment` and `@Observable` for shared state:
```swift
@Observable
class BillState {
    var bill: Bill
}

// Shared across all views in the create-bill flow
.environment(billState)
```

### 5. Protocol-Oriented Design

Enables easy mocking and testing:
```swift
protocol BillCalculatorProtocol {
    func calculateSplit(for bill: Bill) throws -> [GuestShare]
}

// Real implementation
class BillCalculator: BillCalculatorProtocol { }

// Mock for tests
class MockBillCalculator: BillCalculatorProtocol { }
```

---

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/bagirata.git
```

2. Open in Xcode:
```bash
cd bagirata
open Bagirata.xcodeproj
```

3. Build and run:
```bash
cmd + R
```

### Quick Start

1. Tap the **+** button to create a new bill
2. Add items with names and prices
3. Add guests who will split the bill
4. Assign items to guests (tap checkboxes)
5. Tap **Calculate Split** to see results
6. Share the summary with everyone!

---

## 🔮 Upcoming Features

### Phase 2: Data Persistence
- [ ] SwiftData integration for bill history
- [ ] Save and load past bills
- [ ] Edit existing bills
- [ ] Delete bills

### Phase 3: Authentication
- [ ] Sign in with Apple
- [ ] Google Sign-In integration
- [ ] User account management
- [ ] Cloud sync

### Phase 4: Receipt Scanning
- [ ] Camera integration with VisionKit
- [ ] OCR text extraction with Vision framework
- [ ] Smart parsing of receipt text
- [ ] Manual adjustment after scan

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **SwiftUI** | Modern, declarative UI framework |
| **@Observable** | Efficient state management (iOS 17+) |
| **XCTest** | Unit testing framework |
| **MVVM** | Architecture pattern |
| **Protocol-Oriented** | Testability and flexibility |
| **SwiftData** | (Planned) Modern persistence |
| **Vision/VisionKit** | (Planned) OCR for receipt scanning |
| **AuthenticationServices** | (Planned) Sign in with Apple |

---

## 📚 Learning Outcomes

This project demonstrates:

- ✅ **Test-Driven Development** - Write tests before code
- ✅ **MVVM Architecture** - Clean separation of concerns
- ✅ **Protocol-Oriented Programming** - Abstractions for testing
- ✅ **Modern Swift** - @Observable, async/await, generics
- ✅ **SwiftUI** - Declarative UI, navigation, state management
- ✅ **Complex Business Logic** - Proportional calculations, validation
- ✅ **Error Handling** - Custom errors with user-friendly messages
- ✅ **Git Best Practices** - Feature branches, meaningful commits

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Your Name**
- GitHub: [@wahyukw](https://github.com/wahyukw)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/wahyukwan)
- Email: wahyukwan@gmail.com

---

## 🙏 Acknowledgments

- Inspired by real-world bill-splitting needs.
- Built using the latest Swift and SwiftUI technologies.
- Thanks to the SwiftUI and iOS developer community for resources and tutorials.
 
---

<p align="center">
  Made with ❤️ and SwiftUI
</p>

---

# **GitHub Topics (Tags)**
```
ios
swift
swiftui
mvvm
tdd
test-driven-development
xcode
unit-testing
bill-splitter
expense-tracker
observable
protocol-oriented
ios-app
swift-package
mobile-development
