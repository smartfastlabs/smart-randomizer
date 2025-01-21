//
//  SettingsView.swift
//  Smart Randomizer
//
//  Created by TODD SIFLEET on 1/5/25.
//
import SwiftUI
import KeyboardShortcuts


struct SettingsView: View {
    @StateObject var config: ConfigService
    
    let defaults = UserDefaults.standard
    
    init(config: ConfigService) {
        self._config = StateObject(wrappedValue: config)
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Minimum Value")
                TextField("Min Value", value: $config.minValue, formatter: NumberFormatter()).onChange(of: config.minValue) {
                    if (config.minValue < config.maxValue) {
                        config.setConfig(minValue: config.minValue)
                    } else {
                        config.minValue = defaults.integer(forKey: "minValue")
                    }
                }
            }.padding(.horizontal, 10).padding(.top, 12)
            HStack {
                Text("Maximum Value")
                TextField("Max Value", value: $config.maxValue, formatter: NumberFormatter()).onChange(of: config.maxValue) {
                    if (config.minValue < config.maxValue) {
                        config.setConfig(maxValue: config.maxValue)
                    } else {
                        config.maxValue = defaults.integer(forKey: "maxValue")
                    }
                }
            }.padding(.horizontal, 10).padding(.vertical, 2)
            HStack {
                Text("Generate Every")
                TextField("Generate Every", value: $config.generateEvery, formatter: NumberFormatter()).onChange(of: config.generateEvery) {
                    config.setConfig(generateEvery: config.generateEvery)
                }
                Text("Seconds")
            }.padding(.horizontal, 10).padding(.top, 0)
            HStack {
                Toggle(
                    "Run on Start Up",
                    isOn: $config.runOnStartUp
                ).onChange(of: config.runOnStartUp) {
                    print("ADfSD")
                    config.setConfig(runOnStartUp: config.runOnStartUp)
                }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
            }.padding(.vertical, 2)
            
            Form {
                KeyboardShortcuts.Recorder("", name: .generateRandomNumber)
                KeyboardShortcuts.Recorder("", name: .toggleShowHUDs)
            }.padding(.vertical, 2).padding(.bottom, 10)
            
        }.overlay(
            RoundedRectangle(
                cornerRadius: 5
            ).stroke(.gray, lineWidth: 1)
        )
    }
}
