# fileXcure

## Introduction

fileXcure is a Flutter-based application that provides secure storage of files. This application uses Advanced Encryption Standard (AES) to encrypt your files before storing them into Microsoft Azure Cloud Storage. It also includes an authentication system using MongoDB for user registration and login functionality. 

## Features
- File encryption using AES.
- Storing the encrypted files on Azure Cloud.
- User Authentication system (Login/Register) powered by MongoDB.

## Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio or VS Code

## Libraries used
- `flutter/material.dart`
- `flutter/widgets.dart`
- `splashscreen`
- `mongo_dart`
- `mongo_dart_query`
- `file_picker`
- `dart:io`
- `azstore`
- `path`
- `dart:typed_data`
- `mime`
- `dart:convert`
- `encrypt`

## Setup & Installation

Follow these steps to get your development environment set up:

1. [Download and Install Flutter](https://flutter.dev/docs/get-started/install)
2. Clone the Repository
   ```
   git clone https://github.com/{username}/fileXcure.git
   ```
3. Navigate to the project root directory and Install dependencies
   ```
   cd fileXcure
   flutter pub get
   ```
4. Run the app
   ```
   flutter run
   ```

## Usage

1. **SplashScreenWrapper**: This is the initial screen displayed when the app is launched. It displays a splash screen.

2. **LoginPage**: After the splash screen, the user is navigated to the login page. If the user is already registered, they can log in using their credentials.

3. **RegistrationPage**: New users can register from this page by providing a username and password.

4. **HomePage**: After successful login, the user is navigated to the home page where they can upload files. The file selected by the user is encrypted using AES and then uploaded to Azure Cloud Storage.

Please replace the MongoDB and Azure Cloud storage connection string and access details with your own before running the app.

## Contributions
If you encounter any problem or have any suggestions, please [file an issue](https://github.com/dhruv1972/fileXcure/issues) or submit a [pull request](https://github.com/dhruv1972/fileXcure/pulls).

## License
fileXcure is released under the [MIT License](https://github.com/dhruv1972/fileXcure/LICENSE.md).

**Note:** This README assumes you have Flutter, Dart, and an IDE installed and properly configured. If not, please refer to the official Flutter [documentation](https://flutter.dev/docs/get-started/install) for installation instructions.
