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



class Day3RestaurantScene: SKScene {
    
    //Value that touchesBegan picks cases from
    let sofiaDefault = SKSpriteNode(imageNamed: "SofiaDefault.png")                     //The girl's default picture
    let sofiaAnnoyedBlush = SKSpriteNode(imageNamed: "SofiaAnnoyedBlush.png")           //The girl's blush picture
    let sofiaCuteBlush = SKSpriteNode(imageNamed: "SofiaCuteBlush.png")
    let sofiaMad = SKSpriteNode(imageNamed: "SofiaMad.png")
    let sofiaActuallyMad = SKSpriteNode(imageNamed: "SofiaActuallyMad")
    let sofiaConfidentBlush = SKSpriteNode(imageNamed: "SofiaConfidentBlush")
    let sofiaConfidentNervous = SKSpriteNode(imageNamed: "SofiaConfidentNervous")
    let sofiaCasualHappy = SKSpriteNode(imageNamed: "SofiaCasualHappy")
    
    let mainTextBackground = SKSpriteNode(imageNamed: "MainTextBox.png")                //The main character's (You) textbox image
    let girlTextBackground = SKSpriteNode(imageNamed: "GirlTextBox.png")                //The girl character's (Sofia) textbox image
    
    
    var timer : Timer!                                                                  //The timer that will loop through the selector function.
    var timer2 : Timer!
    var firstOption: FTButtonNode! = nil
    var secondOption: FTButtonNode! = nil
    var thirdOption: FTButtonNode! = nil
    
    
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
        
        sofiaConfidentNervous.zPosition = 0
        sofiaConfidentNervous.setScale(4)
        sofiaConfidentNervous.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        self.addChild(sofiaConfidentNervous)
        
        sofiaCasualHappy.zPosition = 0
        sofiaCasualHappy.setScale(4)
        sofiaCasualHappy.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        self.addChild(sofiaCasualHappy)
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
        let transition = SKTransition.fade(withDuration: 4.0)
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
        if dialogue == 5 {
            changePicture(changedPicture: sofiaCuteBlush)
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
        if dialogue == 6 {
            changePicture(changedPicture: sofiaMad)
            affectionLevel += 4
            print(affectionLevel)
        }
        
    }
    
    func thirdButtonTap() {
        areButtonsActive = false
        
        
        
        print("Third Option Pressed")
        choice = 3
        dialogue += 3
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
        if dialogue == 7 {
            changePicture(changedPicture: sofiaDefault)
            affectionLevel += 10
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
        if dialogue == 5 {
            lastDialogue = dialogue - 1
        }
        else if dialogue == 6 {
            lastDialogue = dialogue - 2
        }
        else if dialogue == 7 {
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
        
        firstOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Day3RestaurantScene.firstButtonTap))
        firstOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.4)
        firstOption.zPosition = 6
        firstOption.setButtonLabel(title: option1, font: "DINAlternate-Bold", fontSize: 36)
        firstOption.alpha = 0.0 //sets the color of button to completely transparent
        firstOption.name = "firstOption"
        
        secondOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Day3RestaurantScene.secondButtonTap))
        secondOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.25)
        secondOption.zPosition = 6
        secondOption.setButtonLabel(title: option2, font: "DINAlternate-Bold", fontSize: 36)
        secondOption.alpha = 0.0
        secondOption.name = "secondOption"
        
        thirdOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Day3RestaurantScene.thirdButtonTap))
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
        spawnPauseButton(scene: self)
        
        createSofias()
        createTextBackgrounds()
        
        let back = SKSpriteNode(imageNamed: "restaurant")
        back.size = self.size
        back.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        back.zPosition = 1
        self.addChild(back)
        
        let wait = SKAction.wait(forDuration: 0.5)
        let action = SKAction.run {
            self.changeTextBackground(changedBackground: self.mainTextBackground)
            self.addTextLabel(labelIn: "You get to the resturaunt but don't see her.")
            dialogue += 1
        }
        run(SKAction.sequence([wait,action]))
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
                    addTextLabel(labelIn: "\"zzz... Why didn't you pick an exact time...\"")
                    dialogue += 1
                    break;
                    
                case(dialogue == 3) :
                    addTextLabel(labelIn: "She comes running in, panting for air.")
                    dialogue += 1
                    break;
                    
                case(dialogue == 4) :
                    changeTextBackground(changedBackground: girlTextBackground)
                    moveCharacter(movingCharacter: sofiaActuallyMad)
                    addTextLabel(labelIn: "\"Sorry! I hope I didn't make you wait long...\"")
                    createButtons(option1: "\"No it's okay, I just got here.\"", option2: "\"That's 5 minutes I'm never getting back.\"", option3: "\"Oh don't worry, I wanted to beat you.\"")
                    break;
                    
                case(dialogue == 5) :
                    changeTextBackground(changedBackground: girlTextBackground)
                    addTextLabel(labelIn: "\"Oh okay. I'm glad haha.\"")
                    dialogue += 3
                    break;
                    
                case(dialogue == 6) :
                    changeTextBackground(changedBackground: girlTextBackground)
                    addTextLabel(labelIn: "\"I'm sorryyy. The bus was late.\"")
                    dialogue += 2
                    break;
                    
                case(dialogue == 7) :
                    changeTextBackground(changedBackground: girlTextBackground)
                    addTextLabel(labelIn: "\"Well, you beat me. Congrats.\"")
                    dialogue += 1
                    break;
                    
                case(dialogue == 8) :
                    changePicture(changedPicture: sofiaConfidentNervous)
                    addTextLabel(labelIn: "\"Don't worry, I'll order for us both.\"")
                    choice = 0
                    dialogue += 1
                    break;
                    
                case dialogue == 9:
                    changePicture(changedPicture: sofiaDefault)
                    addTextLabel(labelIn: "\"TWO BEEF PAD THAIS DIM MAK PLEASE\"")
                    dialogue += 1
                    break
                    
                case dialogue == 10:
                    changeTextBackground(changedBackground: mainTextBackground)
                    addTextLabel(labelIn: "Gosh. She's the worst kind of customer.")
                    dialogue += 1
                    break
                    
                case dialogue == 11:
                    changeTextBackground(changedBackground: girlTextBackground)
                    changePicture(changedPicture: sofiaConfidentBlush)
                    addTextLabel(labelIn: "\"You know, I'm quite interested in you.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 12:
                    changePicture(changedPicture: sofiaDefault)
                    addTextLabel(labelIn: "\"Why don't you study at all?\"")
                    dialogue += 1
                    break
                    
                case dialogue == 13:
                    changeTextBackground(changedBackground: mainTextBackground)
                    addTextLabel(labelIn: "\"I just instantly understand stuff in...")
                    dialogue += 1
                    break
                    
                case dialogue == 14:
                    addTextLabel(labelIn: "class. I'm basically a genius.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 15:
                    changeTextBackground(changedBackground: girlTextBackground)
                    addTextLabel(labelIn: "\"Wow. aren't you modest.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 16:
                    changePicture(changedPicture: sofiaCasualHappy)
                    addTextLabel(labelIn: "\"Haha, but you're a pretty funny guy.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 17:
                    changeTextBackground(changedBackground: mainTextBackground)
                    changePicture(changedPicture: sofiaCuteBlush)
                    addTextLabel(labelIn: "She looks at you straight in the eyes.")
                    dialogue += 1
                    break
                    
                case dialogue == 18:
                    addTextLabel(labelIn: "Oh no. It's not happening again, is it?")
                    dialogue += 1
                    break
                    
                case dialogue == 19:
                    let x = pre_boss_L2(size: self.size)
                    changeScene(nextScene: x)
                    break
                    
                    
                default:
                    print("success")
                    print(dialogue)
                    break;
                }
            }
            else {
                switch dialogue {
                case 9:
                    
                    addTextLabel(labelIn: "\"Typical boys. So lame. That’s not a good excuse to be late for school!\"")
                    dialogue += 3
                    
                    break
                    
                case 10:
                    
                    addTextLabel(labelIn: "\"I’m just going to pretend I didn’t hear that.\"")
                    dialogue += 2
                    
                    break
                case 11:
                    addTextLabel(labelIn: "\"As you leave, you hear a sigh from behind you and footsteps walking away. \"")
                    dialogue += 1
                    
                    break
                    
                default:
                    print(dialogue)
                }
            }
            
            //            switch (pointOfTouch.x < gameArea.maxX && areButtonsActive == true) {
            //                case(dialogue == 13):
            //                    print(1)
            //                    print(dialogue)
            //                    print(areButtonsActive)
            //                    break;
            //
            //                default:
            //                    print(2)
            //                    print(areButtonsActive)
            //                    print(dialogue)
            //                    break;
            //            }
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
