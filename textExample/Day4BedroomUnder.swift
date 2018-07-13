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


class Day4BedroomUnder: SKScene {
    
    //Value that touchesBegan picks cases from
    let sofiaDefault = SKSpriteNode(imageNamed: "BadEnd")                     //The girl's default picture
    var timer : Timer!                                                                  //The timer that will loop through the selector function.
    var timer2 : Timer!
    var firstOption: FTButtonNode! = nil
    var secondOption: FTButtonNode! = nil
    var thirdOption: FTButtonNode! = nil
    
    let mainTextBackground = SKSpriteNode(imageNamed: "MainTextBox.png")                //The main character's (You) textbox image
    let girlTextBackground = SKSpriteNode(imageNamed: "GirlTextBox.png")                //The girl character's (Sofia) textbox image
    
    func createSofias()
    {
        sofiaDefault.zPosition = 0
        sofiaDefault.setScale(4)
        sofiaDefault.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        self.addChild(sofiaDefault)
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
    
    
    
    func removeCharacter(movingCharacter: SKSpriteNode) {                                 //Moves a character into the middle from the left.
        
        let walkingCharacter = SKAction.moveTo(x: ((self.size.width/2) * -1), duration: 1)
        
        //        let remove = SKAction(movingCharacter.removeFromParent())
        let walkingSequence = SKAction.sequence([walkingCharacter])
        
        movingCharacter.run(walkingSequence)
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

    
    func waitObjects(function: SKAction) {
        let wait = SKAction.wait(forDuration: 1.0) //TIME DELAY ALGORITHM
        let sequence = SKAction.sequence([wait, function])
        self.run(sequence)
    }
    
    
    func firstButtonTap() {
        areButtonsActive = false
        
        
        print("First Option Pressed")
        choice = 1
        dialogue += 1
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
    }
    
    func secondButtonTap() {
        areButtonsActive = false
        
        print("Second Option Pressed")
        
        
        choice = 2
        dialogue += 2
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
    }
    
    func thirdButtonTap() {
        areButtonsActive = false
        
        
        
        print("Third Option Pressed")
        choice = 3
        dialogue += 3
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
    }
    
    func removeButtons() {
        print("remove here")
        areButtonsActive = false
        self.childNode(withName: "firstOption")?.removeFromParent()
        self.childNode(withName: "secondOption")?.removeFromParent()
        self.childNode(withName: "thirdOption")?.removeFromParent()
        
        var lastDialogue = 0
        if dialogue == 9 {
            lastDialogue = dialogue - 1
            
            
        }
        else if dialogue == 10 {
            lastDialogue = dialogue - 2
            
        }
        else if dialogue == 11 {
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
        
        firstOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Day4BedroomUnder.firstButtonTap))
        firstOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.4)
        firstOption.zPosition = 6
        firstOption.setButtonLabel(title: option1, font: "DINAlternate-Bold", fontSize: 36)
        firstOption.alpha = 0.0 //sets the color of button to completely transparent
        firstOption.name = "firstOption"
        
        secondOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Day4BedroomUnder.secondButtonTap))
        secondOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.25)
        secondOption.zPosition = 6
        secondOption.setButtonLabel(title: option2, font: "DINAlternate-Bold", fontSize: 36)
        secondOption.alpha = 0.0
        secondOption.name = "secondOption"
        
        thirdOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Day4BedroomUnder.thirdButtonTap))
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
    
    override func didMove(to view: SKView) {
        Day4SaveUnder100 = true
        Day4SaveOver100 = false
        
        spawnPauseButton(scene: self)
        
        createSofias()
        createTextBackgrounds()
        
        let back = SKSpriteNode(imageNamed: "room")
        back.size = self.size
        back.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        back.zPosition = 1
        self.addChild(back)
        
        let wait = SKAction.wait(forDuration: 0.5)
        let action = SKAction.run{
            self.changeTextBackground(changedBackground: self.mainTextBackground)
            self.addTextLabel(labelIn: "You wake up naturally, the best.")
            dialogue += 1
        }
        run(SKAction.sequence([wait, action]))
    }
    
    let gameArea: CGRect
    
    
    
    // REQUIRES: String, labelIn, for whatever dialogue you want
    // EFFECTS:  Builds a labelNodeObject, sets its position, adds it as childNode to scene,
    //           and animates the dialogue text.
    //           Remove last SKLabelNode if applicable.
    //           Don't create duplicate node if a node already exists.
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
            lastDialogue = dialogue - 1
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
                    
                }
                else{
                    spawnPauseMenu(scene: self)
                    //                    let text =
                    
                }
            }
            
            else if (pointOfTouch.x < gameArea.maxX && !areButtonsActive && !pauseBool) {
                switch (pointOfTouch.x < gameArea.maxX && !areButtonsActive) {
                    
                case(dialogue == 2) :
                    
                    addTextLabel(labelIn: "You check the time and it's 11:00AM.")
                    dialogue += 1
                    break;
                    
                case(dialogue == 3) :
                    addTextLabel(labelIn: "\"I wonder what Sofia is up to.\"")
                    dialogue += 1
                    break;
                    
                case(dialogue == 4) :
                    addTextLabel(labelIn: "\"Should I text her or call her? hm...\"")
                    dialogue += 1
                    break;
                    
                case(dialogue == 5) :
                    addTextLabel(labelIn: "\"I'll just call her, she calls me first.\"")
                    dialogue += 1
                    break;
                    
                case(dialogue == 6) :
                    addTextLabel(labelIn: "You dial her number and wait patiently.")
                    dialogue += 1
                    break;
                    
                case(dialogue == 7) :
                    changeTextBackground(changedBackground: girlTextBackground)
                    addTextLabel(labelIn: "\"Hello? Why'd you call?\"")
                    dialogue += 1
                    break;
                    
                case(dialogue == 8) :
                    changeTextBackground(changedBackground: mainTextBackground)
                    addTextLabel(labelIn: "\"Hey, I just wanted to know what's up.\"")
                    dialogue += 1
                    break;
                    
                case dialogue == 9:
                    changeTextBackground(changedBackground: girlTextBackground)
                    addTextLabel(labelIn: "\"Sorry, but I don't want to talk anymore.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 10:
                    addTextLabel(labelIn: "\"It's over between us. It can't happen.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 11:
                    addTextLabel(labelIn: "\"I hate nerds who lose.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 12:
                    changeTextBackground(changedBackground: mainTextBackground)
                    addTextLabel(labelIn: "The phone hangs up.")
                    dialogue += 1
                    break
                    
                case dialogue == 13:
                    addTextLabel(labelIn: "\"Alright, bet.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 14:
                    addTextLabel(labelIn: "You never saw her again at school.")
                    dialogue += 1
                    break
                    
                case dialogue == 15:
                    addTextLabel(labelIn: "You spent the rest of your days alone.")
                    dialogue += 1
                    break
                    
                case dialogue == 16:
                    addTextLabel(labelIn: "Living as a hermit. Level 70, Avenger.")
                    dialogue += 1
                    break
                    
                case dialogue == 17:
                    addTextLabel(labelIn: "Flash Jump. Haste. Lucky Se7en.")
                    dialogue += 1
                    break
                    
                case dialogue == 18:
                    addTextLabel(labelIn: "Game over man. You didn't get her.")
                    dialogue += 1
                    break
                    
                case dialogue == 19:
                    let x = Final_Lose(size: self.size)
                    changeScene(nextScene: x)
                    print("success")
                    print(dialogue)
                    break
                    
                default:
                    break;
                }
            }
            
        }
    }
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
