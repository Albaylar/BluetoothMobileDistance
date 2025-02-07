//
//  ContentView.swift
//  MobileDistanceSensorApp
//
//  Created by Furkan Deniz Albaylar on 7.02.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Distance Sensor")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                DistanceDataCard(dataString: bluetoothManager.distanceData)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct DistanceDataCard: View {
    var dataString: String
    
    var body: some View {
        VStack {
            Text(dataString)
                .font(.title2)
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(0.5)))
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
