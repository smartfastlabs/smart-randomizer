//
//  HudView.swift
//  Smart Randomizer
//
//  Created by TODD SIFLEET on 1/20/25.
//

import Foundation
import SwiftUI
import Combine


struct HUDView: View {
    @StateObject var randomizer: RandomizerService
    @StateObject var appConfig: ConfigService
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    init(config: ConfigService, timer: Publishers.Autoconnect<Timer.TimerPublisher>) {
        let randomizer = RandomizerService(config: config)
        self.timer = timer
        self._appConfig = StateObject(wrappedValue: config)
        self._randomizer = StateObject(wrappedValue: randomizer)
    }

    func close(_: _ModifiersGesture<TapGesture>.Value) {
        print("ADSFSDF")
    }
    
    var body: some View {
        Text(self.randomizer.value.formatted(.number))
            .frame(width: 40, height: 22)
            .background(Color.green)
            .clipShape(Capsule())
            .onReceive(timer) { input in
                self.randomizer.updateIfReady()
            }
            .onTapGesture {
                self.randomizer.update()
            }
            .contextMenu {
                Button(action: {
                    print("Hello")
                }) {
                    Text("Say Hello")
                    Image(systemName: "hand.wave")
                }
            }
    }
}
