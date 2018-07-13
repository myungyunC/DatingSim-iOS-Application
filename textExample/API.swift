//
//  API.swift
//  textExample
//
//  Created by Justin Hsu on 8/23/17.
//  Copyright © 2017 Chung, Myungyun. All rights reserved.
//

import Foundation
import GameplayKit

//////////////////////////// IMPORTANT GLOBAL VARIABLES ////////////////////////////////////
var Day1Save = true
var Day2Save = true
var Day3Save = true
var Day4SaveOver100 = true
var Day4SaveUnder100 = false
var affectionLevel = 0
var bfPoints = 0
////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////// PAUSE MENU //////////////////////////////////////////////////////////////

let pauseButton = SKSpriteNode(imageNamed: "pausebutton")
//      //      //      //      //      //      //      //      //      //      //
var testButt: FTButtonNode! = nil
class PauseFunctions:SKScene {
    func returnButtonTap() {
        print("t(-_-t)")
        
    }
}

func createButtons(option1: NSString, scene: SKScene) {
    
    let buttonTexture: SKTexture! = SKTexture(imageNamed: "button.png")
    let buttonTextureSelected: SKTexture! = SKTexture(imageNamed: "buttonSelected.png")
    testButt = FTButtonNode(normalTexture: buttonTexture, selectedTexture: buttonTextureSelected, disabledTexture: buttonTexture)
    testButt.setButtonAction(target: scene, triggerEvent: .TouchUpInside, action: #selector(PauseFunctions.returnButtonTap))
    testButt.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY * 1.9)
    testButt.zPosition = 106
    testButt.setButtonLabel(title: option1, font: "DINAlternate-Bold", fontSize: 36)
    testButt.alpha = 1
    testButt.size.width = 300
    testButt.size.height = 100
    testButt.name = "returnHome"
    
    scene.addChild(testButt)
    
    //to lock the level, just put skspritenode over buttons, so user can't touch the buttons.
    
    
}
//      //      //      //      //      //      //      //      //      //      //


//for buttons in pause menu
let pauseBackground = SKSpriteNode(imageNamed: "white")
let inPauseButton = SKSpriteNode(imageNamed: "button")
//let inSaveButton = SKSpriteNode(imageNamed: "pauseButt")
var pauseBool = false

func spawnPauseMenu(scene: SKScene) {
    pauseBool = true
    
//    createButtons(option1: "RETURN", scene: scene)

    
    pauseBackground.size = scene.size
    pauseBackground.position = CGPoint(x: scene.size.width/2,
                                       y: scene.size.height/2)
    pauseBackground.zPosition = 100
    pauseBackground.name = "pauseBackground"
    pauseBackground.alpha = 0.9
    scene.addChild(pauseBackground)
    
    inPauseButton.position = CGPoint(x: scene.size.width/2,
                                     y: scene.size.height/2)
    inPauseButton.zPosition = 101
    inPauseButton.size.width = 700
    inPauseButton.size.height = 100
    scene.addChild(inPauseButton)
    
//    inSaveButton.position = CGPoint(x: scene.size.width/2,
//                                    y: scene.size.height*0.3)
//    inSaveButton.zPosition = 101
//    inSaveButton.size.width = 700
//    inSaveButton.size.height = 100
//    scene.addChild(inSaveButton)
}

func removePauseMenu(scene: SKScene) {
    pauseBool = false
    scene.run(SKAction(pauseBackground.removeFromParent()))
    scene.run(SKAction(inPauseButton.removeFromParent()))
//    scene.run(SKAction(inSaveButton.removeFromParent()))
//    scene.run(SKAction(testButt.removeFromParent()))
}

func spawnPauseButton(scene: SKScene) {
    pauseButton.setScale(1)
    pauseButton.position = CGPoint(x: scene.size.width * 0.82, y: scene.size.height * 0.96)
    pauseButton.zPosition = 110
    scene.addChild(pauseButton)
}

func removePauseButton(scene: SKScene) {
    scene.run(SKAction(pauseButton.removeFromParent()))

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////// LABEL NODE ////////////////////////////////////////////////
class labelNodeObject: SKLabelNode {
    
    ////////////////////// MEMBERS ///////////////////////////////
    var textString = [Character]()
    var fullText = ""
    var currentText = ""
    var calls = 0
    var labelTimer = Timer()
    var labelNodeObj = SKLabelNode()
    
    //constructor
    init (textIn: String) {
        labelNodeObj.fontName = "AppleSDGothicNeo-Medium"
        labelNodeObj.fontSize = 50
        labelNodeObj.fontColor = SKColor.white
        labelNodeObj.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        labelNodeObj.position = CGPoint(x: 0, y: 0)
        labelNodeObj.zPosition = 10
        labelNodeObj.text = ""
        labelNodeObj.name = "aniText"
        textString = Array(textIn.characters)
        fullText = textIn
        labelNodeObj.name = String(dialogue)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set_position(xIn: Int, yIn: Int) {
        labelNodeObj.position = CGPoint(x: xIn, y: yIn)
    }
    
    func set_timer(timer: Timer) {      //MIGHT NOT NEED THIS
        labelTimer = timer
    }
    
    //EFFECTS: Add a char from textString everytime it's called.
    func add_each_letter() {
        currentText += String(textString[calls])
        labelNodeObj.text = currentText
        calls += 1
        if (currentText == String(textString) || fastForward == true) {
            fastForward = false
            print("finished animation")
            labelTimer.invalidate()
            currentText = fullText
            labelNodeObj.text = currentText
            calls = 0
            
        }
    }
    
    // EFFECTS: Calls add_each_letter() function every 0.05 seconds.
    func animate_text() {
        fastForward = false
        textGoing = true
        labelTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.add_each_letter), userInfo: labelTimer, repeats: true)
    }
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
























