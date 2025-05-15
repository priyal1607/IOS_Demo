# Thread List iOS Application

This repository contains a single-screen iOS application built using Swift that displays thread data loaded from a local JSON file. The application features a dynamically populated thread list with expandable replies functionality.

## Project Overview

The application displays a thread list UI based on the provided Figma design, with data loaded from a local JSON file. Users can view and interact with threads and their replies through an intuitive interface.

## Features

### Core Feature
- **Thread List UI**: Displays threads according to the Figma design specifications

### Expandable Replies Functionality
- Displays a "View More Replies" button below threads with additional replies
- On tap:
  - Loads 3 replies from the JSON
  - Continues showing "View More Replies" if more replies exist
  - Shows "Hide Replies" once all replies are loaded
- Collapsing functionality to hide replies and return to the initial state

## Technology Stack

- Swift
- UIKit
- JSON parsing
- Git for version control

## Project Structure

```
IosDemo/
├── Controllers/Models            # Data models for JSON mapping
├── Controllers/Views/             # UI components
├── Controllers/        # View controllers
├── helpers/          # Helper classes and extensions
└── Resources/          # JSON files and assets
```

## Setup Instructions

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0+ (device or simulator)
- Git (for cloning the repository)

### Installation

1. Clone the repository:
   ```bash
   git clone (https://github.com/priyal1607/IOS_Demo)
   cd IOS_Demo
   ```

2. Open the project in Xcode:
   ```bash
   open IOS_Demo.xcodeproj
   ```

3. Build and run the application:
   - Select your target device or simulator
   - Press Command+R or click the "Run" button




## Development Process

The application was developed following these steps:
1. Project setup with appropriate folder structure
2. UI implementation based on the Figma design
3. JSON integration for data loading and parsing
4. Implementation of the expandable replies functionality
5. Testing and refinement



## References

- [Figma Design](https://www.figma.com/design/FclILbjCmFNFyaUCvySdRU/Thread-List-Practical-Task?node-id=0-1&p=f&t=2j0fANGAayZHO9vR-0)
- [Thread List JSON File](https://drive.google.com/file/d/1MGiJiKI_9Y_lAQq_YVymZhjUJjfbJIIT/view)



