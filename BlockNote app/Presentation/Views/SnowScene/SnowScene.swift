//
//  SnowScene.swift
//  BlockNote app
//
//  Created by Kovs on 03.12.2022.
//

import Foundation
import SpriteKit

class SnowScene: SKScene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        setupSnowParticleEmitter()
    }

    private func setupSnowParticleEmitter() {
        let snowParticleEmitter = SKEmitterNode(fileNamed: "SnowBackground")!
        snowParticleEmitter.position = CGPoint(x: size.width / 2, y: size.height - 50)
        addChild(snowParticleEmitter)
    }
}
