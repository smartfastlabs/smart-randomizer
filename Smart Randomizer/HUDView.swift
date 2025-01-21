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
    
    
    var body: some View {
        Text(self.randomizer.value.formatted(.number))
            .frame(width: 40, height: 40)
            .background(Color.green)
            .clipShape(Capsule())
            .onReceive(timer) { input in
                self.randomizer.updateIfReady()
            }
            .onTapGesture {
                self.randomizer.update()
            }
    }
}

func OpenHud(config: ConfigService, hud: HUDConfig, timer: Publishers.Autoconnect<Timer.TimerPublisher>) -> NSWindow {
    let window = NSWindow(
        contentRect: NSRect(x: 100, y: 150, width: 300, height: 200),
        styleMask: [.borderless, .fullSizeContentView, .hudWindow],
        backing: .buffered,
        defer: false
    )
    
    window.contentView = NSHostingView(rootView: HUDView(config: config, timer: timer))
    window.backgroundColor = NSColor.clear
    window.isReleasedWhenClosed = true
    window.isMovableByWindowBackground = true
    window.level = .floating
    window.orderFrontRegardless()
    window.center()
    window.setFrameOrigin(NSPoint(x: hud.x, y: hud.y))
    return window
}
