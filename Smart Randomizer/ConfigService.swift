//
//  ConfigService.swift
//  Smart Randomizer
//
//  Created by TODD SIFLEET on 1/5/25.
//
import SwiftUI
import LaunchAtLogin
import KeyboardShortcuts
import Foundation

struct HUDConfig: Codable {
    var x: Int
    var y: Int
    var id: UUID
}


class ConfigService:ObservableObject {
    @Published var minValue: Int
    @Published var maxValue: Int
    @Published var generateEvery: Double
    @Published var runOnStartUp: Bool = false;
    @Published var huds: [UUID:HUDConfig] = [:]
    
    let defaults = UserDefaults.standard
    
    init() {
        self.maxValue = defaults.integer(forKey: "maxValue")
        self.minValue = defaults.integer(forKey: "minValue")
        self.generateEvery = defaults.double(forKey: "generateEvery")
        self.runOnStartUp = LaunchAtLogin.isEnabled
        
        if (self.generateEvery == 0) {
            self.generateEvery = 15
        }
        if (self.maxValue == 0) {
            self.maxValue = 100
        }
        self.loadHUDConfig()
    }
    
    func loadHUDConfig() {
        if let data = UserDefaults.standard.data(forKey: "huds") {
            do {
                self.huds  = try JSONDecoder().decode([UUID:HUDConfig].self, from: data)

            } catch {
                print("Unable to Decode HUD Configs (\(error))")
            }
        }
    }
    
    func setConfig(
        maxValue: Int? = nil,
        minValue: Int? = nil,
        generateEvery: Double? = nil,
        runOnStartUp: Bool? = nil,
        huds: [UUID:HUDConfig]? = nil
    ) {
        if (runOnStartUp != nil) {
            LaunchAtLogin.isEnabled = runOnStartUp!
            self.runOnStartUp = runOnStartUp!
        }
        if (maxValue != nil) {
            print("SET MAX VALUE")
            self.maxValue = maxValue!
            defaults.set(maxValue!, forKey: "maxValue")
        }
        if (minValue != nil) {
            self.minValue = minValue!
            defaults.set(minValue!, forKey: "minValue")
        }
        if (generateEvery != nil) {
            self.generateEvery = generateEvery!
            defaults.set(generateEvery!, forKey: "generateEvery")
        }
        if (huds != nil) {
            self.huds = huds!
            do {
                let data = try JSONEncoder().encode(self.huds)
                UserDefaults.standard.set(data, forKey: "huds")

            } catch {
                print("Unable to Encode HUD configs (\(error))")
            }
        }
    }
}
