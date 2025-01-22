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
    @StateObject var hudManager: HUDManager
    
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    let id: UUID
    
    init(
        id: UUID,
        manager: HUDManager,
        config: ConfigService,
        timer: Publishers.Autoconnect<Timer.TimerPublisher>
    ) {
        self.id = id
        self.timer = timer
        
        self._randomizer = StateObject(
            wrappedValue: RandomizerService(config: config)
        )
        self._hudManager = StateObject(
            wrappedValue: manager
        )
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
                    self.hudManager.close(id: self.id)
                }) {
                    Text("Remove HUD")
                    Image(systemName: "xmark.circle")
                }
            }
    }
}
