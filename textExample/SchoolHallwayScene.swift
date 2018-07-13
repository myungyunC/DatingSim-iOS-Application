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

var dialogue = 1
var textGoing = false                                                               //Boolean for if the text is still typing
var choice = 0
var fastForward = false
var areButtonsActive = false                                                   //Boolean for if buttons are currently on the screen

//var dummyName = 0

//////////////////log////////////////
//8/23/17 - DY - finished affection points for Day1



class SchoolHallwayScene: SKScene {
    
    
                                                                       //Value that touchesBegan picks cases from

    let sofiaDefault = SKSpriteNode(imageNamed: "SofiaDefault.png")                     //The girl's default picture
    let sofiaAnnoyedBlush = SKSpriteNode(imageNamed: "SofiaAnnoyedBlush.png")           //The girl's blush picture
    let sofiaMad = SKSpriteNode(imageNamed: "SofiaMad.png")
    let sofiaCuteBlush = SKSpriteNode(imageNamed: "SofiaCuteBlush.png")
    let sofiaActuallyMad = SKSpriteNode(imageNamed: "SofiaActuallyMad.png")
    let mainTextBackground = SKSpriteNode(imageNamed: "MainTextBox.png")                //The main character's (You) textbox image
    let girlTextBackground = SKSpriteNode(imageNamed: "GirlTextBox.png")                //The girl character's (Sofia) textbox image
    
    var currentText = Array("You are bolting down the empty hallway.".characters) //The text that will show up for each dialogue. Instantiated to the didMove function.
    var labelText = ""                                                                  //The text that will attach to the label Node and equal to the currentText.
    var labelText2 = ""                                                                 //You need two of them since you can't change and remove a node at the same time.
    var labelNode = SKLabelNode()                                                       //Node that shows up on the screen
    var labelNode2 = SKLabelNode()
    var calls = 0                                                                       //The value that will loop through the currentText array. It increments for each char.
    var timer : Timer!                                                                  //The timer that will loop through the selector function.
    var timer2 : Timer!
    var firstOption: FTButtonNode! = nil
    var secondOption: FTButtonNode! = nil
    var thirdOption: FTButtonNode! = nil
    

    
    func updateLabelText(currentTimer: Timer) {                                         //This function allows the text to come up one letter at a time. Timer parameter so it knows when to end.
        
        labelText.append(currentText[calls])                                            //The labeltext is appended by the currentText array one char at a time.
        labelNode.text = labelText                                                      //Set's the labelNode text to the appended text.
        calls += 1                                                                      //Move's through the array.
        textGoing = true                                                                //The text is moving.
        
        if calls == currentText.count  {                                                //Checks if hits the end of the array of currentText.
            currentTimer.invalidate()                                                   //Stops the timer.
            textGoing = false                                                           //Text is no longer moving.
            dialogue += 1                                                               //So the touchesBegan moves next
            calls = 0                                                                   //Resets the array looping thing back to 0.
            //print("dialogue = 2")
        }
    }
    
    
    func updateLabelText2(currentTimer: Timer) {                                        //Same thing as updateLabelText. You need to use this function when the first label is being removed.
        
        labelText2.append(currentText[calls])
        labelNode2.text = labelText2
        calls += 1
        textGoing = true
        
        if calls == currentText.count  {
            currentTimer.invalidate()
            textGoing = false
            dialogue += 1
            calls = 0
            //print("dialogue = 2")
        }
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
    
    func changeSceneToRooftop() {
        removePauseButton(scene: self)
        
        dialogue = 1
        textGoing = false                                                               //Boolean for if the text is still typing
        choice = 0
        fastForward = false
        areButtonsActive = false
        
        let sceneToMoveTo = Day1SchoolRooftop(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 2.0)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
        
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
        
        if dialogue == 8 {
            changePicture(changedPicture: sofiaDefault)
            affectionLevel += 10
        }
        
    }
    
    func secondButtonTap() {
        areButtonsActive = false

        print("Second Option Pressed")
        

        choice = 2
        dialogue += 2
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
        
        if dialogue == 9 {
            changePicture(changedPicture: sofiaCuteBlush)
            affectionLevel += 16
        }
    }
    
    func thirdButtonTap() {
        areButtonsActive = false



        print("Third Option Pressed")
        choice = 3
        dialogue += 3
        removeButtons()
        self.childNode(withName: "textBack")?.zPosition = 0
        
        if dialogue == 10 {
            changePicture(changedPicture: sofiaActuallyMad)
            affectionLevel += 4
        }
    }
    
    func removeButtons() {
        print("remove here")
        areButtonsActive = false
        self.childNode(withName: "firstOption")?.removeFromParent()
        self.childNode(withName: "secondOption")?.removeFromParent()
        self.childNode(withName: "thirdOption")?.removeFromParent()
        
        var lastDialogue = 0
        if dialogue == 8 {
            lastDialogue = dialogue - 1
        }
        else if dialogue == 9 {
            lastDialogue = dialogue - 2

        }
        else if dialogue == 10 {
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
        thirdOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.10)
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
        
        let back = SKSpriteNode(imageNamed: "Hallway")
        back.size = self.size
        back.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        back.zPosition = 1
        self.addChild(back)
        createSofias()
        createTextBackgrounds()
        
        let wait = SKAction.wait(forDuration: 0.3)
        let action = SKAction.run {
            self.changeTextBackground(changedBackground: self.mainTextBackground)
            self.addTextLabel(labelIn: "You are bolting down the empty hallway.")
            dialogue += 1
        }
        run(SKAction.sequence([wait,action])) //TIME DELAY ALGORITHM
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

    
    func removeCharacter(movingCharacter: SKSpriteNode) {                                 //Moves a character into the middle from the left.
        
        let walkingCharacter = SKAction.moveTo(x: ((self.size.width/2) * -1), duration: 1)
        
        //        let remove = SKAction(movingCharacter.removeFromParent())
        let walkingSequence = SKAction.sequence([walkingCharacter])
        
        movingCharacter.run(walkingSequence)
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
                        
                    case(dialogue == 2) :
                        
                        addTextLabel(labelIn: "But then... a voice calls out from behind you.")
                        dialogue += 1
                        
                        break;
                        
                    case(dialogue == 3) :
                        changeTextBackground(changedBackground: girlTextBackground)
                        addTextLabel(labelIn: "\"STOP RIGHT THERE!!!\"")
                        dialogue += 1
                        
                        break;
                        
                    case(dialogue == 4) :
                        changeTextBackground(changedBackground: mainTextBackground)
                        addTextLabel(labelIn: "You turn around to see who it is.")
                        dialogue += 1
                        
                        break;
                        
                    case(dialogue == 5) :
                        addTextLabel(labelIn: "And of course, it's the Student Council Prez...")
                        dialogue += 1
                        
                        break;
                        
                    case(dialogue == 6) :
                        moveCharacter(movingCharacter: sofiaMad)
                        changeTextBackground(changedBackground: girlTextBackground)
                        addTextLabel(labelIn: "\"This is the 3rd time this week you're late!\"")
                        dialogue += 1
                        
                        break;
                        
                    case(dialogue == 7) :
                        
                        createButtons(option1: "\"Sorry, I overslept my alarm again.\"", option2: "\"I come late just to see you beautiful.\"", option3: "Make a break for it*")
                        addTextLabel(labelIn: "\"What do you have to say for yourself?\"")
                        
                        break;
                        
                    case dialogue == 8:
                        changeTextBackground(changedBackground: girlTextBackground)
                        addTextLabel(labelIn: "\"How come everyone else is on time?\"")
                        dialogue += 3
                        
                        break
                        
                    case dialogue == 9:
                        changeTextBackground(changedBackground: girlTextBackground)
                        addTextLabel(labelIn: "Wha, what do you mean... sheesh!")
                        dialogue += 2
                        
                        break
                    case dialogue == 10:
                        changeTextBackground(changedBackground: girlTextBackground)
                        addTextLabel(labelIn: "\"Where are you going!? Come back!\"")
                        dialogue += 8
                        
                        break
                        
                    case dialogue == 11:
                        changePicture(changedPicture: sofiaMad)
                        addTextLabel(labelIn: "\"It doesn’t matter. If I catch...")
                        choice = 0
                        dialogue += 1
                        break
                        
                    case dialogue == 12:
                        addTextLabel(labelIn: "you being late one more time, it's...")
                        dialogue += 1
                        break
                        
                    case dialogue == 13:
                        addTextLabel(labelIn: "gonna be a lot of trouble!")
                        dialogue += 1
                        break
                        
                    case dialogue == 14:
                        addTextLabel(labelIn: "Now hurry up and get to class!\"")
                        dialogue += 1
                        break
                        
                    case dialogue == 15:
                        changeTextBackground(changedBackground: mainTextBackground)
                        removeCharacter(movingCharacter: self.childNode(withName: "currentSofia") as! SKSpriteNode)
                        addTextLabel(labelIn: "You quickly run into your classroom.")
                        dialogue += 1
                        break
                        
                    case dialogue == 16:
                        addTextLabel(labelIn: "The day proceeds as normal.")
                        dialogue += 1
                        break
                        
                    case dialogue == 17:
                        changeScene()
                        break
                        
                    case dialogue == 18:
                        changeSceneToRooftop()
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
