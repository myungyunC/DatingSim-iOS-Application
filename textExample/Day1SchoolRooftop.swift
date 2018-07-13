//
//  Day1SchoolRooftop.swift
//  textExample
//
//  Created by Yoo, Daniel on 8/17/17.
//  Copyright © 2017 Chung, Myungyun. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit


class Day1SchoolRooftop: SKScene {
    
    let sofiaActuallyMad = SKSpriteNode(imageNamed: "SofiaActuallyMad.png")
    let sofiaMad = SKSpriteNode(imageNamed: "SofiaMad.png")
    let sofiaDefault = SKSpriteNode(imageNamed: "SofiaDefault.png")
    let cerealGuySpitting = SKSpriteNode(imageNamed: "CerealGuySpitting.png")
    
    let mainTextBackground = SKSpriteNode(imageNamed: "MainTextBox.png")                //The main character's (You) textbox image
    let girlTextBackground = SKSpriteNode(imageNamed: "GirlTextBox.png")                //The girl character's (Sofia) textbox image
    var firstOption: FTButtonNode! = nil
    var secondOption: FTButtonNode! = nil
    var thirdOption: FTButtonNode! = nil
    var lastDialogue = 0
    
    override func didMove(to view: SKView) {
        spawnPauseButton(scene: self)

        //typical
        let back = SKSpriteNode(imageNamed: "rooftop")
        back.size = self.size
        back.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        back.zPosition = 1
        self.addChild(back)
        createSofias()
        createTextBackgrounds()
        
        let wait = SKAction.wait(forDuration: 0.3)
        let action = SKAction.run {
            self.changeTextBackground(changedBackground: self.mainTextBackground)
            self.addTextLabel(labelIn: "You run to the rooftop in hopes of...")
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
        
        sofiaMad.zPosition = 0
        sofiaMad.setScale(4)
        sofiaMad.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        self.addChild(sofiaMad)
        
        sofiaActuallyMad.zPosition = 0
        sofiaActuallyMad.setScale(4)
        sofiaActuallyMad.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        self.addChild(sofiaActuallyMad)
        
        cerealGuySpitting.zPosition = 0
        cerealGuySpitting.setScale(4)
        cerealGuySpitting.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        self.addChild(cerealGuySpitting)
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
        
        if dialogue == 9{
            changePicture(changedPicture: sofiaDefault)
            affectionLevel += 0
        }
    }
    
    func secondButtonTap() {
        areButtonsActive = false
        
        print("Second Option Pressed")
        
        
        choice = 2
        dialogue += 2
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
        
        if dialogue == 10 {
            changePicture(changedPicture: sofiaDefault)
            affectionLevel += 0
        }
        
    }
    
    func thirdButtonTap() {
        areButtonsActive = false
        
        
        
        print("Third Option Pressed")
        choice = 3
        dialogue += 3
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
        
        if dialogue == 11 {
            changePicture(changedPicture: cerealGuySpitting)
            affectionLevel += 0
        }
    }
    
    func removeButtons() {
        print("remove here")
        areButtonsActive = false
        self.childNode(withName: "firstOption")?.removeFromParent()
        self.childNode(withName: "secondOption")?.removeFromParent()
        self.childNode(withName: "thirdOption")?.removeFromParent()
        

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
        
        let sceneToMoveTo = Day1Classroom(size: self.size)
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

    func changeSceneToBedroom() {
        
        dialogue = 1
        textGoing = false                                                               //Boolean for if the text is still typing
        choice = 0
        fastForward = false
        areButtonsActive = false
        
        let sceneToMoveTo = OpeningScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 4.0)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
        
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
                        addTextLabel(labelIn: "outrunning the student council president.")
                        dialogue += 1
                        break
                        
                    case dialogue == 3:
                        addTextLabel(labelIn: "You realize you’re an idiot")
                        dialogue += 1
                        break
                        
                    case dialogue == 4:
                        addTextLabel(labelIn: "because there’s nowhere else to run…")
                        dialogue += 1
                        break
                        
                    case dialogue == 5:
                        changeTextBackground(changedBackground: girlTextBackground)
                        moveCharacter(movingCharacter: sofiaActuallyMad)
                        addTextLabel(labelIn: "*pant* *pant* \"Okay, that’s far enough!\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 6:
                        changePicture(changedPicture: sofiaMad)
                        addTextLabel(labelIn: "\"I’ll be nice today...")
                        dialogue += 1
                        break
                        
                    case dialogue == 7:
                        addTextLabel(labelIn: "so just go back to class right now.\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 8:
                        addTextLabel(labelIn: "\"I’ll look past your tardy AND running indoors.\"")
                        createButtons(option1: "\"Are you sure you won’t kill me…\"", option2: "\"Yes, Ma'am.\"", option3: "\"YOULL NEVER CATCH ME ALIVEEE\"")
                        break
                        
                    case dialogue == 9:
                        changeTextBackground(changedBackground: girlTextBackground)
                        addTextLabel(labelIn: "\"Quit joking around! Just hurry back!\"")
                        dialogue += 3
                        break
                        
                    case dialogue == 10:
                        changeTextBackground(changedBackground: girlTextBackground)
                        addTextLabel(labelIn: "\"Hmph that’s what I thought.\"")
                        dialogue += 2
                        break
                        
                    case dialogue == 11:
                        changeTextBackground(changedBackground: girlTextBackground)
                        addTextLabel(labelIn: "(Jumps off roof)")
                        
                        dialogue += 3
                        break
                        
                    case dialogue == 12:
                        changeTextBackground(changedBackground: mainTextBackground)
                        addTextLabel(labelIn: "You walk back and the day goes as normal.")
                        dialogue += 1
                        break
                        
                    case dialogue == 13:
                        changeScene()
                        break
                        
                    case dialogue == 14:
                        changeTextBackground(changedBackground: girlTextBackground)
                        self.childNode(withName: String(11))?.removeFromParent()
                        addTextLabel(labelIn: "\"No! You idiot!\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 15:
                        changeTextBackground(changedBackground: mainTextBackground)
                        addTextLabel(labelIn: "You’re going to fall to your death.")
                        dialogue += 1
                        break
                        
                    case dialogue == 16:
                        addTextLabel(labelIn: "But before you land…")
                        dialogue += 1
                        break
                        
                    case dialogue == 17:
                        addTextLabel(labelIn: "You suddenly wake up in your bed!")
                        dialogue += 1
                        break
                        
                    case dialogue == 18:
                        changeSceneToBedroom()
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
