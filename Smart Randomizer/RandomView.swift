//
//  SettingsView.swift
//  Smart Randomizer
//
//  Created by TODD SIFLEET on 1/5/25.
//
import SwiftUI
import KeyboardShortcuts


struct RandomView: View {
    @StateObject var randomizer: RandomizerService
    
    init(randomizer:RandomizerService) {
        self._randomizer = StateObject(wrappedValue: randomizer)
    }
    var body: some View {
        VStack {
            Text(
                self.randomizer.value.formatted(.number)
            )
                .font(.system(size: 144))
                .onTapGesture {
                    self.randomizer.update()
                }
                .padding()
        }
    }
}
