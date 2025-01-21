//
//  Randomizer.swift
//  Smart Randomizer
//
//  Created by TODD SIFLEET on 1/5/25.
//
import SwiftUI

class RandomizerService:ObservableObject {
    @Published var value: Int = 0
    @Published var generatedAt: Date = Date()
    
    var config: ConfigService
    
    init(config: ConfigService) {
        self.config = config
        self.update()
    }
    
    func update() {
        value = Int.random(in: self.config.minValue..<self.config.maxValue+1)
        generatedAt = Date()
    }
    
    func updateIfReady() {
        if (generatedAt.distance(to: Date()) > self.config.generateEvery) {
            update()
        }
    } 
}
