//
//  SushiPiece.swift
//  SushiNeko
//
//  Created by Jamar Gibbs on 10/3/18.
//  Copyright © 2018 B3773R. All rights reserved.
//

import SpriteKit

class SushiPiece : SKSpriteNode {
    // Chopstick objects
    var rightChopstick : SKSpriteNode!
    var leftChopstick : SKSpriteNode!
    // required init for subclass to work
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    // required init for subclass
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
     
    func connectChopsticks() {
        rightChopstick = childNode(withName:"rightChopstick") as! SKSpriteNode
        leftChopstick = childNode(withName:"leftChopstick") as! SKSpriteNode
    // set default side
        side = .none
    }
    
    // sushi type
    var side : Side = .none {
        didSet {
            switch side {
                // show left chopstick
            case .left:
                leftChopstick.isHidden = false
                // show right chopstick
            case .right:
                rightChopstick.isHidden = false
                // hide all chopsticks
            case .none:
                rightChopstick.isHidden = true
                leftChopstick.isHidden = true
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
