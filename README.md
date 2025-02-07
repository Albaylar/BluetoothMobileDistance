# BluetoothMobileDistance
# Mobile Distance Sensor with iOS Integration

This project demonstrates a wireless distance sensing system using an ultrasonic sensor (e.g., HC-SR04) connected to an Arduino board. The measured distance is transmitted via a Bluetooth module (HC-05/HC-06) to an iOS application. The iOS app, built with SwiftUI and CoreBluetooth, displays real-time distance measurements in a modern, user-friendly interface.

---

## Table of Contents

- [Features](#features)
- [Hardware Requirements](#hardware-requirements)
- [Software Requirements](#software-requirements)
- [Setup and Installation](#setup-and-installation)
  - [Arduino Setup](#arduino-setup)
  - [iOS SwiftUI Application Setup](#ios-swiftui-application-setup)
- [System Workflow](#system-workflow)
- [Directory Structure](#directory-structure)
- [Known Issues and Troubleshooting](#known-issues-and-troubleshooting)
- [License](#license)
- [Contact](#contact)

---

## Features

- **Real-Time Distance Measurement:**  
  Uses an ultrasonic sensor (HC-SR04) to measure distances accurately in real time.

- **Wireless Data Transmission:**  
  Transmits distance data via a Bluetooth module (HC-05/HC-06) for remote monitoring.

- **iOS Integration with SwiftUI:**  
  A SwiftUI-based iOS app uses CoreBluetooth to receive and display the distance data in a sleek interface.

- **Versatile Applications:**  
  Suitable for parking assistance, obstacle detection, robotics, and other distance-sensing applications.

---

## Hardware Requirements

- **Arduino Board:** (Uno, Mega, or compatible)
- **Ultrasonic Sensor:** HC-SR04 (or similar)
- **Bluetooth Module:** HC-05/HC-06
- **Connecting Wires and Breadboard**
- **Power Supply**

---

## Software Requirements

- **Arduino IDE:** For compiling and uploading the Arduino sketch.
- **Xcode:** For developing and compiling the SwiftUI iOS application.
- **Swift 5** and **iOS 13** or later.

---

## Setup and Installation

### Arduino Setup

1. **Wiring:**  
   - **Ultrasonic Sensor (HC-SR04):**  
     - VCC → 5V  
     - GND → Ground  
     - TRIG → Digital Pin 9  
     - ECHO → Digital Pin 10  
   - **Bluetooth Module (HC-05/HC-06):**  
     - VCC → 5V  
     - GND → Ground  
     - TX → Digital Pin 8 (Arduino RX via SoftwareSerial)  
     - RX → Digital Pin 7 (Arduino TX via SoftwareSerial)

2. **Arduino Code:**  
   Upload the following sketch to your Arduino board:

   ```cpp
   /*
     Mobile Distance Sensor with iOS Integration
     Uses an HC-SR04 Ultrasonic Sensor and an HC-05/HC-06 Bluetooth Module.
   */

   #include <SoftwareSerial.h>

   // Define pins for the ultrasonic sensor
   const int trigPin = 9;
   const int echoPin = 10;

   // Define pins for the Bluetooth module (SoftwareSerial)
   const int btRx = 8;  // Arduino RX (connected to Bluetooth TX)
   const int btTx = 7;  // Arduino TX (connected to Bluetooth RX)

   SoftwareSerial bluetooth(btRx, btTx);

   void setup() {
     // Initialize Serial for debugging and Bluetooth communication
     Serial.begin(9600);
     bluetooth.begin(9600);
     
     // Set up sensor pins
     pinMode(trigPin, OUTPUT);
     pinMode(echoPin, INPUT);
   }

   void loop() {
     // Clear the trigger pin
     digitalWrite(trigPin, LOW);
     delayMicroseconds(2);

     // Send a 10-microsecond pulse to trigger the sensor
     digitalWrite(trigPin, HIGH);
     delayMicroseconds(10);
     digitalWrite(trigPin, LOW);

     // Read the pulse duration on the echo pin
     long duration = pulseIn(echoPin, HIGH);

     // Calculate distance in centimeters (approximation)
     float distance = duration / 58.2;

     // Print and send the distance measurement
     Serial.print("Distance: ");
     Serial.print(distance);
     Serial.println(" cm");

     bluetooth.print("Distance: ");
     bluetooth.print(distance);
     bluetooth.println(" cm");

     delay(500);  // Update every 500 milliseconds
   }
