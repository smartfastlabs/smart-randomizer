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
    @StateObject var hudManager: HUDManager
    
    let defaults = UserDefaults.standard
    
    init(config: ConfigService, hudManager: HUDManager) {
        self._config = StateObject(wrappedValue: config)
        self._hudManager = StateObject(wrappedValue: hudManager)
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
            VStack {
                Toggle(
                    "Run on Start Up",
                    isOn: $config.runOnStartUp
                ).onChange(of: config.runOnStartUp) {
                    config.setConfig(runOnStartUp: config.runOnStartUp)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                Toggle(
                    "Show Random # in Menubar",
                    isOn: $config.showNumberInMenu
                ).onChange(of: config.showNumberInMenu) {
                    config.setConfig(showNumberInMenu: config.showNumberInMenu)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                Toggle(
                    "Show HUDs",
                    isOn: $config.showHUDs
                ).onChange(of: config.showHUDs) {
                    config.setConfig(showHUDs: config.showHUDs)
                    if config.showHUDs {
                        hudManager.openHUDs()
                    } else {
                        hudManager.closeHUDs()
                    }
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
            }.padding(.vertical, 2)
            
            Form {
                KeyboardShortcuts.Recorder("Generate", name: .generateRandomNumber)
                KeyboardShortcuts.Recorder("Toggle HUDs", name: .toggleShowHUDs)
                KeyboardShortcuts.Recorder("Add HUD", name: .newHUD)
            }.padding(.vertical, 2).padding(.bottom, 10)
            
        }.overlay(
            RoundedRectangle(
                cornerRadius: 5
            ).stroke(.gray, lineWidth: 1)
        )
    }
}
