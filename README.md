# Bitkub Test Flutter App

https://github.com/user-attachments/assets/a577a515-281c-40ca-b355-869c2df31b1a

## Overview

This Flutter application implements a simple auth flow with Sign In, multi-step Sign Up, a Home screen that displays user info, and session persistence until logout.

### Features Implemented

- **Sign In**: Inputs `Phone Number` and `Password`. Login succeeds only when:
  - **Phone**: `123456789`
  - **Password**: `password`
- **Sign Up (4 steps)**:
  1. Fill in phone number
  2. Enter OTP sent to the phone number (mocked flow)
  3. Set password
  4. On success, navigates to Home with an active session
- **Home Screen**:
  - Displays phone number
  - Displays mocked first name and last name
  - Includes Logout button
- **Session Handling**: If already logged in, the user remains signed in across app restarts until they choose to log out.

### Quick Start

1. **Prerequisites**

   - Flutter SDK installed and on PATH (stable channel recommended)
   - Platform toolchains as needed (Xcode for iOS/macOS, Android SDK for Android, Chrome for Web)

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   - You can simply **click the “Run ▶️” (Play) button** in the **Run and Debug** section of VS Code.

   Make sure:

   - You have a device or emulator selected at the bottom-right corner of VS Code.
   - The main entry file is `lib/main.dart`.
   - using args `--dart-define-from-file .env.dev`

VS Code will automatically build and launch the app in **debug mode**

### How to Verify the Requirements

- **Sign In success case**
  1. Launch app; you should see the Sign In screen if no active session exists.
  2. Enter phone `123456789` and password `password`.
  3. Tap Sign In. You should be navigated to the Home screen with an active session.
- **Sign In failure case**
  - Any other credentials should show an error and remain on Sign In.
- **Sign Up flow (4 steps)**
  1. From Sign In, navigate to Sign Up.
  2. Step 1: Enter a phone number and proceed.
  3. Step 2: Enter the OTP (mocked acceptance) and proceed.
  4. Step 3: Set a password and proceed.
  5. Step 4: On success, you are navigated to Home and a session is active.
- **Home screen checks**
  - Phone number is shown.
  - First name and last name show mocked values.
  - Logout button is present.
- **Session persistence**
  - Close and reopen the app; you should remain on Home if you were logged in.
  - Tap Logout on Home; you should be returned to Sign In and the session cleared.

### Test Credentials

- For direct Sign In:
  - **Phone**: `123456789`
  - **Password**: `password`

### Project Scripts (optional)

- Run unit/widget tests (if present):

  ```bash
  flutter test
  ```

### Notes

- OTP is mocked for demonstration; no real SMS is sent.
- First and last name values on Home are mocked as required.

### Result Summary

- **Successful Sign In** with the provided credentials navigates to `Home` and creates a persistent session.
- **Sign Up** completes in 4 steps and also lands on `Home` with a session.
- **Home** displays phone, mocked first name, mocked last name, and provides **Logout**.
- **Session** persists across app restarts until **Logout** is tapped.

### Technical Notes

- **Sign Up token (signUpToken)**

  - Flow: `/auth/signup` returns an OTP reference
  - user enters OTP → `/auth/submit-otp` returns a temporary `signUpToken` bound to the phone number
  - `/auth/complete-signup` exchanges `signUpToken` + phone + password for an `accessToken` (auth).
  - Purpose: Prevents completing sign up without a valid OTP step; acts as a short-lived handoff between OTP verification and password creation.

- **TokenRepositoryImpl**

  - Repository responsible for securely persisting and retrieving authentication tokens.
  - Encrypts token payloads using a device-bound crypto key before storing them in `FlutterSecureStorage`.
  - Uses `DeviceCryptoService` (AES-GCM) to provide confidentiality, integrity, and tamper detection.
  - Decodes and decrypts data on read; returns `null` if payload is corrupted or cannot be decrypted.
  - Includes in-memory caching to avoid unnecessary secure storage reads and improve performance.
  - Designed for testability with mocked secure storage and crypto layer in unit tests.

- **API client (`ApiClientDemo`)**
  - A mock client backing endpoints like `/auth/signin`, `/auth/signup`, `/auth/submit-otp`, `/auth/complete-signup`, and `/users/me`.
  - Reads the current token from `SessionStore` to authorize and returns mocked user data. Useful for local demos without a backend.
