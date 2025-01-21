//
//  WelcomeView.swift
//  Smart Randomizer
//
//  Created by TODD SIFLEET on 1/5/25.
//
import SwiftUI

struct WelcomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Smart Randomizer")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Your ultimate tool for GTO Randomness")
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Image(systemName: "scribble.variable")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("Smart Randomizer runs in the background. Access it anytime from the menu bar or keyboard shortcut.")
                .font(.body)
                .multilineTextAlignment(.center)
            
            Text("Once you've found Smart Randomizer in the Menu Bar click the button below to continue.")
                .font(.body)
                .multilineTextAlignment(.center)
            
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Text("I FOUND IT!")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent).tint(.green)
                Button {
                    guard let url = URL(string: "https://smartfast.com/randomizer/support") else { return }
                    openURL(url)
                    
                } label: {
                    Text("I CAN'T FIND IT!")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent).tint(.red)
            }
        }
        .padding()
        .frame(width: 450, height: 400)
    }
}
