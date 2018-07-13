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



class ResumeMenu: SKScene {
    

    var firstOption: FTButtonNode! = nil
    var secondOption: FTButtonNode! = nil
    var thirdOption: FTButtonNode! = nil
    var fourthOption: FTButtonNode! = nil
    
    var returnHome: FTButtonNode! = nil

    let lock1 = SKSpriteNode(imageNamed: "templock")
    let lock2 = SKSpriteNode(imageNamed: "templock")
    let lock3 = SKSpriteNode(imageNamed: "templock")
    let lock4 = SKSpriteNode(imageNamed: "templock")

    
    
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
    
    
    func firstButtonTap() {
            let x = OpeningScene(size: self.size)
            changeScene(nextScene: x)
        
    }
    
    func secondButtonTap() {
            let x = Day2BedroomScene(size: self.size)
            changeScene(nextScene: x)
        
    }
    
    func thirdButtonTap() {
            let x = Day3BedroomScene(size:self.size)
            changeScene(nextScene: x)
        
    }
    
    
    
    func fourthButtonTap() {
        if (Day4SaveOver100) {
            let x = Day4BedroomOver(size: self.size)
            changeScene(nextScene: x)
        }
        else {
            let x = Day4BedroomUnder(size: self.size)
            changeScene(nextScene: x)
        }
        
    }
    
    func returnButtonTap() {
        let x = MainMenu(size:self.size)
        changeScene(nextScene: x)
        
    }
    
    
    func createButtons(option1: NSString, option2: NSString, option3: NSString, option4: NSString, option5: NSString) {
        
        let buttonTexture: SKTexture! = SKTexture(imageNamed: "button.png")
        let buttonTextureSelected: SKTexture! = SKTexture(imageNamed: "buttonSelected.png")
        firstOption = FTButtonNode(normalTexture: buttonTexture, selectedTexture: buttonTextureSelected,disabledTexture: buttonTexture)
        secondOption = FTButtonNode(normalTexture: buttonTexture, selectedTexture: buttonTextureSelected, disabledTexture: buttonTexture)
        thirdOption = FTButtonNode(normalTexture: buttonTexture, selectedTexture: buttonTextureSelected, disabledTexture: buttonTexture)
        fourthOption = FTButtonNode(normalTexture: buttonTexture, selectedTexture: buttonTextureSelected, disabledTexture: buttonTexture)
        returnHome = FTButtonNode(normalTexture: buttonTexture, selectedTexture: buttonTextureSelected, disabledTexture: buttonTexture)

        
        firstOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(ResumeMenu.firstButtonTap))
        firstOption.position = CGPoint(x: self.frame.midX*0.7, y: self.frame.midY * 1.3)
        firstOption.zPosition = 6
        firstOption.setButtonLabel(title: option1, font: "DINAlternate-Bold", fontSize: 36)
        firstOption.alpha = 1 //sets the color of button to completely transparent
        firstOption.size.width = 400
        firstOption.size.height = 400
        firstOption.name = "firstOption"
        
        secondOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(ResumeMenu.secondButtonTap))
        secondOption.position = CGPoint(x: self.frame.midX*1.3, y: self.frame.midY * 1.3)
        secondOption.zPosition = 6
        secondOption.setButtonLabel(title: option2, font: "DINAlternate-Bold", fontSize: 36)
        secondOption.alpha = 1
        secondOption.size.width = 400
        secondOption.size.height = 400
        secondOption.name = "secondOption"
        
        thirdOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(ResumeMenu.thirdButtonTap))
        thirdOption.position = CGPoint(x: self.frame.midX*0.7, y: self.frame.midY * 0.8)
        thirdOption.zPosition = 6
        thirdOption.setButtonLabel(title: option3, font: "DINAlternate-Bold", fontSize: 36)
        thirdOption.alpha = 1
        thirdOption.size.width = 400
        thirdOption.size.height = 400
        thirdOption.name = "thirdOption"
        
        fourthOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(ResumeMenu.fourthButtonTap))
        fourthOption.position = CGPoint(x: self.frame.midX*1.3, y: self.frame.midY * 0.8)
        fourthOption.zPosition = 6
        fourthOption.setButtonLabel(title: option4, font: "DINAlternate-Bold", fontSize: 36)
        fourthOption.alpha = 1
        fourthOption.size.width = 400
        fourthOption.size.height = 400
        fourthOption.name = "fourthOption"
        
        returnHome.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(ResumeMenu.returnButtonTap))
        returnHome.position = CGPoint(x: self.frame.midX*0.5, y: self.frame.midY * 1.9)
        returnHome.zPosition = 6
        returnHome.setButtonLabel(title: option5, font: "DINAlternate-Bold", fontSize: 36)
        returnHome.alpha = 1
        returnHome.size.width = 300
        returnHome.size.height = 100
        returnHome.name = "returnHome"
        
        
        if (!Day1Save) {
            lock1.size.width = 400
            lock1.size.height = 400
            lock1.position = CGPoint(x: self.frame.midX*0.7, y: self.frame.midY * 1.3)
            lock1.zPosition = 7
            lock1.alpha = 0.5
            self.addChild(lock1)
        }
        if (!Day2Save) {
            lock2.size.width = 400
            lock2.size.height = 400
            lock2.position = CGPoint(x: self.frame.midX*1.3, y: self.frame.midY * 1.3)
            lock2.zPosition = 7
            lock2.alpha = 0.5
            self.addChild(lock2)
        }
        if (!Day3Save) {
            lock3.size.width = 400
            lock3.size.height = 400
            lock3.position = CGPoint(x: self.frame.midX*0.7, y: self.frame.midY * 0.8)
            lock3.zPosition = 7
            lock3.alpha = 0.5
            self.addChild(lock3)
        }
        if !(Day4SaveOver100 || Day4SaveUnder100) {
            lock4.size.width = 400
            lock4.size.height = 400
            lock4.position = CGPoint(x: self.frame.midX*1.3, y: self.frame.midY * 0.8)
            lock4.zPosition = 7
            lock4.alpha = 0.5
            self.addChild(lock4)
        }
        
        self.addChild(fourthOption)
        self.addChild(thirdOption)
        self.addChild(secondOption)
        self.addChild(firstOption)
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
        
        createButtons(option1: "Day 1", option2: "Day 2", option3: "Day 3", option4: "Day 4", option5: "RETURN")
        
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
