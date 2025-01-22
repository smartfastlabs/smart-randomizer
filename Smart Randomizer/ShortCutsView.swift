//
//  SettingsView.swift
//  Smart Randomizer
//
//  Created by TODD SIFLEET on 1/5/25.
//
import SwiftUI
import KeyboardShortcuts


struct ShortCutsView: View {
    let defaults = UserDefaults.standard

    var body: some View {
        VStack {
            Text(
                "Keyboard Short Cuts"
            ).font(.system(size: 18))
            Form {
                KeyboardShortcuts.Recorder("Generate", name: .generateRandomNumber)
                KeyboardShortcuts.Recorder("Toggle HUDs", name: .toggleShowHUDs)
                KeyboardShortcuts.Recorder("Add HUD", name: .newHUD)
            }.padding(.vertical, 2).padding(.bottom, 10)
        }
    }
}
