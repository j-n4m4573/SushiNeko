//
//  Character.swift
//  SushiNeko
//
//  Created by Jamar Gibbs on 10/4/18.
//  Copyright © 2018 B3773R. All rights reserved.
//

import SpriteKit

class Character : SKSpriteNode {
    
    let punch = SKAction(named:"Punch")!
    // character side
    var side : Side = .left {
        didSet {
    if side == .left {
        xScale = 1
        position.x = 70
    } else {
    /* An easy way to flip an asset horizontally is to invert the X-axis scale */
        xScale = -1
        position.x = 252
            }
    // run the punch action
            run(punch)
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    // required init for the subclass to work
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    
}
