//
//  SchoolHallwayScene.swift
//  textExample
//
//  Created by Yoo, Daniel on 5/24/17.
//  Copyright © 2017 Chung, Myungyun. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
//import SKMultilineLabel.swift

//Boolean for if buttons are currently on the screen

//var dummyName = 0



class Credits: SKScene {
    
    
    var returnHome: FTButtonNode! = nil

    
    
    
    
    func waitObjects(function: SKAction) {
        let wait = SKAction.wait(forDuration: 1.0) //TIME DELAY ALGORITHM
        let sequence = SKAction.sequence([wait, function])
        self.run(sequence)
    }
    
    func changeScene(nextScene: SKScene) {
        
        let sceneToMoveTo = nextScene
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 2.0)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
        
    }
    

    
    
    func returnButtonTap() {
        let x = MainMenu(size:self.size)
        changeScene(nextScene: x)
        
    }
    
    
    func createButtons(option1: NSString) {
        
        let buttonTexture: SKTexture! = SKTexture(imageNamed: "button.png")
        let buttonTextureSelected: SKTexture! = SKTexture(imageNamed: "buttonSelected.png")
        returnHome = FTButtonNode(normalTexture: buttonTexture, selectedTexture: buttonTextureSelected, disabledTexture: buttonTexture)
                returnHome.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(ResumeMenu.returnButtonTap))
        returnHome.position = CGPoint(x: self.frame.midX*0.5, y: self.frame.midY * 1.9)
        returnHome.zPosition = 6
        returnHome.setButtonLabel(title: option1, font: "DINAlternate-Bold", fontSize: 36)
        returnHome.alpha = 1
        returnHome.size.width = 300
        returnHome.size.height = 100
        returnHome.name = "returnHome"
        
        self.addChild(returnHome)
        
        //to lock the level, just put skspritenode over buttons, so user can't touch the buttons.
        
        
    }
    
    override func didMove(to view: SKView) {
        let back = SKSpriteNode(imageNamed: "JEBackground")
        back.size = self.size
        back.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        back.zPosition = 1
        self.addChild(back)
        
        //        var title = SKLabelNode()
        //        title.fontName = "The Bold Font"
        //        title.fontSize = 100
        //        title.fontColor = SKColor.white
        //        title.zPosition = 3
        //        title.text = "THE BEST DATING SIM"
        //        title.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        //        title.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
        //        self.addChild(title)
        
        createButtons(option1: "RETURN")
        
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
