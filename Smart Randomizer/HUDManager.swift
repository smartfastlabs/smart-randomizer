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
        KeyboardShortcuts.onKeyUp(for: .newHUD) {
            self.newHUD()
        }
    }
    
    
    func addHUD(hud: HUDConfig, timer: Publishers.Autoconnect<Timer.TimerPublisher>) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: hud.x, y: hud.y, width: 300, height: 200),
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidMove),
            name: NSWindow.didMoveNotification,
            object: window
        )
        self.windows[hud.id] = window
        return window
    }
    func newHUD() {
        var hud = HUDConfig(x: 500, y: 500, id: UUID())
        let window = addHUD(hud: hud, timer: timer)
        window.center()
        hud.x = Int(window.frame.origin.x)
        hud.y = Int(window.frame.origin.y)
        self.appConfig.huds[hud.id] = hud
        self.appConfig.setConfig(huds: self.appConfig.huds)
    }
    
    @objc private func windowDidMove(_ notification: Notification) {
        
        guard let window = notification.object as? NSWindow else { return }
        
        var hudID: UUID? = nil
        
        for (id, temp) in self.windows {
            if temp == window {
                hudID = id
                break
            }
        }
        
        if (hudID == nil) {
            print("COULD NOT FIND HUD ID")
            return
        }
        
        let frame = window.frame
        let x = Int(frame.origin.x)
        let y = Int(frame.origin.y)
        

        appConfig.huds[hudID!] = HUDConfig(x: x, y: y, id: hudID!)
        appConfig.setConfig(huds: appConfig.huds)
        print("Window \(hudID!) moved to: x: \(x), y: \(y)")
    }
    
    func closeHUDs() {
        for (id, hud) in self.windows {
            hud.close()
            self.windows[id] = nil
        }
    }
    
    func openHUDs() {
        for (_, hud) in self.appConfig.huds {
            _ = addHUD(hud: hud, timer: timer)
        }
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
