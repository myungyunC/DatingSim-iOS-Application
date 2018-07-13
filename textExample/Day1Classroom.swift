//
//  Day1Classroom.swift
//  textExample
//
//  Created by Yoo, Daniel on 8/17/17.
//  Copyright © 2017 Chung, Myungyun. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class Day1Classroom: SKScene {

    let sofiaActuallyMad = SKSpriteNode(imageNamed: "SofiaActuallyMad.png")
    let sofiaMad = SKSpriteNode(imageNamed: "SofiaMad.png")
    let sofiaDefault = SKSpriteNode(imageNamed: "SofiaDefault.png")
    let sofiaAnnoyedBlush = SKSpriteNode(imageNamed: "SofiaAnnoyedBlush.png")
    let sofiaConfidentBlush = SKSpriteNode(imageNamed: "SofiaConfidentBlush.png")
    let sofiaCuteBlush = SKSpriteNode(imageNamed: "SofiaCuteBlush.png")
    
    let mainTextBackground = SKSpriteNode(imageNamed: "MainTextBox.png")                //The main character's (You) textbox image
    let girlTextBackground = SKSpriteNode(imageNamed: "GirlTextBox.png")                //The girl character's (Sofia) textbox image
    let friendTextBackground = SKSpriteNode(imageNamed: "FriendTextBox.png")
    
    var firstOption: FTButtonNode! = nil
    var secondOption: FTButtonNode! = nil
    var thirdOption: FTButtonNode! = nil
    var lastDialogue = 0
    
    
    override func didMove(to view: SKView) {
        spawnPauseButton(scene: self)
        
        //typical
        let back = SKSpriteNode(imageNamed: "Classroom")
        back.size = self.size
        back.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        back.zPosition = 1
        self.addChild(back)
        createSofias()
        createTextBackgrounds()
        
        let wait = SKAction.wait(forDuration: 0.3)
        let action = SKAction.run {
            self.changeTextBackground(changedBackground: self.mainTextBackground)
            self.addTextLabel(labelIn: "The bell rings. Class is over.")
            dialogue += 1
        }
        run(SKAction.sequence([wait,action])) //TIME DELAY ALGORITHM
    }

    
    func createSofias()
    {
        sofiaDefault.zPosition = 0
        sofiaDefault.setScale(4)
        sofiaDefault.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        self.addChild(sofiaDefault)
        
        sofiaAnnoyedBlush.zPosition = 0
        sofiaAnnoyedBlush.setScale(4)
        sofiaAnnoyedBlush.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        self.addChild(sofiaAnnoyedBlush)
        
        sofiaMad.zPosition = 0
        sofiaMad.setScale(4)
        sofiaMad.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        self.addChild(sofiaMad)
        
        sofiaCuteBlush.zPosition = 0
        sofiaCuteBlush.setScale(4)
        sofiaCuteBlush.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        self.addChild(sofiaCuteBlush)
        
        sofiaActuallyMad.zPosition = 0
        sofiaActuallyMad.setScale(4)
        sofiaActuallyMad.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        self.addChild(sofiaActuallyMad)
        
        sofiaConfidentBlush.zPosition = 0
        sofiaConfidentBlush.setScale(4)
        sofiaConfidentBlush.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        self.addChild(sofiaConfidentBlush)
    }
    
    func createTextBackgrounds()
    {
        mainTextBackground.name = "textBack"
        mainTextBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        mainTextBackground.setScale(0.7)
        mainTextBackground.zPosition = 0
        self.addChild(mainTextBackground)
        
        girlTextBackground.name = "textBack"
        girlTextBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        girlTextBackground.setScale(0.7)
        girlTextBackground.zPosition = 0
        self.addChild(girlTextBackground)
        
        friendTextBackground.name = "textBack"
        friendTextBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        friendTextBackground.setScale(0.7)
        friendTextBackground.zPosition = 0
        self.addChild(friendTextBackground)
    }
    
    func moveCharacter(movingCharacter: SKSpriteNode) {                                 //Moves a character into the middle from the left.
        /*
         movingCharacter.setScale(4)
         movingCharacter.zPosition = 3
         self.addChild(movingCharacter)
         */
        
        movingCharacter.position = CGPoint(x: ((self.size.width/2) * -1), y: self.size.height * 0.5)
        movingCharacter.zPosition = 3
        let walkingCharacter = SKAction.moveTo(x: self.size.width/2, duration: 1)
        let walkingSequence = SKAction.sequence([walkingCharacter])
        movingCharacter.run(walkingSequence)
        movingCharacter.name = "currentSofia"
    }
    
    func changePicture(changedPicture: SKSpriteNode) {                                  //Changes the character portrait in the middle
        //self.childNode(withName: "currentSofia")?.removeFromParent()
        //self.addChild(changedPicture)
        self.childNode(withName: "currentSofia")?.zPosition = 0
        self.childNode(withName: "currentSofia")?.name = "notCurrentSofia"
        changedPicture.setScale(4)
        changedPicture.zPosition = 3
        changedPicture.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        changedPicture.name = "currentSofia"
        
    }
    
    func addTextLabel(labelIn: String) {
        //remove last dialogue if it exists
        var lastDialogue = dialogue - 1
        if choice == 1 {
            lastDialogue = dialogue - 3
        }
        else if choice == 2 {
            lastDialogue = dialogue - 2
        }
        else if choice == 3 {
            lastDialogue = dialogue - 1
        }

        else {
            print("WARNING check addtextlabel func")
            print(dialogue)
        }
        
        if let someNodeExist = self.childNode(withName: String(lastDialogue)) {
            print("TRY TO REMOVE LAST OBJ")
            someNodeExist.removeFromParent()
        }
        
        
        //check if node already exists before running
        if self.childNode(withName: String(dialogue)) != nil {
            fastForward = true
        }
        else {
            
            let x = labelNodeObject(textIn: labelIn)
            x.set_position(xIn: Int(self.size.width)/6, yIn: Int(self.size.height)/4)
            self.addChild(x.labelNodeObj)
            x.animate_text()
        }
        
    }
    
    func firstButtonTap() {
        areButtonsActive = false
        
        
        print("First Option Pressed")
        choice = 1
        dialogue += 1
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
        
        if dialogue == 21{
            changePicture(changedPicture: sofiaAnnoyedBlush)
            affectionLevel += 16
            print(affectionLevel)
        }
    }
    
    func secondButtonTap() {
        areButtonsActive = false
        
        print("Second Option Pressed")
        
        
        choice = 2
        dialogue += 2
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
        
        if dialogue == 22 {
            changePicture(changedPicture: sofiaMad)
            affectionLevel += 10
            print(affectionLevel)
        }
        
    }
    
    func thirdButtonTap() {                         //////////HERREeeeeeeeeee
        areButtonsActive = false
        
        
        
        print("Third Option Pressed")
        choice = 3
        dialogue += 3
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
        
        if dialogue == 23 {
            changePicture(changedPicture: sofiaAnnoyedBlush)
            affectionLevel += 4
            print(affectionLevel)
        }
    }
    
    func removeButtons() {
        print("remove here")
        areButtonsActive = false
        self.childNode(withName: "firstOption")?.removeFromParent()
        self.childNode(withName: "secondOption")?.removeFromParent()
        self.childNode(withName: "thirdOption")?.removeFromParent()
        
        var lastDialogue = 0
        if dialogue == 14 {
            lastDialogue = dialogue - 1
        }
        else if dialogue == 15 {
            lastDialogue = dialogue - 2
            
        }
        else if dialogue == 16 {
            lastDialogue = dialogue - 3
        }
            
        else if dialogue == 21 {
            lastDialogue = dialogue - 1
        }
        else if dialogue == 22 {
            lastDialogue = dialogue - 2
            
        }
        else if dialogue == 23 {
            lastDialogue = dialogue - 3
        }

        else {
            print("WARNING check remove buttons function")
            print(dialogue)
        }
        
        if let someNodeExist = self.childNode(withName: String(lastDialogue)) {
            print("TRY TO REMOVE LAST OBJ")
            someNodeExist.removeFromParent()
        }
        
        
        //girlTextBackground.removeFromParent()
    }
    
    func createButtons(option1: NSString, option2: NSString, option3: NSString) {
        
        areButtonsActive = true
        let buttonTexture: SKTexture! = SKTexture(imageNamed: "button.png")
        let buttonTextureSelected: SKTexture! = SKTexture(imageNamed: "buttonSelected.png")
        firstOption = FTButtonNode(normalTexture: buttonTexture, selectedTexture: buttonTextureSelected,disabledTexture: buttonTexture)
        secondOption = FTButtonNode(normalTexture: buttonTexture, selectedTexture: buttonTextureSelected, disabledTexture: buttonTexture)
        thirdOption = FTButtonNode(normalTexture: buttonTexture, selectedTexture: buttonTextureSelected, disabledTexture: buttonTexture)
        
        firstOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(SchoolHallwayScene.firstButtonTap))
        firstOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.4)
        firstOption.zPosition = 6
        firstOption.setButtonLabel(title: option1, font: "DINAlternate-Bold", fontSize: 36)
        firstOption.alpha = 0.0 //sets the color of button to completely transparent
        firstOption.name = "firstOption"
        
        secondOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(SchoolHallwayScene.secondButtonTap))
        secondOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.25)
        secondOption.zPosition = 6
        secondOption.setButtonLabel(title: option2, font: "DINAlternate-Bold", fontSize: 36)
        secondOption.alpha = 0.0
        secondOption.name = "secondOption"
        
        thirdOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(SchoolHallwayScene.thirdButtonTap))
        thirdOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.1)
        thirdOption.zPosition = 6
        thirdOption.setButtonLabel(title: option3, font: "DINAlternate-Bold", fontSize: 36)
        thirdOption.alpha = 0.0
        thirdOption.name = "thirdOption"
        
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        let sequence = SKAction.sequence([fadeIn])
        
        self.addChild(firstOption)
        self.addChild(secondOption)
        self.addChild(thirdOption)
        firstOption.run(sequence)
        secondOption.run(sequence)
        thirdOption.run(sequence)
    }
    
    func changeScene() {
        removePauseButton(scene: self)
        
        dialogue = 1
        textGoing = false                                                               //Boolean for if the text is still typing
        choice = 0
        fastForward = false
        areButtonsActive = false
        
        let sceneToMoveTo = Day2BedroomScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 2.0)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
        
    }
    
    func changeScene(nextScene: SKScene) {
        removePauseButton(scene: self)
        
        dialogue = 1
        textGoing = false                                                               //Boolean for if the text is still typing
        choice = 0
        fastForward = false
        areButtonsActive = false
        
        let sceneToMoveTo = nextScene
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 2.0)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
        
    }
    
    func removeCharacter(movingCharacter: SKSpriteNode) {                                 //Moves a character into the middle from the left.
        
        let walkingCharacter = SKAction.moveTo(x: ((self.size.width/2) * -1), duration: 1)
        
        //        let remove = SKAction(movingCharacter.removeFromParent())
        let walkingSequence = SKAction.sequence([walkingCharacter])
        
        movingCharacter.run(walkingSequence)
    }
    
    func changeTextBackground(changedBackground: SKSpriteNode) {
        self.childNode(withName: "textBack")?.zPosition = 0
        self.childNode(withName: "textBack")?.name = "notTextBack"
        changedBackground.zPosition = 4
        changedBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        changedBackground.name = "textBack"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            
            //button to return home is clicked
            if inPauseButton.contains(pointOfTouch) && pauseBool {
                let x = MainMenu(size: self.size)
                changeScene(nextScene: x)
            }
            
            //pause/resume button clicked
            if pauseButton.contains(pointOfTouch){
                
                if (pauseBool){
                    pauseBool = false
                    
                    removePauseMenu(scene: self)
                    let someNodeExist = self.childNode(withName: "aniText")
                    let movingAction = someNodeExist?.action(forKey: "animatedText")
                    movingAction?.speed = 1
                }
                else{
                    spawnPauseMenu(scene: self)
                    //                    let text =
                    let someNodeExist = self.childNode(withName: "aniText")
                    let movingAction = someNodeExist?.action(forKey: "animatedText")
                    movingAction?.speed = 0
                }
            }

            
            else if (pointOfTouch.x < gameArea.maxX && !areButtonsActive && !pauseBool) {
                    switch (pointOfTouch.x < gameArea.maxX && !areButtonsActive) {
                    case dialogue == 2:
                        addTextLabel(labelIn: "\"Ah... Shoot. I must've slept through class.\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 3:
                        addTextLabel(labelIn: "\"Why do I even bother coming to class?\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 4:
                        addTextLabel(labelIn: "\"My parents are never home...")
                        dialogue += 1
                        break
                        
                    case dialogue == 5:
                        addTextLabel(labelIn: "and I get straight A's without studying...")
                        dialogue += 1
                        break
                        
                    case dialogue == 6:
                        addTextLabel(labelIn: "like every main character in any anime ever.\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 7:
                        changeTextBackground(changedBackground: friendTextBackground)
                        addTextLabel(labelIn: "\"Hey man, what's cooking?\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 8:
                        changeTextBackground(changedBackground: mainTextBackground)
                        addTextLabel(labelIn: "Ah... It's George.")
                        dialogue += 1
                        break
                        
                    case dialogue == 9:
                        addTextLabel(labelIn: "I don't like George nor do I dislike George.")
                        dialogue += 1
                        break
                        
                    case dialogue == 10:
                        addTextLabel(labelIn: "He's just kinda there, which is alright.")
                        dialogue += 1
                        break
                        
                    case dialogue == 11:
                        changeTextBackground(changedBackground: friendTextBackground)
                        addTextLabel(labelIn: "\"Late to class again? Every time!\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 12:
                        addTextLabel(labelIn: "\"What are you up to tonight? Let's hang!\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 13:
                        changeTextBackground(changedBackground: mainTextBackground)
                        addTextLabel(labelIn: "Dang... I don't want to, what do I say?")
                        createButtons(option1: "\"It's a full moon tonight so I can't..\"", option2: "\"I literally hate you.\"", option3: "\"I'd love to but I'm working.\"")
                        break
                        
                    case dialogue == 14:
                        changeTextBackground(changedBackground: friendTextBackground)
                        bfPoints += 10
                        addTextLabel(labelIn: "\"Oh no! Are you gonna go crazy?!\"")
                        dialogue += 3
                        break
                        
                    case dialogue == 15:
                        changeTextBackground(changedBackground: friendTextBackground)
                        bfPoints += 4
                        addTextLabel(labelIn: "\"HAHAHA... your jokes are so mean man.\"")
                        dialogue += 2
                        break
                        
                    case dialogue == 16:
                        changeTextBackground(changedBackground: friendTextBackground)
                        bfPoints += 16
                        addTextLabel(labelIn: "\"Awww bummer.\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 17:
                        addTextLabel(labelIn: "\"Okay well, I gotta catch the bus.\"")
                        choice = 0
                        dialogue += 1
                        break
                        
                    case dialogue == 18:
                        addTextLabel(labelIn: "\"I'll see you tomorrow!\"")
                        choice = 0
                        dialogue += 1
                        break
                        
                    case dialogue == 19:
                        changeTextBackground(changedBackground: mainTextBackground)
                        addTextLabel(labelIn: "I pack up my things to head out but then...")
                        dialogue += 1
                        break
                        
                    case dialogue == 20:
                        changeTextBackground(changedBackground: girlTextBackground)
                        moveCharacter(movingCharacter: sofiaDefault)
                        addTextLabel(labelIn: "\"Hey!! I have something to tell you…\"")
                        createButtons(option1: "\"Spare me Satan!\"", option2: "\"I skipped cleaning duties yesterday...\"", option3: "make a break for it*")
                        break
                        
                    case dialogue == 21:
                        changeTextBackground(changedBackground: girlTextBackground)
                        addTextLabel(labelIn: "\"Don't worry. I'm not here to yell at you.\"")
                        dialogue += 3
                        break
                        
                    case dialogue == 22:
                        changeTextBackground(changedBackground: girlTextBackground)
                        addTextLabel(labelIn: "\"...wait what. Ugh, never mind that.\"")
                        print(dialogue)
                        dialogue += 2
                        break
                        
                    case dialogue == 23:
                        changeTextBackground(changedBackground: girlTextBackground)
                        addTextLabel(labelIn: "grabs you by the hand* \"Please don’t run!\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 24:
                        changePicture(changedPicture: sofiaAnnoyedBlush)
                        addTextLabel(labelIn: "\"Sorry for being so rude this morning…")
                        choice = 0
                        dialogue += 1
                        break
                        
                    case dialogue == 25:
                        changePicture(changedPicture: sofiaDefault)
                        addTextLabel(labelIn: "I know you get good grades and all but...")
                        dialogue += 1
                        break
                        
                    case dialogue == 26:
                        changePicture(changedPicture: sofiaCuteBlush)
                        addTextLabel(labelIn: "I wish you cared about yourself a bit more.\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 27:
                        changeTextBackground(changedBackground: mainTextBackground)
                        addTextLabel(labelIn: "Wow. Sudden character development.")
                        dialogue += 1
                        break
                        
                    case dialogue == 28:
                        changeTextBackground(changedBackground: girlTextBackground)
                        changePicture(changedPicture: sofiaConfidentBlush)
                        addTextLabel(labelIn: "\"Anyways, I have a meeting so I have to go...")
                        dialogue += 1
                        break
                        
                    case dialogue == 29:
                        addTextLabel(labelIn: "I’ll expect you to be on time tomorrow!\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 30:
                        removeCharacter(movingCharacter: self.childNode(withName: "currentSofia") as! SKSpriteNode)
                        changeTextBackground(changedBackground: mainTextBackground)
                        addTextLabel(labelIn: "She turns around and dashes into the hallway.")
                        dialogue += 1
                        break
                        
                    case dialogue == 31:
                        addTextLabel(labelIn: "You know what Prez? You ain't half bad.")
                        dialogue += 1
                        break
                        
                    case dialogue == 32:
                        addTextLabel(labelIn: "I'm stayin up late again cause yolo right?")
                        dialogue += 1
                        break
                        
                    case dialogue == 33:
                        changeScene()
                        break
                        
                    default:
                        print(dialogue)
                        break
                        
                        
                    }
                }
            
        }
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
