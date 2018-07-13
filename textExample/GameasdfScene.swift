//
//  datingsim.swift
//  Boss Apha
//
//  Created by Chung, Myungyun on 5/9/17.
//  Copyright © 2017 DOZ. All rights reserved.
//

import SpriteKit

import GameplayKit


class GameScene: SKScene {
    
    let testText = SKLabelNode(fontNamed: "The Bold Font")
    let text2 = SKLabelNode(fontNamed: "The Bold Font")
    let text3 = SKLabelNode(fontNamed: "The Bold Font")
    let text4 = SKLabelNode(fontNamed: "The Bold Font")
    let text5 = SKLabelNode(fontNamed: "The Bold Font")
    let textBackground = SKSpriteNode(imageNamed: "textbox.png")
    let aobaOikawa = SKSpriteNode(imageNamed: "Oikawa.png")

    var areButtonsActive = false
    var dialogue = 0;
    
    func createLabel(theText: SKLabelNode) //ALL THE REQUIREMENTS OF AN SKLABELNODE
    {
        theText.fontSize = 50
        theText.fontColor = SKColor.black
        theText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        theText.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        theText.zPosition = 3
        textBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        textBackground.setScale(0.5)
        textBackground.zPosition = 2
        self.addChild(textBackground)
        
    }
    
    func moveCharacter() {
        
        aobaOikawa.setScale(4)
        aobaOikawa.zPosition = 1
        self.addChild(aobaOikawa)
        aobaOikawa.position = CGPoint(x: ((self.size.width/2) * -1), y: self.size.height * 0.5)
        let walkingCharacter = SKAction.moveTo(x: self.size.width/2, duration: 1)
        
        let walkingSequence = SKAction.sequence([walkingCharacter])
        aobaOikawa.run(walkingSequence)
        
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "room")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0  //layering of objects, lower = back.
        self.addChild(background)
        
        testText.fontSize = 50
        testText.fontColor = SKColor.black
        testText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        testText.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        testText.zPosition = 3
        text2.fontSize = 50
        text2.fontColor = SKColor.black
        text2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        text2.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        text2.zPosition = 3
        textBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        textBackground.setScale(0.5)
        textBackground.zPosition = 2
        
        let fadeIn = SKAction.fadeIn(withDuration: 1.5)
        let sequence = SKAction.sequence([fadeIn])
        textBackground.alpha = 0.0
        textBackground.run(sequence)
        /*
        let wait = SKAction.wait(forDuration: 1.0) //TIME DELAY ALGORITHM
        let action = SKAction.run {
            self.testText.animate(newText: "I guess I'm late for school again...", characterDelay: 0.05)
            self.addChild(self.textBackground)
        }
        run(SKAction.sequence([wait,action])) //TIME DELAY ALGORITHM
        */
        
        moveCharacter()
        self.addChild(testText)
        
    }
    
    func runTestText1(){
        testText.removeFromParent()
        
        //createLabel(theText: text2)
        //text2.animate(newText: "Testing", characterDelay: 0.05)
        self.addChild(text2)
    }
    
    func runTestText2() {
        text2.removeFromParent()
        //testText.animate(newText: "yolooooooooo", characterDelay: 0.05)
        self.addChild(testText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            if (pointOfTouch.x < gameArea.maxX && areButtonsActive == false) {
                if dialogue == 0 {
                    runTestText1()
                    dialogue += 2
                }
                else if dialogue == 2 {
                    runTestText2()
                    dialogue+=1
                }
            }

            
        }
    }
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func changeScene() {
        
        let sceneToMoveTo = SchoolHallwayScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 2.0)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
        
    }

    
    let gameArea: CGRect
    override init(size: CGSize) { //creates a visible rectangle for the playable space on all devices
        
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
