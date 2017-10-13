//
//  Scene.swift
//  TargetShooter-iOS
//
//  Created by Michael Alexander on 10/13/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import SpriteKit
import ARKit
import GameplayKit

class Scene: SKScene {
    
    let remainingLabel = SKLabelNode()
    var timer: Timer?
    var targetsCreated = 0
    var targetCount = 0 {
        didSet{
            remainingLabel.text = "Remaining: \(targetCount)"
        }
    }
    
    override func didMove(to view: SKView) {
        remainingLabel.fontSize = 36
        remainingLabel.fontName = "AmericanTypewriter"
        remainingLabel.color = .white
        remainingLabel.position = CGPoint(x:0, y: view.frame.midY - 50)
        addChild(remainingLabel)
        targetCount = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            self.createTarget()
        })
        
    }
    
    func createTarget(){
        
        if targetsCreated == 20{
            
            timer?.invalidate()
            timer = nil
            return
        }
        
        targetsCreated += 1
        targetCount += 1
        
        // find the scene view we are drawing
        guard let sceneView = self.view as? ARSKView else { return }
        
        // get access to a random number generator
        let random = GKRandomSource.sharedRandom()
        
        //create a random X rotation
        let xRotation = matrix_float4x4(SCNMatrix4MakeRotation(Float.pi * 2 * random.nextUniform(), 1, 0, 0))
        
        //create a random Y roation
        let yRotation = matrix_float4x4(SCNMatrix4MakeRotation(Float.pi * 2 * random.nextUniform(), 0, 1, 0))
        
        // combine them together
        let rotation = simd_mul(xRotation, yRotation)
        
        // move foward 1.5 meters into the screen
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.5
        
        // combine that with our rotation
        let transform = simd_mul(rotation, translation)
        
        // create an anchor at the finished position
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
