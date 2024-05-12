# Steps Tracking App

## Overview
The **Steps Tracking App** is designed to monitor physical activity by tracking steps and displaying achievements based on the number of steps taken. The app integrates with Apple Health to access step data, providing users with insightful visualizations of their monthly activity and rewarding achievements for reaching step milestones.

## Features

- **Steps Data Integration**: Retrieves the monthly steps data from Apple Health.
- **Dynamic Line Chart**: Visualizes daily steps for the current month on a line chart where the x-axis represents the day of the month and the y-axis shows the step count per day. The y-axis adjusts dynamically based on the highest step count recorded to provide a clear view of daily fluctuations.
- **Achievements Display**: Showcases achievements directly on the home view, with different badges displayed based on the total steps taken within the month:
  - **0 - 9,999 steps**: No achievements
  - **10,000 steps**: First badge
  - **20,000 steps and beyond**: Additional badges for each 10,000 steps increment
- **Detailed Achievement View**: Offers a detailed view of the current achievement when selected, implemented in a separate, newly crafted view.

## Architecture
- **Model-View-ViewModel-Controller (MVVM-C)**: Ensures a clean separation of concerns, facilitating easier maintenance and scalability.

## Technologies
- **UIKit**: Utilized programmatically to craft the user interface.
- **Combine**: Handles asynchronous events and data binding.
- **HealthKit**: Integrates with Apple Health to access real-time step data.
- **CoreData**: Manages the app’s data model, storing achievements and user progress.

## App Interface
Here are some snapshots of the app in action:

<p align="center">
  <img src="https://github.com/7Backwards/Steps-Tracking/assets/34812559/2392961b-48df-4436-86c8-606839ab15f6" alt="App Interface" width="250">
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
  <img src="https://github.com/7Backwards/Steps-Tracking/assets/34812559/68dfa216-9af5-48f3-a8d5-09418e730673" alt="Achievement Display" width="250">
</p>

