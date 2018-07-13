//
//  GameScene.swift
//  Demo
//
//  Created by DOZ on 5/23/14.
//  Copyright (c) 2017 DOZ. All rights reserved.
//
//
//  MODIFICATIONS:
//  7/2/17 - BigBullets spawn explosion after moving to specified location
//  7/2/17 - Functions added to control each enemies spawn rates
//  7/20/17 - Progress on the pause button, can pause everything but can't resume enemy spawn
//  7/25/17 - Added ZONES. There is now an integer per enemy type that indicates zones, or enemy spawn rates.
//  7/30/17 - Pause button COMPLETED BITCHESSS t(-_-t)
//  8/19/17 - added animations in beginning and end
//          - prevented character from dying at winning animation, and waited till ghost ended
//          - changed each enemy to have their own physics category
//          - made sure everything paused when paused (rotating bullets)

import SpriteKit



// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


var gameScore = 0
var enemyRegion = 0
var spawnStartOfGame = true

//let pauseButton = SKSpriteNode(imageNamed: "pausebutton")
//let pauseBackground = SKSpriteNode(imageNamed: "white")
//let inPauseButton = SKSpriteNode(imageNamed: "pauseButt")
//var pauseBool = false

class pre_boss_L1: SKScene, SKPhysicsContactDelegate {
    
    //list of all enemies needed to take current time position for firing enemy bullet
    var enemyList: [SKSpriteNode] = []
    var enemyListT2: [SKSpriteNode] = []
    var enemyListT3: [SKSpriteNode] = []
    var alive = true
    struct PhysicsCategories{
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 //1
        static let Bullet : UInt32 = 0b10 //2
        static let Enemy : UInt32 = 0b100 //4
        static let Enemy2 : UInt32 = 0b101 //4
        static let Enemy3 : UInt32 = 0b111 //4
        static let ShotType1 : UInt32 = 0b1000
        static let ShotType2 : UInt32 = 0b100000
        static let ShotType3 : UInt32 = 0b11
        
    }
    
    
    
    
    //to control enemy spawning
    var levelNumber = 0
    var levelNumberT2 = 0
    var levelNumberT3 = 0
    
    // to control enemy rate:
    // 0 - indicates no enemies present
    // 1 - indicates zone one of enemy type
    // 2 - inidcates zone two of enemy type
    // 3 - indicates zone three of enemy type
    var enemyZoneT1 = 0
    var enemyZoneT2 = 0
    var enemyZoneT3 = 0
    
    var livesNumber = 5
    
    //control when player can shoot....so pretty much when not dead
    var shoot = true
    
    let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    enum gameState{
        case preGame //when the game state is before the start of the game
        case inGame //when the game state is during the game
        case postGame //when the game state is after the game
    }
    
    var currentGameState = gameState.inGame
    
    let player = SKSpriteNode(imageNamed: "f3")
    let playerGhost = SKSpriteNode(imageNamed: "playerShip")
    
    let gameArea : CGRect
    
    func boolChange( x: Bool) {
        var x = x
        if x == true {
            x = false
        }
        else {
            x = true
        }
    }
    
    func spawn_ghost() {
        shoot = false
        playerGhost.setScale(0.5)
        playerGhost.position = player.position //I'm spawning the ghost where the player was
        playerGhost.zPosition = 5
        self.addChild(playerGhost)
        let wait = SKAction.wait(forDuration: 3)
        let deleteGhost = SKAction.removeFromParent()
        let sequence = SKAction.sequence([wait, deleteGhost])
        playerGhost.run(sequence)
        
    }
    
    
    
    func spawn_player() {
        shoot = true
        player.setScale(0.3)
        if spawnStartOfGame{
            
            player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        }
        else
        {
            player.position = playerGhost.position //The player comes out of ghost at the same position
        }
        player.zPosition = 2
        player.name = "Player"
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        alive = true
        
    }
    
    func invincible() {
        alive = false
        let ghost = SKAction.run(spawn_ghost)
        let wait = SKAction.wait(forDuration: 3)
        let player = SKAction.run(spawn_player)
        
        let sequence = SKAction.sequence([ghost, wait, player])
        self.run(sequence)
    }
    
    func random() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat
    {
        return random() * (max - min) + min
    }
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height/maxAspectRatio
        let margin = (size.width - playableWidth) / 2.0
        gameArea = CGRect(x: margin, y:0, width: playableWidth, height: size.height)
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        //for PAUSING BITCHES
        spawnPauseButton(scene: self)
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1 {
            let background = SKSpriteNode(imageNamed: "background")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2,
                                          y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
        }
        
        //        player.setScale(0.5)
        //        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        //        player.zPosition = 2
        //        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        //        player.physicsBody!.affectedByGravity = false
        //        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        //        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        //        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        //        self.addChild(player)
        //SKAction.run(spawn_player)
        spawnStartOfGame = true
        spawn_player()
        spawnStartOfGame = false
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 1.3)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 30
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        livesLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.95)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        startNewLevel()
        enemyZoneT1 += 1
        //        introduceEnemy2()
        //        spawnRateEnemy3()
        
        
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
    
    func loseALife(){
        
        livesNumber -= 1
        livesLabel.text = "Lives:  \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0 || livesNumber < 0 {
            let x = Day2LoseScene(size: self.size)
            changeScene(nextScene: x)
        }
 
        
    }
    
    // REQUIRES: Nothing.
    // MODIFIES: Nothing.
    // EFFECTS: Increases enemy spawn rate for each enemy type at specified score levels.
    func addScore(){
        
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        //control enemyT1 spawning
        if gameScore == 10 || gameScore == 20 || gameScore == 40{
            startNewLevel()
            enemyZoneT1 += 1
        }
        //control enemyT2 spawning
        if gameScore == 18 || gameScore == 27 || gameScore == 40{
            introduceEnemy2()
            enemyZoneT2 += 1
        }
        //control enemyT3 spawning
        if gameScore == 25 || gameScore == 35 || gameScore == 40{
            spawnRateEnemy3()
            enemyZoneT3 += 1
        }
    }
    
    
    func transition(){
        
        currentGameState = gameState.postGame
        
        self.removeAllActions()
        
        holdup = false
        
        
        let moveplayer = SKAction.moveTo(y: self.size.height * 1.5, duration: 3)
        
        player.run(moveplayer, withKey: "won")
        player.physicsBody = nil
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 3)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
        
    }
    
    func changeScene(){
        removePauseButton(scene: self)

        
        let sceneToMoveTo = Day2WinScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
        
    }
    
    
    func spawnExplosion(_ spawnPosition: CGPoint){
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        
        let scaleIn = SKAction.scale(to: 2, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
        
    }
    
    
    //enemyT1
    func removeEnemyFromArray(e: SKSpriteNode) {
        var temp = 0
        //remove enemyT1 from list
        for i in enemyList {
            if i == e{
                enemyList.remove(at: temp)
            }
            temp += 1
        }
        
    }
    
    //enemyT2
    func removeEnemyFromArrayT2(e: SKSpriteNode) {
        var temp = 0
        //remove enemyT2 from list
        for i in enemyListT2 {
            if i == e{
                enemyListT2.remove(at: temp)
            }
            temp += 1
        }
        
    }
    
    //enemyT3
    func removeEnemyFromArrayT3(e: SKSpriteNode) {
        var temp = 0
        //remove enemyT3 from list
        for i in enemyListT3 {
            if i == e{
                enemyListT3.remove(at: temp)
            }
            temp += 1
        }
    }
    
    
    //control enemyT1 spawn rate based on levelNumber
    func startNewLevel(){
        
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 2
        case 2: levelDuration = 1.7
        case 3: levelDuration = 1.5
        case 4: levelDuration = 1.2
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        //        self.run(spawnForever, withKey: "spawningEnemies")
        if (pauseBool){
            removeAllActions()
        }
        else{
            self.run(spawnForever, withKey: "spawningEnemiesT1")
            
        }
        
        
    }
    
    //control enemyT2 spawn rate based on levelNumberT2
    func introduceEnemy2() {
        
        levelNumberT2 += 1
        
        if self.action(forKey: "spawningEnemiesT2") != nil{
            self.removeAction(forKey: "spawningEnemiesT2")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumberT2 {
        case 1: levelDuration = 2
        case 2: levelDuration = 1.7
        case 3: levelDuration = 1.5
        case 4: levelDuration = 1.2
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawn = SKAction.run(spawnEnemyT2)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        if (!pauseBool){
            self.run(spawnForever, withKey: "spawningEnemiesT2")
        }
    }
    
    //control enemyT3 spawn rate based on levelNumberT3
    func spawnRateEnemy3() {
        
        levelNumberT3 += 1
        
        if self.action(forKey: "spawningEnemiesT3") != nil{
            self.removeAction(forKey: "spawningEnemiesT3")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumberT3 {
        case 1: levelDuration = 2
        case 2: levelDuration = 1.7
        case 3: levelDuration = 1.5
        case 4: levelDuration = 1.2
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawn = SKAction.run(spawnEnemyT3)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        if (!pauseBool){
            self.run(spawnForever, withKey: "spawningEnemiesT3")
        }
    }
    
    
    // REQUIRES: Nothing.
    // MODIFIES: Nothing.
    // EFFECTS: Creates an SKSpriteNode bullet to shoot
    //          straight downward from current player position
    //          This is for PLAYER
    func fireBullet()
    {
        if (shoot == true) {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.name = "Bullet"
            bullet.setScale(0.5)
            bullet.position = player.position
            bullet.zPosition = 1
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
            bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
            bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
            self.addChild(bullet)
            
            let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
            let deleteBullet = SKAction.removeFromParent()
            let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
            bullet.run(bulletSequence, withKey:"firePlayerBullet")
        }
    }
    
    // REQUIRES: enemy object as SKSpriteNode, 'e'.
    // MODIFIES: Nothing
    // EFFECTS: Creates an SKSpriteNode bullet to shoot
    //          straight downward from current enemy position.
    //          This is for ENEMYT1
    func fireShotType1(e: SKSpriteNode) {
        
        let shot = SKSpriteNode(imageNamed: "redb")
        shot.name = "ShotType1"
        shot.setScale(0.5)
        shot.position = e.position
        shot.zPosition = 1
        shot.physicsBody = SKPhysicsBody(rectangleOf: shot.size)
        shot.physicsBody!.affectedByGravity = false
        shot.physicsBody!.categoryBitMask = PhysicsCategories.ShotType1
        shot.physicsBody!.collisionBitMask = PhysicsCategories.None
        shot.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(shot)
        
        let moveShot = SKAction.moveTo(y: -self.size.height - shot.size.height, duration: 3)
        let deleteShot = SKAction.removeFromParent()
        let shotSequence = SKAction.sequence([moveShot, deleteShot])
        shot.run(shotSequence, withKey: "fireEnemyBullet1")
    }
    
    
    // REQUIRES: enemy object as SKSpriteNode, 'e'.
    // MODIFIES: Nothing
    // EFFECTS: Creates two SKSpriteNodes (the two bullets)
    //          and fires them off diagonally to the left and right.
    //          This is for ENEMYT2
    func fireShotType2(e: SKSpriteNode) {
        
        // bullet going -pi/3
        let shotright = SKSpriteNode(imageNamed: "greenb")
        shotright.name = "ShotType2"
        shotright.setScale(0.5)
        shotright.position = e.position
        shotright.zPosition = 1
        shotright.physicsBody = SKPhysicsBody(rectangleOf: shotright.size)
        shotright.physicsBody!.affectedByGravity = false
        shotright.physicsBody!.categoryBitMask = PhysicsCategories.ShotType2
        shotright.physicsBody!.collisionBitMask = PhysicsCategories.None
        shotright.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        //bullet going -4pi/3
        let shotleft = SKSpriteNode(imageNamed: "greenb")
        shotleft.name = "ShotType2l"
        shotleft.setScale(0.5)
        shotleft.position = e.position
        shotleft.zPosition = 1
        shotleft.physicsBody = SKPhysicsBody(rectangleOf: shotleft.size)
        shotleft.physicsBody!.affectedByGravity = false
        shotleft.physicsBody!.categoryBitMask = PhysicsCategories.ShotType2
        shotleft.physicsBody!.collisionBitMask = PhysicsCategories.None
        shotleft.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(shotright)
        self.addChild(shotleft)
        
        let moveShotRight = SKAction.moveBy(x: 0.2*(shotright.position.x + self.size.width), y: -self.size.height - shotright.size.height, duration: 2) //skaction
        let moveShotLeft = SKAction.moveBy(x: -0.2*(shotleft.position.x + self.size.width), y: -self.size.height - shotleft.size.height, duration: 2)
        let deleteShot = SKAction.removeFromParent()
        let shotSequenceRight = SKAction.sequence([moveShotRight, deleteShot])
        let shotSequenceLeft = SKAction.sequence([moveShotLeft, deleteShot])
        
        //specify node to run sequence
        shotright.run(shotSequenceRight, withKey: "FireT2Right")
        shotleft.run(shotSequenceLeft, withKey: "FireT2Left")
        
    }
    
    // REQUIRES: enemy object as SKSpriteNode, 'e'.
    // MODIFIES: Nothing
    // EFFECTS: Creates one large SKSpriteNode to shoot
    //          veritcally down from current enemy position.
    //          This is for ENEMYT3
    func fireShotType3(e: SKSpriteNode) {
        let bigBullet = SKSpriteNode(imageNamed: "volleyball")
        bigBullet.name = "plasmaShot"
        bigBullet.setScale(1.1)
        bigBullet.position = e.position
        bigBullet.zPosition = 1
        bigBullet.physicsBody = SKPhysicsBody(rectangleOf: bigBullet.size)
        bigBullet.physicsBody!.affectedByGravity = false
        bigBullet.physicsBody!.categoryBitMask = PhysicsCategories.ShotType3
        bigBullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bigBullet.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(bigBullet)
        
        let rotate = SKAction.rotate(byAngle: 125, duration: 6)
        
        let playPos = player.position
        bigBullet.run(rotate, withKey: "shot3")
        let moveBigBullet = SKAction.move(to: playPos, duration: 3)
        let deleteShot = SKAction.removeFromParent()
        //        let blowUp = SKAction.run(explosionSequence)
        
        //function made local to properly attain bomb position and sequence
        func spawnBombExplosion() {
            let explosion = SKSpriteNode(imageNamed: "explosion")
            explosion.position = playPos
            explosion.zPosition = 3
            explosion.setScale(0)
            self.addChild(explosion)
            
            
            let scaleIn = SKAction.scale(to: 2, duration: 0.1)
            let fadeOut = SKAction.fadeOut(withDuration: 0.1)
            let delete = SKAction.removeFromParent()
            let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
            explosion.run(explosionSequence)
        }
        let boom = SKAction.run(spawnBombExplosion)
        
        let shotSequence = SKAction.sequence([moveBigBullet, boom, deleteShot])
        
        bigBullet.run(shotSequence, withKey: "fireT3")
        
    }
    
    
    func spawnEnemy()
    {
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let firePoint = CGPoint(x: randomXStart * 0.9, y: self.size.height * 0.8)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "1")
        enemyList.append(enemy)
        enemy.name = "Enemy"
        enemy.setScale(0.6)
        enemy.position = startPoint
        enemy.zPosition = 3
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        func removeFromListT1() {
            var temp = 0
            //remove enemyT1 from list
            for i in enemyList {
                if i == enemy{
                    enemyList.remove(at: temp)
                }
                temp += 1
            }
        }
        
        let removeFromArray = SKAction.run(removeFromListT1)
        
        let moveEnemy1 = SKAction.move(to: firePoint, duration: 2.0)
        let moveEnemy2 = SKAction.move(to: endPoint, duration: 5.0)
        
        let deleteEnemy = SKAction.removeFromParent()
        //let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy1, moveEnemy2, deleteEnemy, removeFromArray])
        
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence, withKey: "moveE1")
        }
        
    }
    
    
    func spawnEnemyT2() {
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let firePoint = CGPoint(x: randomXStart * 0.9, y: self.size.height * 0.8)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "orangeship")
        enemyListT2.append(enemy)
        enemy.name = "EnemyT2"
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 3
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy2
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy1 = SKAction.move(to: firePoint, duration: 2.0)
        let moveEnemy2 = SKAction.move(to: endPoint, duration: 5.0)
        let deleteEnemy = SKAction.removeFromParent()
        
        func removeFromListT2() {
            var temp = 0
            //remove enemyT2 from list
            for i in enemyListT2 {
                if i == enemy{
                    enemyListT2.remove(at: temp)
                }
                temp += 1
            }
        }
        
        let removeFromArray = SKAction.run(removeFromListT2)
        let enemySequence = SKAction.sequence([moveEnemy1, moveEnemy2, deleteEnemy, removeFromArray])
        
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence, withKey: "moveE2")
        }
    }
    
    
    func spawnEnemyT3() {
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let firePoint = CGPoint(x: randomXStart * 0.9, y: self.size.height * 0.8)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "orangeship3")
        enemyListT3.append(enemy)
        enemy.name = "EnemyT3"
        enemy.setScale(2)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy3
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy1 = SKAction.move(to: firePoint, duration: 2.0)
        let moveEnemy2 = SKAction.move(to: endPoint, duration: 5.0)
        let deleteEnemy = SKAction.removeFromParent()
        
        func removeFromListT3() {
            var temp = 0
            //remove enemyT3 from list
            for i in enemyListT3 {
                if i == enemy{
                    enemyListT3.remove(at: temp)
                }
                temp += 1
            }
        }
        
        let removeFromArray = SKAction.run(removeFromListT3)
        let enemySequence = SKAction.sequence([moveEnemy1, moveEnemy2, deleteEnemy, removeFromArray])
        
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence, withKey: "moveE3")
        }
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.contactTestBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        var preventBug = true
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            //if the player has hit the enemy
            
            
            
            if body1.node != nil{
                spawnExplosion(body1.node!.position)
            }
            
            if body2.node != nil{
                spawnExplosion(body2.node!.position)
            }
            var temp = 0
            //remove enemyT1 from list
            for i in enemyList {
                
                if i == body1.node || i == body2.node {
                    enemyList.remove(at: temp)
                }
                temp += 1
                preventBug = false
                
                print("1")
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            //spawn_player()
            invincible()
            //runGameOver()
            
        }
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy2{
            //if the player has hit the enemy
            
            
            
            if body1.node != nil{
                spawnExplosion(body1.node!.position)
            }
            
            if body2.node != nil{
                spawnExplosion(body2.node!.position)
            }
            //var temp = 0
            //remove enemyT2 from list
            if preventBug {
                var temp2 = 0
                for k in enemyListT2 {
                    if k == body1.node || k == body2.node {
                        enemyListT2.remove(at: temp2)
                    }
                    temp2 += 1
                }
                temp2 = 0
                preventBug = false
                print("2")
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            //spawn_player()
            invincible()
            //runGameOver()
            
        }
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy3{
            //if the player has hit the enemy
            
            
            
            if body1.node != nil{
                spawnExplosion(body1.node!.position)
            }
            
            if body2.node != nil{
                spawnExplosion(body2.node!.position)
            }
            //var temp = 0
            //remove enemyT3 from list
            if preventBug {
                var temp3 = 0
                for j in enemyListT3 {
                    if j == body1.node || j == body2.node {
                        enemyListT3.remove(at: temp3)
                    }
                    temp3 += 1
                }
                temp3 = 0
                preventBug = false
                print("3")
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            //spawn_player()
            invincible()
            //runGameOver()
            
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && body2.node?.position.y < self.size.height {
            //if the bullet has hit the enemy
            
            addScore()
            print(gameScore)
            
            if body2.node != nil{
                spawnExplosion(body2.node!.position)
            }
            //remove enemyT1 from list
            var temp = 0
            for i in enemyList {
                
                if i == body1.node || i == body2.node {
                    enemyList.remove(at: temp)
                }
                temp += 1
            }
            temp = 0
            
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy2 && body2.node?.position.y < self.size.height {
            //if the bullet has hit the enemy
            
            addScore()
            print(gameScore)
            
            if body2.node != nil{
                spawnExplosion(body2.node!.position)
            }
            //remove enemyT2 from list
            var temp2 = 0
            for k in enemyListT2 {
                
                if k == body1.node || k == body2.node {
                    enemyListT2.remove(at: temp2)
                }
                temp2 += 1
            }
            temp2 = 0
            
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy3 && body2.node?.position.y < self.size.height {
            //if the bullet has hit the enemy
            
            addScore()
            print(gameScore)
            
            if body2.node != nil{
                spawnExplosion(body2.node!.position)
            }
            //remove enemyT3 from list
            var temp3 = 0
            for j in enemyListT3 {
                if j == body1.node || j == body2.node {
                    enemyListT3.remove(at: temp3)
                }
                temp3 += 1
            }
            temp3 = 0
            
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        if body1.categoryBitMask == PhysicsCategories.ShotType1 && body2.categoryBitMask == PhysicsCategories.Player {
            //player hit by ShotType1
            loseALife()
            
            
            if body1.node != nil{
                spawnExplosion(body1.node!.position)
            }
            
            if body2.node != nil{
                spawnExplosion(body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            invincible()
        }
        if body1.categoryBitMask == PhysicsCategories.ShotType2 && body2.categoryBitMask == PhysicsCategories.Player {
            //player hit by ShotType2
            loseALife()
            
            if body1.node != nil{
                spawnExplosion(body1.node!.position)
            }
            
            if body2.node != nil{
                spawnExplosion(body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            invincible()
        }
        if body1.categoryBitMask == PhysicsCategories.ShotType3 && body2.categoryBitMask == PhysicsCategories.Player {
            //player hit by ShotType3
            loseALife()
            
            if body1.node != nil{
                spawnExplosion(body1.node!.position)
            }
            
            if body2.node != nil{
                spawnExplosion(body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            invincible()
        }
    }
    
    var holdup = true
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDraggedX = pointOfTouch.x - previousPointOfTouch.x //distance between touch and player
            
            if (!pauseBool) && holdup {
                player.position.x += amountDraggedX //moves respectively
                playerGhost.position.x += amountDraggedX
                
                if player.position.x > (gameArea.maxX - player.size.width / 2) {  //furthest x value on right
                    player.position.x = (gameArea.maxX - player.size.width / 2) //keeps player from going beyond edge
                    playerGhost.position.x = (gameArea.maxX - player.size.width / 2)
                }
                if player.position.x < (gameArea.minX + player.size.width / 2) {
                    player.position.x = (gameArea.minX + player.size.width / 2)
                    playerGhost.position.x = (gameArea.minX + player.size.width / 2)
                }
                
                let amountDraggedY = pointOfTouch.y - previousPointOfTouch.y //distance between touch and player
                
                player.position.y += amountDraggedY //moves respectively
                playerGhost.position.y += amountDraggedY
                
                if player.position.y > (gameArea.maxY - player.size.height / 2) {  //furthest y value on top
                    player.position.y = (gameArea.maxY - player.size.height / 2) //keeps player from going beyond edge
                    playerGhost.position.y = (gameArea.maxY - playerGhost.size.height / 2)
                }
                if player.position.y < (gameArea.minY + player.size.height / 2) {
                    player.position.y = (gameArea.minY + player.size.height / 2)
                    playerGhost.position.y = (gameArea.minY + playerGhost.size.height / 2)
                }
            }
            
            
            
        }
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //action for enemy spawning
        let spawningAction = action(forKey: "spawningEnemiesT1")
        let spawningActionT2 = action(forKey: "spawningEnemiesT2")
        let spawningActionT3 = action(forKey: "spawningEnemiesT3")
        
        for touch: AnyObject in touches{
            
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
                    
                    //remove pause menu things so as to not Monstrously fuck up dis SHIIIIIITTTTTT mothafuckaaaaa PICKKLEEE RICKKKKKKK
                    removePauseMenu(scene: self)
                    
                    //unpause enemy spawning
                    spawningAction?.speed = 1
                    spawningActionT2?.speed = 1
                    spawningActionT3?.speed = 1
                    
                    enumerateChildNodes(withName: "Player") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "won")
                        movingAction?.speed = 1
                    }
                    
                    //unpause enemy movement
                    enumerateChildNodes(withName: "Enemy") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE1")
                        movingAction?.speed = 1
                        
                        
                    }
                    enumerateChildNodes(withName: "EnemyT2") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE2")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "EnemyT3") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE3")
                        movingAction?.speed = 1
                        
                    }
                    
                    //unpause bullets
                    enumerateChildNodes(withName: "ShotType1") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "fireEnemyBullet1")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "Bullet") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "firePlayerBullet")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "ShotType2") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "FireT2Right")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "ShotType2l") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "FireT2Left")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "plasmaShot") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "fireT3")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "plasmaShot") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "shot3")
                        movingAction?.speed = 1
                        
                    }
                    
                    
                    
                    
                }
                else{
                    spawnPauseMenu(scene: self)
                    
                    
                    //pause enemy spawning
                    spawningAction?.speed = 0
                    spawningActionT2?.speed = 0
                    spawningActionT3?.speed = 0
                    
                    enumerateChildNodes(withName: "Player") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "won")
                        movingAction?.speed = 0
                    }
                    
                    //PAUSE ENEMIES
                    enumerateChildNodes(withName: "Enemy") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE1")
                        movingAction?.speed = 0
                        
                        
                    }
                    enumerateChildNodes(withName: "EnemyT2") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE2")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "EnemyT3") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE3")
                        movingAction?.speed = 0
                        
                    }
                    
                    //PAUSE BULLETS
                    enumerateChildNodes(withName: "ShotType1") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "fireEnemyBullet1")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "Bullet") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "firePlayerBullet")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "ShotType2") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "FireT2Right")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "ShotType2l") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "FireT2Left")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "plasmaShot") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "fireT3")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "plasmaShot") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "shot3")
                        movingAction?.speed = 0
                        
                    }
                    
                    
                }
                
            }
            
        }
        
        
    }
    
    
    //For moving background
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    //For shooting enemy bullets
    var lastShoot: TimeInterval = 1
    var lastShoot2: TimeInterval = 0
    var lastShoot3: TimeInterval = 1
    
    //For shooting player bullets
    var lastShootPlayer: TimeInterval = 1
    
    var done = true
    override func update(_ currentTime: TimeInterval) {
        
        
        
        
        if (!pauseBool) {
            
            
            if gameScore >= 45 && done && alive {
                transition()
                done = false
            }
            
            //ENEMYT1 FIRE RATE
            if currentTime - lastShoot >= 2 {
                for i in enemyList {
                    fireShotType1(e: i)
                    lastShoot = currentTime
                }
            }
            //ENEMYT2 FIRE RATE
            if currentTime - lastShoot2 >= 2 {
                for k in enemyListT2 {
                    fireShotType2(e: k)
                    lastShoot2 = currentTime + 0.5
                }
            }
            //ENEMYT3 FIRE RATE
            if currentTime - lastShoot3 >= 5 {
                for j in enemyListT3 {
                    fireShotType3(e: j)
                    lastShoot3 = currentTime
                }
            }
            //PLAYER FIRE RATE
            if currentGameState == gameState.inGame{
                if currentTime - lastShootPlayer >= 0.05 {
                    fireBullet()
                    lastShootPlayer = currentTime
                }
            }
            if lastUpdateTime == 0 {
                lastUpdateTime = currentTime
            }
            else {
                deltaFrameTime = currentTime - lastUpdateTime
                lastUpdateTime = currentTime
            }
            
            let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
            
            self.enumerateChildNodes(withName: "Background"){
                background, stop in
                background.position.y -= amountToMoveBackground
                
                if background.position.y < -self.size.height{
                    background.position.y += self.size.height*2
                }
            }
        }
        else {
            
            
            
            
        }
    }
}


