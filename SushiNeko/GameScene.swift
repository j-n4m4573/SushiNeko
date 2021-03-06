//
//  GameScene.swift
//  SushiNeko
//
//  Created by Jamar Gibbs on 9/23/18.
//  Copyright © 2018 B3773R. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Side {
    case left, right, none
}

class GameScene: SKScene {

    var sushiBasePiece : SushiPiece!
    var character: Character!
    var sushiTower: [SushiPiece] = []
    var healthBar: SKSpriteNode!
    var state : GameState = .title
    var playButton : MSButtonNode!
    var scoreLabel : SKLabelNode!
    var score : Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    var health : CGFloat = 1.0 {
        didSet {
            // scale health bar between 0.0 -> 0.1 e.g
            healthBar.xScale = health
            if health > 1.0 { health = 1.0 }
        }
    }
    
    
    enum GameState {
        case title, ready, playing, gameOver
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // connect game objects
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        character = childNode(withName: "character") as! Character
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        playButton = childNode(withName: "playButton") as! MSButtonNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        
        // setup sushi connections
        sushiBasePiece.connectChopsticks()
        
        // manually stack the start of the tower
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        
        // add random pieces to the scene
        addRandomPieces(total: 10)
        
        // setup play button selection handler
        playButton.selectedHandler = {
            // Start Game
            self.state = .ready
        }
    }
    
    
    
    func addTowerPiece(side: Side) {
        // add a new piece to the sushi tower
        
        // copy original sushi piece
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        // acess last piece properties
        let lastPiece = sushiTower.last
        
        // add on top of the last piece, default on first piece
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 55
        
        // increment z to make sure that it is on top of the last piece, default on first piece
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        
        // set side
        newPiece.side = side
        
        // add sushi to scene
        addChild(newPiece)
        
        // add sushi piece to sushi tower
        sushiTower.append(newPiece)
    }

    func addRandomPieces(total: Int) {
        // add random pieces to the sushi tower
        for _ in 1...total {
            // need to access last piece properties
            let lastPiece = sushiTower.last!
            
            // need to ensure we dont create impossible sushi structures
            if lastPiece.side != .none {
                addTowerPiece(side: .none)
            } else {
                // random number generator
                let rand = arc4random_uniform(100)
                if rand < 45 {
                    // 45% chance of a left piece
                    addTowerPiece(side: .left)
                } else if rand < 90 {
                    // 45% chance of a right piece
                    addTowerPiece(side: .right)
                } else {
                    // 10% chance of a empty piece
                    addTowerPiece(side: .none)
                }
            }
        }
    }
    
    func moveTowerDown(){
        var n : CGFloat = 0
        for piece in sushiTower {
            let y = (n * 55) + 215
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        // game not ready to play
        if state == .gameOver || state == .title {return}
        // game begins on first touch
        if state == .ready {state = .playing }
        
        // first touch
        let touch = touches.first!
        // get touch position on the screen
        let location = touch.location(in: self)
        // was touch on left hand side or right hand side
        if location.x > size.width / 2 {
            character.side = .right
        } else {
            character.side = .left
        }
        // grab sushi piece on top of the base sushi piece, it will always be 'first'
        if let firstPiece = sushiTower.first as SushiPiece? {
            
            // check character side against sushi piece side (collision check)
            if character.side == firstPiece.side {
                gameOver()
                return
            }
            
            // increment health
            health += 0.1
            
            // increment score
            score += 1
            
            // remove from sushi tower array
            sushiTower.removeFirst()
            
            // animate the punched sushi piece
            firstPiece.flip(character.side)
            
            // add a new sushi piece to the top of the sushi tower
            addRandomPieces(total: 1)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveTowerDown()
        
        // called before each frame is rendered
        if state != .playing { return }
        
        // decrease health
        health -= 0.01
        
        // has the player ran out of health?
        if health < 0 {
            gameOver()
        }
    }
    
    func gameOver() {
        state = .gameOver
        
        // create turnRed SKAction
        let turnRed = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.50)
        // turn all the sushi pieces red
        sushiBasePiece.run(turnRed)
        for sushiPiece in sushiTower {
            sushiPiece.run(turnRed)
        }
        
        // make the player turn red
        character.run(turnRed)
        
        // change the play button selection handler
        playButton.selectedHandler = {
            // grab refrence to the SpriteKit view
            let skView = self.view as SKView?
            
            // load Game Scene
            guard let scene = GameScene(fileNamed:"GameScene") as GameScene? else {
                return
        }
            // ensure correct aspect mode
            scene.scaleMode = .aspectFill
            
            // restart GameScene
            skView?.presentScene(scene)
        }
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}



