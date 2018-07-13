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


//var dummyName = 0





class Day2BedroomScene: SKScene {

    
                                                                       //Value that touchesBegan picks cases from
    let sofiaDefault = SKSpriteNode(imageNamed: "SofiaDefault.png")                     //The girl's default picture
    let sofiaAnnoyedBlush = SKSpriteNode(imageNamed: "SofiaAnnoyedBlush.png")           //The girl's blush picture
    let sofiaMad = SKSpriteNode(imageNamed: "SofiaMad.png")
    
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
    

    

    
    func moveCharacter(movingCharacter: SKSpriteNode) {                                 //Moves a character into the middle from the left.
        movingCharacter.setScale(4)
        movingCharacter.zPosition = 1
        self.addChild(movingCharacter)
        movingCharacter.position = CGPoint(x: ((self.size.width/2) * -1), y: self.size.height * 0.5)
        let walkingCharacter = SKAction.moveTo(x: self.size.width/2, duration: 1)
        
        let walkingSequence = SKAction.sequence([walkingCharacter])
        movingCharacter.run(walkingSequence)
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
    
    func changePicture(changedPicture: SKSpriteNode) {                                  //Changes the character portrait in the middle
        self.addChild(changedPicture)
        changedPicture.setScale(4)
        changedPicture.zPosition = 1
        changedPicture.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)
        
    }


    func changeScene() {
        removePauseButton(scene: self)
        
        dialogue = 1
        textGoing = false                                                               //Boolean for if the text is still typing
        choice = 0
        fastForward = false
        areButtonsActive = false
        
        let sceneToMoveTo = Day2SchoolHallwayScene(size: self.size)
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
        
        firstOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Day2BedroomScene.firstButtonTap))
        firstOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.4)
        firstOption.zPosition = 5
        firstOption.setButtonLabel(title: option1, font: "DINAlternate-Bold", fontSize: 36)
        firstOption.alpha = 0.0 //sets the color of button to completely transparent
        firstOption.name = "firstOption"
        
        secondOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Day2BedroomScene.secondButtonTap))
        secondOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.3)
        secondOption.zPosition = 5
        secondOption.setButtonLabel(title: option2, font: "DINAlternate-Bold", fontSize: 36)
        secondOption.alpha = 0.0
        secondOption.name = "secondOption"
        
        thirdOption.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Day2BedroomScene.thirdButtonTap))
        thirdOption.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.2)
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
        Day2Save = true
        
        spawnPauseButton(scene: self)
        
        let back = SKSpriteNode(imageNamed: "room")
        back.size = self.size
        back.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        back.zPosition = 1
        self.addChild(back)
        
        createTextBackgrounds()
        
        let wait = SKAction.wait(forDuration: 0.5)
        let action = SKAction.run{
            self.changeTextBackground(changedBackground: self.mainTextBackground)
            self.addTextLabel(labelIn: "You wake up in your room.")
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
    
    func rangeArray(arr: Array<Character>, positionFirst: Int, positionLast: Int) -> Array<Character> {
        var newNumbers = Array(arr[positionFirst..<positionLast])
        return newNumbers
    }
    
    func condenseText(words: String) -> String {
        var temp = Array(words.characters)
        var result = ""
        var size = temp.count
        while temp.count > 10 {
            result += String(rangeArray(arr: temp, positionFirst: 0, positionLast: 10))
            result += "\n"
            temp = rangeArray(arr: temp, positionFirst: 10, positionLast: size)
            size = temp.count
            print(result)
            print(temp)
        }
        result += String(rangeArray(arr: temp, positionFirst: 0, positionLast: size))
        return result
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
                        
                    case(dialogue == 2) :
                        addTextLabel(labelIn: "The sun is fully shining on your face.")
                        dialogue += 1
                        break;
                        
                    case(dialogue == 3) :
                        addTextLabel(labelIn: "You check your clock to see the time...")
                        dialogue += 1
                        break;
                        
                    case(dialogue == 4) :
                        addTextLabel(labelIn: "it’s already 11:30!")
                        dialogue += 1
                        break;
                        
                    case(dialogue == 5) :
                        addTextLabel(labelIn: "\"Agh crap, I’m late again.\"")
                        dialogue += 1
                        break;
                        
                    case(dialogue == 6) :
                        addTextLabel(labelIn: "You quickly put on your uniform..")
                        dialogue += 1
                        break;
                        
                    case(dialogue == 7) :
                        addTextLabel(labelIn: "..and you bolt out the door,")
                        dialogue += 1
                        break;
                        
                    case(dialogue == 8) :
                        addTextLabel(labelIn: "..running to school without eating..")
                        dialogue += 1
                        break;
                        
                    case(dialogue == 9) :
                        addTextLabel(labelIn: "..again.")
                        dialogue += 1
                        break;
                        
                    case(dialogue == 10) :
                        changeScene()
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
