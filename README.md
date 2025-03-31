# Nutrak - Nutrition Scanning App

Nutrak is an iOS application that demonstrates iOS development skills including SwiftUI, MVVM architecture, and UI implementation from design specifications.

This project was developed entirely with native Swift to maintain simplicity, minimize potential bugs associated with third-party dependencies, and ensure straightforward compilation and execution. 

This approach provides a more reliable foundation while simplifying the development and maintenance process.

## Implemented Features

### 1. Food Scanning
- Camera integration for capturing food images
- Photo library access for selecting existing food photos
- Real-time scanning simulation with progress indicator
- User guidance for optimal scanning results

### 2. Nutrition Results
- Comprehensive nutritional breakdown including:
  - Calories
  - Macronutrients (Proteins, Carbs, Fats)
  - Micronutrients (Vitamins, Minerals)
- Visual representation of nutritional data with circular charts
- Progress tracking against daily nutrient goals
- Options to save results to daily log or upgrade to premium

### 3. Streak Tracking
- Calendar view showing logged days
- Visual streak counter with flame icon
- Motivational messages based on current streak
- Achievement badges for streak milestones
- Weekly progress visualization

## Technical Implementation

### Architecture
- Built with SwiftUI using MVVM architecture
- Follows Apple's Human Interface Guidelines
- Responsive design for all iPhone screen sizes
- Separation of concerns with dedicated view models and repositories

### Tools & Dependencies
- **Swift 5** and **SwiftUI** - For building the user interface
- **Combine** - For reactive programming and handling asynchronous events
- **PhotosUI** - For photo library integration
- **AVFoundation** - For camera functionality

### Data Management
- Mock data served from local JSON
- Repository pattern for data access
- Simulated network requests with appropriate loading states

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/nutrak-ios.git
   cd nutrak-ios
   ```

2. **Open in Xcode**
   ```bash
   open Nutrak.xcodeproj
   ```

3. **Run the app**
   - Select an iOS simulator or connected device
   - Press ⌘R or click the run button

## Approach & Challenges

### Development Approach
I approached this project with a focus on creating a clean, maintainable, and user-friendly application. The development process included:

1. **Planning**: Analyzed the Figma designs and broke down requirements into manageable tasks
2. **Architecture**: Set up MVVM architecture to ensure separation of concerns
3. **UI Implementation**: Built responsive UI components following the design specifications
4. **Data Integration**: Created repository layer with mock data to simulate real API calls
5. **Animations**: Added transitions and animations for a polished user experience
6. **Testing**: Ensured proper functionality across different devices

### Challenges & Solutions

**Challenge 1: Complex UI Components**  
The circular chart for nutrition data required careful implementation to ensure accurate representation while maintaining visual appeal. I solved this by creating custom drawing logic with SwiftUI paths and utilizing animation modifiers for dynamic updates.

**Challenge 2: State Management**  
Managing the app state across multiple screens required thoughtful design. I implemented a centralized view model approach using Combine framework to maintain a single source of truth for the app data.

**Challenge 3: Camera Integration**  
Handling camera permissions and photo selection required careful attention to the user experience. I implemented a permission alert system and seamless integration with the system photo picker for a native feel.

**Challenge 4: Calendar Grid Layout**  
Creating the streak calendar with proper alignment was challenging. I solved this by implementing a custom grid system with fixed widths and careful spacing calculations.

---
