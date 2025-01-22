//
//  ContentView.swift
//  Smart Randomizer
//
//  Created by TODD SIFLEET on 1/5/25.
//

import SwiftUI
import KeyboardShortcuts
import Combine

extension KeyboardShortcuts.Name {
    static let generateRandomNumber = Self("generateRandomNumber")
    static let toggleShowHUDs = Self("toggleShowHUDs")
    static let newHUD = Self("newHUD")
}

var welcomeWindow: NSWindow? = nil

@main
struct RandomizerApp: App {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var appConfig: ConfigService
    @StateObject var randomizer: RandomizerService
    @StateObject var hudManager: HUDManager
    
    @AppStorage("showWelcome") private var showWelcome = true
    
    var timer:Publishers.Autoconnect<Timer.TimerPublisher>
    
    init() {
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        let appConfig = ConfigService()

        let randomizer = RandomizerService(config: appConfig)
        let hudManager = HUDManager(config: appConfig, timer: timer)
        self.timer = timer
        self._appConfig = StateObject(wrappedValue: appConfig)
        self._randomizer = StateObject(wrappedValue: randomizer)
        self._hudManager = StateObject(wrappedValue: hudManager)
        KeyboardShortcuts.onKeyUp(for: .generateRandomNumber) {
            randomizer.update()
        }
        

        if showWelcome {
            welcomeWindow = NSWindow()
            welcomeWindow?.contentView = NSHostingView(rootView: WelcomeView())
            welcomeWindow?.identifier = NSUserInterfaceItemIdentifier(rawValue: "welcome")
            welcomeWindow?.styleMask = [.closable, .titled]
            welcomeWindow?.isReleasedWhenClosed = true
            welcomeWindow?.center()
            welcomeWindow?.becomeFirstResponder()
            welcomeWindow?.orderFrontRegardless()
            showWelcome = false;
        }
        
        if (appConfig.showHUDs) {
            hudManager.openHUDs()
        }
    }
    
    var body: some Scene {
        MenuBarExtra(isInserted: .constant(true)) {
            VStack {
                Text("")

                
                TabView {
                    RandomView(randomizer: randomizer).tabItem {
                        Text("Home")
                    }
                    SettingsView(config: appConfig, hudManager: hudManager).tabItem {
                        Text("Settings")
                    }
                    ShortCutsView().tabItem {
                        Text("Shortcuts")
                    }
                }
                
                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Text("Quit")
                        .frame(maxWidth: .infinity)
                }.buttonStyle(.borderedProminent).tint(.red)
                Text(
                    "[Smartfast Labs](https://smartfast.com)"
                )
                
            }.padding([.bottom, .leading, .trailing], 10)
                .padding(.top, 0)
                .clipped()
                .frame(maxWidth: .infinity)
        } label: {
            Image(
                systemName: colorScheme == .light ? "questionmark.circle" : "questionmark.circle.fill"
            ).frame(width: 50, height: 50).aspectRatio(contentMode: .fit)
            if (self.appConfig.showNumberInMenu) {
                Text(self.randomizer.value.formatted(.number)).onReceive(timer) { input in
                    self.randomizer.updateIfReady()
                }
            }
        }.menuBarExtraStyle(.window)
    }
}
