# React Native Project Setup

Arise Wallet!
A BitDevsUyo community project

## Overview and Setup Guide

This is a mobile application built with React Native
The purpose of the project is to build a user friendly Bitcoin wallet using react native for our community project.
During the development of this app members of the community who can contribute in one way or another to the building of the project are encouraged to do so.

## Setup Instructions

### 1. Prerequisites

Make sure you have the following installed:

- **Node.js**(https://nodejs.org/) (v18+ recommended)
- **Package Manager:** **npm**
- **Development Environment:**
  - **Android:** Android Studio, Android SDK, & Java (JDK 17).
  - **iOS:** Xcode (macOS only) & CocoaPods.
- **Git**

> _Tip: If you haven't set up your machine for React Native before, follow the [React Native Environment Setup Guide](https://reactnative.dev/docs/environment-setup) and select "React Native CLI Quickstart" -> "Expo" tab._

### 2. Clone the Repository

To start contributing clone the repo to your local
git clone -b reactnative/dev (https://github.com/BitDevsUyo/AriseWallet.git)
cd AriseWallet

### 3. Install Dependencies

npm install

### 4. Generate Native Projects (Required)
You must run this command to generate the android and ios folders. These folders are git-ignored, so you must generate them locally before compiling.

npx expo prebuild

### 5. Compile & Run the App
# For Android
npx expo run:android

# For iOS (Mac only)
npx expo run:ios

## Once the app is compiled and installed on your phone/emulator (Step 4), you generally do not need to recompile unless you install a new native library.

npx expo start
## Guildelines on how to contribute

-Issues will be created so do check the issues tabb for tasks
-Pick a task to work on or create new issue.
-Create a new branch from main
-Submit PR with clear descriptions

Keep code clean, documented and reusable
