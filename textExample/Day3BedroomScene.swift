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




class Day3BedroomScene: SKScene {
    
    //Value that touchesBegan picks cases from
    let sofiaDefault = SKSpriteNode(imageNamed: "SofiaDefault.png")                     //The girl's default picture
    let sofiaAnnoyedBlush = SKSpriteNode(imageNamed: "SofiaAnnoyedBlush.png")           //The girl's blush picture
    let sofiaMad = SKSpriteNode(imageNamed: "SofiaMad.png")
    let speechBubble = SKSpriteNode(imageNamed: "SpeechBubble.png")
    
    let mainTextBackground = SKSpriteNode(imageNamed: "MainTextBox.png")                //The main character's (You) textbox image
    let girlTextBackground = SKSpriteNode(imageNamed: "GirlTextBox.png")                //The girl character's (Sofia) textbox image
    let friendTextBackground = SKSpriteNode(imageNamed: "FriendTextBox.png")
    
    var timer : Timer!                                                                  //The timer that will loop through the selector function.
    var timer2 : Timer!
    var firstOption: FTButtonNode! = nil
    var secondOption: FTButtonNode! = nil
    var thirdOption: FTButtonNode! = nil
    
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
        movingCharacter.setScale(4)
        movingCharacter.zPosition = 1
        self.addChild(movingCharacter)
        movingCharacter.position = CGPoint(x: ((self.size.width/2) * -1), y: self.size.height * 0.5)
        let walkingCharacter = SKAction.moveTo(x: self.size.width/2, duration: 0.5)
        
        let walkingSequence = SKAction.sequence([walkingCharacter])
        movingCharacter.run(walkingSequence)
    }
    
    func removeCharacter(movingCharacter: SKSpriteNode) {                                 //Moves a character into the middle from the left.
        
        let walkingCharacter = SKAction.moveTo(x: ((self.size.width/2) * -1), duration: 1)
        
        //        let remove = SKAction(movingCharacter.removeFromParent())
        let walkingSequence = SKAction.sequence([walkingCharacter])
        
        movingCharacter.run(walkingSequence)
    }
    
    func changePicture(changedPicture: SKSpriteNode) {                                  //Changes the character portrait in the middle
        self.addChild(changedPicture)
        changedPicture.setScale(4)
        changedPicture.zPosition = 1
        changedPicture.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        
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
        if dialogue == 6 {
            changePicture(changedPicture: speechBubble)
            affectionLevel += 16
            print(affectionLevel)
        }
        
        if dialogue == 21 {
            
        }
    }
    
    func secondButtonTap() {
        areButtonsActive = false
        
        print("Second Option Pressed")
        
        
        choice = 2
        dialogue += 2
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
        if dialogue == 7 {
            changePicture(changedPicture: speechBubble)
            affectionLevel += 10
            print(affectionLevel)
        }
        if dialogue == 22 {
            
        }
        
    }
    
    func thirdButtonTap() {
        areButtonsActive = false
        
        
        
        print("Third Option Pressed")
        choice = 3
        dialogue += 3
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
        if dialogue == 8 {
            changePicture(changedPicture: speechBubble)
            affectionLevel += 4
            print(affectionLevel)
        }
        
        if dialogue == 23 {
            
        }
    }
    
    func removeButtons() {
        print("remove here")
        areButtonsActive = false
        self.childNode(withName: "firstOption")?.removeFromParent()
        self.childNode(withName: "secondOption")?.removeFromParent()
        self.childNode(withName: "thirdOption")?.removeFromParent()
        
        var lastDialogue = 0
        if dialogue == 6 {
            lastDialogue = dialogue - 1
        }
        else if dialogue == 7 {
            lastDialogue = dialogue - 2
        }
        else if dialogue == 8 {
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
        
        firstOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Day3BedroomScene.firstButtonTap))
        firstOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.4)
        firstOption.zPosition = 5
        firstOption.setButtonLabel(title: option1, font: "DINAlternate-Bold", fontSize: 36)
        firstOption.alpha = 0.0 //sets the color of button to completely transparent
        firstOption.name = "firstOption"
        
        secondOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Day3BedroomScene.secondButtonTap))
        secondOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.25)
        secondOption.zPosition = 5
        secondOption.setButtonLabel(title: option2, font: "DINAlternate-Bold", fontSize: 36)
        secondOption.alpha = 0.0
        secondOption.name = "secondOption"
        
        thirdOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Day3BedroomScene.thirdButtonTap))
        thirdOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.1)
        thirdOption.zPosition = 5
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
        Day3Save = true
        
        spawnPauseButton(scene: self)
        
        let back = SKSpriteNode(imageNamed: "room")
        back.size = self.size
        back.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        back.zPosition = 1
        self.addChild(back)
        createTextBackgrounds()
        
        let wait = SKAction.wait(forDuration: 0.5)
        let action = SKAction.run {
            self.changeTextBackground(changedBackground: self.mainTextBackground)
            self.addTextLabel(labelIn: "*Bzzt Bzzt* *Bzzt Bzzt* *Bzzt Bzzt*")
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
            lastDialogue = dialogue - 4
        }
        else if choice == 2 {
            lastDialogue = dialogue - 3
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
                    addTextLabel(labelIn: "You wake up to the buzzing of your phone.")
                    dialogue += 1
                    break;
                    
                case(dialogue == 3) :
                    addTextLabel(labelIn: "It's an unknown number calling.")
                    dialogue += 1
                    break;
                    
                case(dialogue == 4) :
                    addTextLabel(labelIn: "\"Hello? Who is it?\"")
                    dialogue += 1
                    break;
                    
                case(dialogue == 5) :
                    changeTextBackground(changedBackground: girlTextBackground)
                    addTextLabel(labelIn: "\"Hey! Time to get up! It's already 11!\"") //girl
                    createButtons(option1: "\"Since when do I take orders from you?\"", option2: "\"Aye aye, captain.\"", option3: "Hang up*")
                    break;
                    
                case(dialogue == 6) :
                    changeTextBackground(changedBackground: girlTextBackground)
                    removeCharacter(movingCharacter: speechBubble)
                    addTextLabel(labelIn: "\"Since now! Duh~\"")
                    dialogue += 4
                    break;
                    
                case(dialogue == 7) :
                    changeTextBackground(changedBackground: girlTextBackground)
                    removeCharacter(movingCharacter: speechBubble)
                    addTextLabel(labelIn: "\"Argh matey, you're not funny.\"")
                    dialogue += 3
                    break;
                    
                case(dialogue == 8) :
                    changeTextBackground(changedBackground: girlTextBackground)
                    removeCharacter(movingCharacter: speechBubble)
                    addTextLabel(labelIn: "And you never saw her ever again.")
                    dialogue += 1
                    break;
                    
                case(dialogue == 9) :
                    let x = Final_Lose(size: self.size)
                    changeScene(nextScene: x)
                    break;
                    
                case dialogue == 10:
                    addTextLabel(labelIn: "\"Okay, seriously tho. Let's study together!\"")
                    choice = 0
                    dialogue += 1
                    break
                    
                case dialogue == 11:
                    changeTextBackground(changedBackground: mainTextBackground)
                    addTextLabel(labelIn: "\"Well, I don't really study so nah.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 12:
                    changeTextBackground(changedBackground: girlTextBackground)
                    addTextLabel(labelIn: "\"Then... meet you at Yes Thai for lunch!\"")
                    dialogue += 1
                    break
                    
                case dialogue == 13:
                    addTextLabel(labelIn: "\"It'll be on me~ Don't be late!\"")
                    dialogue += 1
                    break
                    
                case dialogue == 14:
                    changeTextBackground(changedBackground: mainTextBackground)
                    addTextLabel(labelIn: "The call hangs up*")
                    dialogue += 1
                    break
                case dialogue == 15:
                    addTextLabel(labelIn: "\"Ugh. I just wanted to sleep some more.\"")
                    dialogue += 1
                    break
                case dialogue == 16:
                    addTextLabel(labelIn: "\"Whatever. I don't wanna keep her waiting.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 17:
                    addTextLabel(labelIn: "But suddenly, someone barges in.")
                    dialogue += 1
                    break
                    
                case dialogue == 18:
                    changeTextBackground(changedBackground: friendTextBackground)
                    addTextLabel(labelIn: "\"YOOOO, what's good?\"")
                    dialogue += 1
                    break
                    
                case dialogue == 19:
                    addTextLabel(labelIn: "\"I know you always keep your door unlocked.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 20:
                    addTextLabel(labelIn: "\"So, you ready to go out to the PC room?\"")
                    createButtons(option1: "\"Actually...\"", option2: "I'd love to but...", option3: "\"I literally got forced into a date.\"")
                    break
                    
                case dialogue == 21:
                    changeTextBackground(changedBackground: friendTextBackground)
                    addTextLabel(labelIn: "\"Wait, you're about to go on a date??\"")
                    dialogue += 4
                    break
                    
                case dialogue == 22:
                    changeTextBackground(changedBackground: friendTextBackground)
                    addTextLabel(labelIn: "\"NOOOOO. She got to you first??\"")
                    dialogue += 3
                    break
                    
                case dialogue == 23:
                    changeTextBackground(changedBackground: friendTextBackground)
                    addTextLabel(labelIn: "\"More like you'd rather go with her than me...\"")
                    dialogue += 1
                    break
                    
                case dialogue == 24:
                    addTextLabel(labelIn: "\"Not that I'm mad or anything. Hmph.\"")
                    choice = 0
                    dialogue += 1
                    break
                    
                case dialogue == 25:
                    addTextLabel(labelIn: "Sniff sniff... \"Fine! Be that way.\"")
                    choice = 0
                    dialogue += 1
                    break
                    
                case dialogue == 26:
                    addTextLabel(labelIn: "\"I'll see you later...maybe.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 27:
                    addTextLabel(labelIn: "\".   .   .    traitor\"")
                    dialogue += 1
                    break
                    
                case dialogue == 28:
                    changeTextBackground(changedBackground: mainTextBackground)
                    addTextLabel(labelIn: "George ran out slamming the door behind him.")
                    dialogue += 1
                    break
                    
                case dialogue == 29:
                    addTextLabel(labelIn: "\"Well, you know what they say.\"")
                    dialogue += 1
                    break
                    
                case dialogue == 30:
                    addTextLabel(labelIn: "\"Sisters before misters.\"")
                    dialogue += 1
                    break
                
                case dialogue == 31:
                    addTextLabel(labelIn: "You head out wearing clothes that don't smell.")
                    dialogue += 1
                    break
                case dialogue == 32:
                    addTextLabel(labelIn: "Man, at least sprucen up a bit you lazy bum.")
                    dialogue += 1
                    break
                    
                case dialogue == 33:
                    //let x = Day3RestaurantScene(size: self.size)
                    let x = Day3NightWalkScene(size: self.size)
                    changeScene(nextScene: x)
                    break
                    
                    
                default:
                    print("success")
                    print(dialogue)
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
