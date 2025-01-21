//
//  HUDManager.swift
//  Smart Randomizer
//
//  Created by TODD SIFLEET on 1/21/25.
//

import Foundation
import SwiftUI
import Combine
import KeyboardShortcuts


class HUDManager: ObservableObject {
    @Published private(set) var windows: [UUID: NSWindow] = [:]
    @Published private(set) var appConfig: ConfigService
    @Published private(set) var areHUDsVisible: Bool = true
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    init(config: ConfigService, timer: Publishers.Autoconnect<Timer.TimerPublisher>) {
        self.timer = timer
        self.appConfig = config
        KeyboardShortcuts.onKeyUp(for: .toggleShowHUDs) {
            self.toggleHUDs()
        }
    }
    
    
    func addHUD(hud: HUDConfig, timer: Publishers.Autoconnect<Timer.TimerPublisher>) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 100, y: 150, width: 300, height: 200),
            styleMask: [.borderless, .fullSizeContentView, .hudWindow],
            backing: .buffered,
            defer: false
        )
        
        window.contentView = NSHostingView(rootView: HUDView(config: appConfig, timer: timer))
        window.backgroundColor = NSColor.clear
        window.isReleasedWhenClosed = false
        window.isMovableByWindowBackground = true
        window.level = .floating
        window.orderFrontRegardless()
        window.setFrameOrigin(NSPoint(x: hud.x, y: hud.y))
        print(self.windows)
        self.windows[hud.id] = window
        return window
    }
    
    func closeHUDs() {
        for (id, hud) in self.windows {
            hud.close()
            self.windows[id] = nil
        }
    }
    
    func openHUDs() {
        _ = addHUD(hud: HUDConfig(x: 10, y: 20, id: UUID()), timer: timer)
        _ = addHUD(hud: HUDConfig(x: 100, y: 200, id: UUID()), timer: timer)
        _ = addHUD(hud: HUDConfig(x: 400, y: 400, id: UUID()), timer: timer)
        _ = addHUD(hud: HUDConfig(x: 800, y: 800, id: UUID()), timer: timer)
    }
    
    func toggleHUDs() {
        if (areHUDsVisible) {
            closeHUDs()
        } else {
            openHUDs()
        }
        areHUDsVisible = !areHUDsVisible
    }
}
