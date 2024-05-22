
# Sleep Tight

## Introduction
"Sleep Tight" is an interactive iOS application developed using SwiftUI that helps users predict the optimal bedtime based on their wake-up time, desired sleep duration, and coffee consumption. This application leverages CoreML to provide accurate predictions and ensures a smooth user experience with a modern, elegant UI.

## Features

- **Interactive Interface**: Users can set their desired wake-up time, sleep duration, and coffee consumption through an intuitive interface.
- **CoreML Integration**: Uses a machine learning model to predict the ideal bedtime based on user inputs.
- **Dynamic Feedback**: Provides immediate feedback to the user with an alert showing the predicted bedtime.
- **Modern UI Design**: Built with SwiftUI, featuring a clean and contemporary user interface.

## Prerequisites

- Xcode 15.2 or later
- iOS 17.2 or later
- Swift 5 or later

## Installation

Follow these steps to set up "Sleep Tight" on your system:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/gangamamulya/Sleep Tight
   cd Sleep Tight
   ```

2. **Open the Project in Xcode**:
   ```bash
   open Sleep Tight.xcodeproj
   ```

3. **Select Your Target Device**:
   Choose your preferred device or simulator in Xcode.

4. **Build and Run**:
   Press `Cmd + R` to build and run the application.

## CoreML Setup and Training

### Step 1: Open Create ML
1. Open Xcode.
2. Click on **Xcode** > **Open Developer Tool** > **Create ML**.

### Step 2: Create a New Project
1. Click **New Document**.
2. Select **Tabular Regression** and click **Next**.
3. Enter the project name as **SleepWell**, choose a location to save the project, and click **Create**.

### Step 3: Add Training Data
1. Under the **Data** section, click **Select...** next to **Training Data**.
2. Choose the `BetterRest.csv` file provided with the project.

### Step 4: Configure the Model
1. Set the **Target** to `actualSleep`.
2. Click **Choose Features** and select `wake`, `estimatedSleep`, and `coffee`.
3. Under the **Algorithm** dropdown, select **Automatic**.

### Step 5: Train the Model
1. Click the **Train** button in the window title bar.
2. Once training is complete, go to the **Evaluation** tab and check the **Root Mean Squared Error** value.
3. Go to the **Output** tab and click **Get** to export the trained model to your desktop.

### Step 6: Add the Model to Xcode
1. Drag and drop the exported model (`SleepCalculator.mlmodel`) into your Xcode project.
2. Ensure the **Copy items if needed** option is checked.

## How It Works

### 1. Setting Wake-Up Time
Users select their desired wake-up time using a `DatePicker`. This input is used to calculate the optimal bedtime.

```swift
@State private var wakeUp = defaultWakeTime
static var defaultWakeTime: Date {
    var components = DateComponents()
    components.hour = 7
    components.minute = 0
    return Calendar.current.date(from: components) ?? .now
}
```

### 2. Desired Sleep Amount
Users can specify the amount of sleep they want using a `Stepper`.

```swift
@State private var sleepAmount = 8.0
```

### 3. Coffee Consumption
Users input the number of cups of coffee they consumed using another `Stepper`.

```swift
@State private var coffeeAmount = 1
```

### 4. Prediction and Alert
When the user clicks the "Calculate" button, the application uses the CoreML model to predict the optimal bedtime based on the inputs.

```swift
func SleepWell() {
    do {
        let config = MLModelConfiguration()
        let model = try SleepCalculator(configuration: config)
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute  = (components.minute ?? 0) * 60
        
        let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
        
        let sleepTime = wakeUp - prediction.actualSleep
        alertTitle = "Your ideal bedtime is..."
        alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
    } catch {
        alertTitle = "Error"
        alertMessage = "Sorry there was a problem in predicting your bedtime"
    }
    showingAlert = true
}
```

### Detailed Views

- **Main View**: Displays the interface for setting wake-up time, desired sleep, and coffee consumption, and shows the calculated bedtime.
- **Alert**: Provides immediate feedback to the user with the calculated bedtime.

## Error Handling and State Management

- **Input Validation**: Ensures that user inputs are valid and within expected ranges.
- **State Management**: Uses SwiftUI's state management to handle user inputs and application state, ensuring a smooth and responsive user experience.

## Example Workflow

1. **Open the application.**
2. **Set the desired wake-up time using the `DatePicker`.**
3. **Adjust the desired sleep amount using the `Stepper`.**
4. **Set the number of cups of coffee consumed.**
5. **Press the "Calculate" button to get the predicted bedtime.**

## Demo Video

See the "Sleep Tight" app in action:

[Demo Video](https://github.com/gangamamulya/SleepTight/assets/88301130/8de95c47-ffbe-4721-aeb5-c9a0c0c813f5
)



## Contact

- Project Link: [https://github.com/gangamamulya/WakeUpTimeScheduler](https://github.com/gangamamulya/WakeUpTimeScheduler)

Enjoy planning your sleep schedule with "Sleep Tight"!


