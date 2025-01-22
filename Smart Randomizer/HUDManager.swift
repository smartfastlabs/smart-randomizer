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
    
    
    func addHUD(hud: HUDConfig) -> NSWindow {
        let window = HUDWindow(hud: hud)
        
        let view = HUDView(
            id: hud.id,
            manager: self,
            config: appConfig,
            timer: timer
        )
        
        window.contentView = NSHostingView(
            rootView: view
        )
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
        let window = addHUD(hud: hud)
        window.center()
        hud.x = Int(window.frame.origin.x)
        hud.y = Int(window.frame.origin.y)
        self.appConfig.huds[hud.id] = hud
        self.appConfig.setConfig(huds: self.appConfig.huds)
    }
    
    func close(id: UUID) {
        let window = self.windows[id]
        
        if window == nil {
            print("WINDOW NOT FOUND \(id)")
            return
        }
        window!.close()
        self.windows[id] = nil
        
        self.appConfig.huds[id] = nil
        self.appConfig.setConfig(huds: self.appConfig.huds)
        
    }
    
    @objc private func windowDidMove(_ notification: Notification) {
        
        guard let window = notification.object as? HUDWindow else { return }
        
        
        let frame = window.frame
        let x = Int(frame.origin.x)
        let y = Int(frame.origin.y)
        
        let hudID = window.id
        appConfig.huds[hudID] = HUDConfig(x: x, y: y, id: hudID)
        appConfig.setConfig(huds: appConfig.huds)
        print("Window \(hudID) moved to: x: \(x), y: \(y)")
    }
    
    func closeHUDs() {
        for (id, hud) in self.windows {
            hud.close()
            self.windows[id] = nil
        }
    }
    
    func openHUDs() {
        for (_, hud) in self.appConfig.huds {
            _ = addHUD(hud: hud)
        }
    }
    
    func toggleHUDs() {
        if (appConfig.showHUDs) {
            closeHUDs()
        } else {
            openHUDs()
        }
        
        appConfig.setConfig(showHUDs: !appConfig.showHUDs)
    }
}
