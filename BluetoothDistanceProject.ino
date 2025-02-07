/*
  Mobile-Controlled Parking Sensor
  Uses HC-SR04 Ultrasonic Sensor and HC-05/HC-06 Bluetooth Module.
  Sends real-time distance measurements to the mobile app.
*/

const int trigPin = 9;   // Trigger pin for HC-SR04
const int echoPin = 10;  // Echo pin for HC-SR04

void setup() {
  // Initialize serial communication for Bluetooth at 9600 baud rate
  Serial.begin(9600);
  
  // Set pin modes
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  // Clear the trigger pin
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  // Send a 10-microsecond HIGH pulse to trigger the sensor
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Read the duration of the pulse on the echo pin
  long duration = pulseIn(echoPin, HIGH);
  
  // Calculate distance in centimeters (approximation)
  float distance = duration / 58.2;

  // Send the distance reading via Bluetooth
  Serial.print("Distance: ");
  Serial.print(distance);
  Serial.println(" cm");
  
  // Optional: Send a warning if an obstacle is too close (e.g., less than 20 cm)
  if (distance < 20) {
    Serial.println("Warning: Obstacle very close!");
  }
  
  delay(500);  // Wait 500 ms before the next measurement
}