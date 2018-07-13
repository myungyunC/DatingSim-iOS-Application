//
//  datingsim.swift
//  Boss Apha
//
//  Created by Chung, Myungyun on 5/9/17.
//  Copyright © 2017 DOZ. All rights reserved.
//

import SpriteKit

import GameplayKit

var score = 0

class OpeningScene: SKScene {

    var textGoing = false                                                               //Boolean for if the text is still typing
    var areButtonsActive = false                                                        //Boolean for if buttons are currently on the screen
    var dialogue = 0                                                                    //Value that touchesBegan picks cases from
    let mainTextBackground = SKSpriteNode(imageNamed: "MainTextBox.png")                //The main character's (You) textbox image
    
    var currentText = Array("\"Ugh... What a weird dream.\"".characters) //The text that will show up for each dialogue. Instantiated to the didMove function.
    var labelText = ""                                                                  //The text that will attach to the label Node and equal to the currentText.
    var labelText2 = ""                                                                 //You need two of them since you can't change and remove a node at the same time.
    var labelNode = SKLabelNode()                                                       //Node that shows up on the screen
    var labelNode2 = SKLabelNode()
    var calls = 0                                                                       //The value that will loop through the currentText array. It increments for each char.
    var timer : Timer!                                                                  //The timer that will loop through the selector function.
    var timer2 : Timer!
    

    
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
        }
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


    func moveCharacter(movingCharacter: SKSpriteNode) {                                 //Moves a character into the middle from the left.
        movingCharacter.setScale(4)
        movingCharacter.zPosition = 1
        self.addChild(movingCharacter)
        movingCharacter.position = CGPoint(x: ((self.size.width/2) * -1), y: self.size.height * 0.5)
        let walkingCharacter = SKAction.moveTo(x: self.size.width/2, duration: 1)
        
        let walkingSequence = SKAction.sequence([walkingCharacter])
        movingCharacter.run(walkingSequence)
    }
    
    func changePicture(changedPicture: SKSpriteNode) {                                  //Changes the character portrait in the middle
        self.addChild(changedPicture)
        changedPicture.setScale(4)
        changedPicture.zPosition = 1
        changedPicture.position = CGPoint(x: ((self.size.width/2)), y: self.size.height * 0.5)

    }
    
    func createTextBackground(theBackground: SKSpriteNode)                              //Make a textbackground a bigger one for the main and smaller for girl
    {
        theBackground.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        theBackground.setScale(0.7)
        theBackground.zPosition = 2
    }
    
    func createLabel(theText: SKLabelNode) //Creates an SKLabel, all the requirements
    {
        theText.fontName = "AppleSDGothicNeo-Medium"
        theText.fontSize = 50
        theText.fontColor = SKColor.white
        theText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        theText.position = CGPoint(x: self.size.width * 0.18, y: self.size.height * 0.25)
        theText.zPosition = 3
        
        theText.text = ""

    }
    
    func createLabel2(theText: SKLabelNode)                                                //Creates an SKLabel, use this when the first one is being destroyed
    {
        theText.fontName = "AppleSDGothicNeo-Medium"
        theText.fontSize = 50
        theText.fontColor = SKColor.white
        theText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        theText.position = CGPoint(x: self.size.width * 0.18, y: self.size.height * 0.25)
        theText.zPosition = 3
        
        theText.text = ""
    }
    

    
    func changeScene() {
        removePauseButton(scene: self)
        
        let sceneToMoveTo = SchoolHallwayScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 2.0)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
        
        
    }
    
    func fadeInObjects(newBackground: SKSpriteNode, newText: SKLabelNode) {                //Fades in the Background and Label Node. Use when a new person is talking.
        
        createTextBackground(theBackground: newBackground)
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        let sequence = SKAction.sequence([fadeIn])
        newBackground.alpha = 0.0
        newBackground.run(sequence)
        let wait = SKAction.wait(forDuration: 1.0) //TIME DELAY ALGORITHM
        let action = SKAction.run {
            self.addChild(newBackground)
            self.createLabel(theText: newText)
            self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateLabelText), userInfo: self.timer, repeats: true)
            self.addChild(newText)
        }
        run(SKAction.sequence([wait,action])) //TIME DELAY ALGORITHM
        
    }
    
    override func didMove(to view: SKView) {
        Day1Save = true

        spawnPauseButton(scene: self)
        
        let back = SKSpriteNode(imageNamed: "room")
        back.size = self.size
        back.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        back.zPosition = 0
        self.addChild(back)
        
        let wait = SKAction.wait(forDuration: 0.0)
        let action = SKAction.run {
            self.fadeInObjects(newBackground: self.mainTextBackground, newText: self.labelNode)
            self.dialogue += 1
        }
        run(SKAction.sequence([wait,action])) //TIME DELAY ALGORITHM
    }
    
    let gameArea: CGRect
    
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
                    pauseBool = true
                    spawnPauseMenu(scene: self)
                    //                    let text =
//                    let someNodeExist = self.childNode(withName: "aniText")
//                    let movingAction = someNodeExist?.action(forKey: "animatedText")
//                    movingAction?.speed = 0
                }
            }
            
            else if (pointOfTouch.x < gameArea.maxX && !areButtonsActive && !pauseBool) {
                switch (pointOfTouch.x < gameArea.maxX && areButtonsActive == false) {
                    
                case(dialogue == 0) :
                    fadeInObjects(newBackground: mainTextBackground, newText: labelNode)
                    
                    dialogue += 1
                    break;
                    
                case(dialogue == 1) :
                    if textGoing {
                        timer.invalidate()
                        labelNode.text = String(currentText)
                        textGoing = false
                        calls = 0
                        
                        dialogue += 1
                        break;
                    }
                    
                case(dialogue == 2) :
                    labelNode.removeFromParent()
                    currentText = Array("You check the alarm to see what time it is.".characters)
                    self.createLabel2(theText: self.labelNode2)
                    timer2 = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateLabelText2), userInfo: timer2, repeats: true)
                    self.addChild(self.labelNode2)
                    
                    dialogue += 1
                    break;
                    
                case(dialogue == 3) :
                    if textGoing {
                        timer2.invalidate()
                        labelNode2.text = String(currentText)
                        textGoing = false
                        calls = 0
                        
                        dialogue += 1
                        break;
                    }
                    
                case(dialogue == 4) :
                    labelNode2.removeFromParent()
                    currentText = Array("\"Oh crap, I'm late.\"".characters)
                    labelText = String()
                    self.createLabel(theText: self.labelNode)
                    timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateLabelText), userInfo: timer, repeats: true)
                    self.addChild(self.labelNode)
                    
                    dialogue += 1
                    break;
                    
                case(dialogue == 5) :
                    if textGoing {
                        timer.invalidate()
                        labelNode.text = String(currentText)
                        textGoing = false
                        calls = 0
                        
                        dialogue += 1
                        break;
                    }
                    
                case(dialogue == 6) :
                    //sofiaDefault.removeFromParent()
                    labelNode.removeFromParent()
                    currentText = Array("You put on your clothes and book it to class.".characters)
                    //changePicture(changedPicture: sofiaAnnoyedBlush)
                    labelText2 = String()
                    self.createLabel2(theText: self.labelNode2)
                    timer2 = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateLabelText2), userInfo: timer2, repeats: true)
                    self.addChild(labelNode2)
                    
                    dialogue += 1
                    break;
                    
                case(dialogue == 7) :
                    if textGoing {
                        timer2.invalidate()
                        labelNode2.text = String(currentText)
                        textGoing = false
                        calls = 0
                        
                        dialogue += 1
                        break;
                    }
                    
                case(dialogue == 8) :
                    labelNode2.removeFromParent()
                    currentText = Array("Your hair is a mess and you look sloppy.".characters)
                    labelText = String()
                    self.createLabel(theText: self.labelNode)
                    timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateLabelText), userInfo: timer, repeats: true)
                    self.addChild(self.labelNode)
                    
                    dialogue += 1
                    break;
                    
                case(dialogue == 9) :
                    if textGoing {
                        timer.invalidate()
                        labelNode.text = String(currentText)
                        textGoing = false
                        calls = 0
                        
                        dialogue += 1
                        break;
                    }
                    
                default :
                    changeScene()
                    
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


