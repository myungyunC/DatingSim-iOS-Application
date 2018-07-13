//
//  GameScene.swift
//  Boss Alpha
//
//  Created by Chung, Myungyun on 5/9/17.
//  Copyright © 2017 DOZ. All rights reserved.
//
//
//  Updates:
//  7/7/17 - added large projectiles
//  7/14/17 - fixed the line attack and spacing
//  8/9/17 - added pause button and fixed physics bodies spacing
//  8/11/17 - changed boss intro, added health bar, removed boss health number
//  8/16/17 - changed bullet art, added boss intro, encountered bug with 3-way collision
//
//

//CHECK FOR TRANSITION
//CHANGE BEGINNNING FOR PLAYER
//SMOOTHER TRANSITION
//HITBOXES FOR ENEMIES
//KEEP TESTING FOR BUGS

import SpriteKit
import GameplayKit

class game_boss_L2: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "f3")
    let heart = SKSpriteNode(imageNamed: "badheart")
    let battleship = SKSpriteNode(imageNamed: "b1")
    let playerGhost = SKSpriteNode(imageNamed: "playerShip")
    let healthBar = SKShapeNode()
    
  
    let lifeLabel = SKLabelNode(fontNamed: "The Bold Font")
    let bossLabel = SKLabelNode(fontNamed: "The Bold Font")
    let gameOver = SKLabelNode(fontNamed: "The Bold Font")
    
    let explosionSound = SKAction.playSoundFileNamed("se_pldead00.wav", waitForCompletion: false)
    let sparkSound = SKAction.playSoundFileNamed("se_plst00.wav", waitForCompletion: false)
    let ghostSound = SKAction.playSoundFileNamed("ghost.wav", waitForCompletion: false)
    
    let pauseButton = SKSpriteNode(imageNamed: "pausebutton")
    let pauseBackground = SKSpriteNode(imageNamed: "white")
    let inPauseButton = SKSpriteNode(imageNamed: "pauseButt")
    var pauseBool = false
    
    var alive = true
    var dead = false
    var updated = false
    var bossHealth = 1000
    var playerLife = 100
    var attack2 = true
    var attack3 = true
    var destination = CGPoint()
    var movementDone = true
    var setSpeed = true
    var bossx = CGFloat()
    var shoot = true
    var spawnStartOfGame = true
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    //categories for physic body collisions
    struct PhysicsCategories{
        
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 //1
        static let Bullet : UInt32 = 0b10 //2
        static let Heart : UInt32 = 0b100 //4
        static let Enemy : UInt32 = 0b1000 //8
        static let BattleShip : UInt32 = 0b10000 //16
        static let Ghost : UInt32 = 0b100000 // 32
        
    }
    
    func random() -> CGFloat { //returns a random number (used for spawning bullets)
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat { //returns a random number within a range
        return random() * (max-min) + min
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
    
    
    var bar = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
    
    
    override func didMove(to view: SKView) {
        
        //for pausing yall
        pauseButton.setScale(1)
        pauseButton.position = CGPoint(x: self.size.width * 0.82, y: self.size.height * 0.96)
        pauseButton.zPosition = 101
        self.addChild(pauseButton)
        
        self.physicsWorld.contactDelegate = self
        
        //creates background
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
        
        spawn_player()
        spawnStartOfGame = false
        
        
        //health bar
        bar = SKShapeNode(rectOf: CGSize(width: self.size.width * 1.76 , height: self.size.height * 0.005))
        bar.name = "Bar"
        bar.fillColor = SKColor.red
        bar.position = CGPoint(x: 0, y: self.size.height * 0.985)
        bar.zPosition = 50
        self.addChild(bar)
        
        //creates girl's heart
        heart.setScale(1)
        heart.name = "Heart"
        heart.position = CGPoint(x:self.size.width / 2, y: self.size.height * 1.2)
        heart.zPosition = 4
        self.addChild(heart)
        heart.physicsBody = SKPhysicsBody(circleOfRadius: heart.size.height * 0.25)
        heart.physicsBody!.affectedByGravity = false
        heart.physicsBody!.categoryBitMask = PhysicsCategories.Heart
        heart.physicsBody!.collisionBitMask = PhysicsCategories.None
        heart.physicsBody!.contactTestBitMask = PhysicsCategories.Bullet
        let moveheart = SKAction.moveTo(y: self.size.height * 0.7, duration: 4)
        heart.run(moveheart, withKey: "begin")
        
        //creates life
        lifeLabel.text = "Lives: 3"
        lifeLabel.fontSize = 30
        lifeLabel.fontColor = SKColor.white
        lifeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        lifeLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.95)
        lifeLabel.zPosition = 100
        self.addChild(lifeLabel)
        
        //creates boss health
        /*
        bossLabel.text = "Heart Health: 1000"
        bossLabel.fontSize = 30
        bossLabel.fontColor = SKColor.white
        bossLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        bossLabel.position = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.95)
        bossLabel.zPosition = 100
        self.addChild(bossLabel)
        */
        
        
        //shoots
        
        
    }
    
    /*
    func respawn() {
        //creates player
        self.addChild(player)
        player.setScale(1.0)
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.125)
        player.zPosition = 2 //bullet is 1 as it is behind the player
        
        //creates physics and collision detections with physic body interactions
        //and what each object is allowed to make contact with
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
    }
 */
    
    
  
    

    
    
    
    //INVINCIBILITY
    func invincible() {
        let ghost = SKAction.run(spawn_ghost)
        let wait = SKAction.wait(forDuration: 3)
        let player = SKAction.run(spawn_player)
        
        let sequence = SKAction.sequence([ghost, wait, player])
        self.run(sequence)
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
        playerGhost.run(sequence, withKey: "moveGhost")
        
    }
    
    var startofGame = true
    func spawn_player() {
        shoot = true
        player.setScale(0.3)
        player.name = "Player"
        if spawnStartOfGame{
            
            player.position = CGPoint(x: self.size.width/2, y: -1 * self.size.height * 0.2)
        }
        else
        {
            player.position = playerGhost.position //The player comes out of ghost at the same position
        }
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 3)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        if startofGame {
            let moveplayer = SKAction.moveTo(y: self.size.height * 0.2, duration: 2)
            player.run(moveplayer, withKey: "spawning")
            startofGame = false
        }
        
        
        
    }
    

    
    //prints gameover
    func printFail() {
        gameOver.text = "FAILURE"
        gameOver.fontSize = 30
        gameOver.fontColor = SKColor.white
        gameOver.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        gameOver.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        gameOver.zPosition = 100
        self.addChild(gameOver)
        
        let scaleUp = SKAction.scale(to: 9, duration: 3)
        gameOver.run(scaleUp)
        
    }
    
    func win() {
        var bossLocation = CGPoint()
        bossLocation = heart.position
        heart.removeFromParent()
        
        let newHeart = SKSpriteNode(imageNamed: "heart")
        newHeart.zPosition = 7
        newHeart.position = bossLocation
        self.addChild(newHeart)
        
        let scaleUp = SKAction.scale(to: 15, duration: 10)
        newHeart.run(scaleUp)
        
        let x = Day3WinScene(size: self.size)
        changeScene(nextScene: x)
            
        
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
    
    //reduces life
    func deductLife() {
        
        
        
        playerLife -= 1
        lifeLabel.text = "Lives: \(playerLife)"  //displays new life
        
        if playerLife == 0 || playerLife < 0 {
                let x = Day3LoseScene(size: self.size)
                changeScene(nextScene: x)
            
        }
    }
    
    //reduces boss health
    func deductBossHealth() {
        
        bossHealth -= 2
        if bossHealth > -1 {
            bossLabel.text = "Heart Health: \(bossHealth)" //displays new boss health
        }
        if bossHealth == 998 || bossHealth == 750 || bossHealth == 500 || bossHealth == 300 || bossHealth == 0 {
            startNewLevel()
            
            
        }
        let sub = CGFloat((self.size.width * 1.76) * 0.000872) //DONT CHANGE
        //bar = SKShapeNode(rectOf: CGSize(width: (self.size.width * 2) * sub, height: 50))
        bar.position.x = bar.position.x - sub
        
        
    }
    
    //passes contact info of all contacts that have been made
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody() //contact info is given in a nonorganized manner
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask { //checks for numerical order
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        } //body1 has lowest category number
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy { //if player hits enemy
            
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
                deductLife()
                player.removeFromParent()
                if playerLife > -1 {
                    invincible()
                }
                
                
            }
            
            if playerLife == 0 || playerLife < 0 {
                body1.node?.removeFromParent()
                //alive = false
                //playerLife = 0
                //let printfail = SKAction.run(printFail)
                //let waitToChange = SKAction.wait(forDuration: 3)
                //let sceneChange = SKAction.run(changeScene)
                //let changeSequence = SKAction.sequence([printfail, waitToChange, sceneChange])
                
                //self.run(printfail)
            }
            
            body2.node?.removeFromParent()
            
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Ghost {
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
                deductLife()
                player.removeFromParent()
                if playerLife > -1 {
                    invincible()
                }
                
                
            }
            body2.node?.removeFromParent()
            deductLife()
            //self.run(ghostSound)
            updated = false
            attack2 = true
            setSpeed = true
            
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Heart { //if bullet hits heart
            spawnHitSpark(spawnPosition: body1.node!.position)
            body1.node?.removeFromParent()
            //PUT CODE TO DEDUCT FROM HEART'S HEALTH, ALSO DISPLAY IT!
            
            deductBossHealth()
        }
        
    }
    
    func spawnExplosion(spawnPosition: CGPoint) {
        
        
        let explosion = SKSpriteNode(imageNamed: "dead")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        //let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
        
    }
    
    func spawnHitSpark(spawnPosition: CGPoint) {
        
        let spark = SKSpriteNode(imageNamed: "spark")
        spark.position = spawnPosition
        spark.zPosition = 15
        self.addChild(spark)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        //let sparkSequence = SKAction.sequence([sparkSound, scaleIn, fadeOut, delete])
        let sparkSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        spark.run(sparkSequence)
        
        
    }
    
    func spawnBattleShip() {
        
        let rotate = SKAction.rotate(byAngle: 50000, duration: 20)
        battleship.setScale(8.0)
        battleship.zPosition = 7
        battleship.name = "Ship"
        battleship.physicsBody = SKPhysicsBody(rectangleOf: battleship.size)
        battleship.physicsBody!.affectedByGravity = false
        battleship.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        battleship.physicsBody!.collisionBitMask = PhysicsCategories.None
        battleship.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        let randomPosition = arc4random_uniform(3)
        print(randomPosition)
        
        if randomPosition == 0 {
            battleship.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 1.5)
        }
        else if randomPosition == 1 {
            battleship.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 1.5)
        }
        else {
            battleship.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 1.5)
        }
        
        
        self.addChild(battleship)
        let moveShip = SKAction.moveTo(y: -(self.size.height + battleship.size.height), duration: 3)
        
        //try to make the bullet appear for a sec, then shoot
        
        battleship.run(rotate, withKey: "rotateShip")
        
        let deleteShip = SKAction.removeFromParent()
        let shipSequence = SKAction.sequence([moveShip, deleteShip])
        //let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])  //uses sequence to correctly execute events of moving and deleting the bullet
        battleship.run(shipSequence, withKey: "moveBattleship")
        
    }

   
    
    func fireBullet() {
        
        //creates bullet
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(0.5)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.name = "Bullet"
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Heart
        
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        
        //try to make the bullet appear for a sec, then shoot
        
        
        
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
        //let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])  //uses sequence to correctly execute events of moving and deleting the bullet
        bullet.run(bulletSequence, withKey: "moveBullet")
        
    }
    
    func startNewLevel() {
        
        
        
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies)")
        }
        
        
        var bulletDuration = TimeInterval()
        var ghostDuration = TimeInterval()
        switch bossHealth {
        case 0:
            bulletDuration = 10000
            self.removeAction(forKey: "spawningEnemies)")
        case 1..<260:
            bulletDuration = 0.65
            ghostDuration = 0.8
        case 26..<510:
            bulletDuration = 1.05
            ghostDuration = 1.2
        case 50..<760:
            bulletDuration = 1.45
            ghostDuration = 2.0
        case 75..<1001:
            bulletDuration = 1.85
        default:
            bulletDuration = 2.0
            ghostDuration = 3.0
        }
        if (pauseBool) {
            removeAllActions()
        }
        else {
            if bossHealth > 0 && bossHealth < 1000 {
                let spawn = SKAction.run(spawnEnemy)
                let waitToSpawn = SKAction.wait(forDuration: bulletDuration)
                let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
                let spawnForever = SKAction.repeatForever(spawnSequence)
                self.run(spawnForever, withKey: "spawningEnemies")
            }
            if bossHealth > 500 && bossHealth <= 750 {
                let spawn2 = SKAction.run(attackPattern)
                let wait2 = SKAction.wait(forDuration: ghostDuration)
                let spawnSequence2 = SKAction.sequence([spawn2, wait2])
                let spawnForever2 = SKAction.repeatForever(spawnSequence2)
                self.run(spawnForever2, withKey: "spawningGhost")
            }
            if bossHealth > 0 && bossHealth <= 300 {
                let battleshipDuration = TimeInterval(4.0)
                let spawn3 = SKAction.run(spawnBattleShip)
                let wait3 = SKAction.wait(forDuration: battleshipDuration)
                let spawnSequence3 = SKAction.sequence([spawn3, wait3])
                let spawnForever3 = SKAction.repeatForever(spawnSequence3)
                self.run(spawnForever3, withKey: "spawningShip")
            }
        }
        
        
        
        
        
        //change this to adapt to attack patterns, create condition that if heart health is low,
        //lower duration and new attack patterns
        
    }
    
    func attackPattern() {
        
        //rotating bullet
        let rotate = SKAction.rotate(byAngle: 50000, duration: 20)
        
        let enemy1 = SKSpriteNode(imageNamed: "g4")
        let enemy2 = SKSpriteNode(imageNamed: "g4")
        let enemy3 = SKSpriteNode(imageNamed: "g4")
        let enemy4 = SKSpriteNode(imageNamed: "g4")
        
        
        
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX * 0.5)
        
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX * 0.5)
        let randomYStart = random(min: gameArea.maxY * 0.7, max: gameArea.maxY)

        
        
        enemy1.setScale(0.5)
        enemy1.position = CGPoint(x: randomXStart, y: randomYStart)
        enemy1.zPosition = 2
        enemy1.name = "E1"
        enemy1.physicsBody = SKPhysicsBody(circleOfRadius: enemy1.size.width * 0.3)
        enemy1.physicsBody!.affectedByGravity = false
        enemy1.physicsBody!.categoryBitMask = PhysicsCategories.Ghost
        enemy1.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy1.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        enemy1.physicsBody?.isDynamic = true
        enemy1.run(rotate, withKey: "rotateg4")

       
        self.addChild(enemy1)
        

        
        enemy2.setScale(0.5)
        enemy2.position = CGPoint(x: randomXStart + (enemy1.size.width * 3), y: randomYStart)
        enemy2.zPosition = 2
        enemy2.name = "E2"
        enemy2.physicsBody = SKPhysicsBody(circleOfRadius: enemy1.size.width * 0.3)
        enemy2.physicsBody!.affectedByGravity = false
        enemy2.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy2.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy2.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        enemy2.physicsBody?.isDynamic = true
        enemy2.run(rotate, withKey: "rotateg4")
        self.addChild(enemy2)
        
        
        enemy3.setScale(0.5)
        enemy3.position = CGPoint(x: randomXStart + (enemy1.size.width * 6), y: randomYStart)
        enemy3.zPosition = 2
        enemy3.name = "E3"
        enemy3.physicsBody = SKPhysicsBody(circleOfRadius: enemy1.size.width * 0.3)
        enemy3.physicsBody!.affectedByGravity = false
        enemy3.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy3.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy3.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        enemy3.physicsBody?.isDynamic = true
        enemy3.run(rotate, withKey: "rotateg4")
        self.addChild(enemy3)
        
        
        enemy4.setScale(0.5)
        enemy4.position = CGPoint(x: randomXStart + (enemy1.size.width * 9), y: randomYStart)
        enemy4.zPosition = 2
        enemy4.name = "E4"
        enemy4.physicsBody = SKPhysicsBody(circleOfRadius: enemy1.size.width * 0.3)
        enemy4.physicsBody!.affectedByGravity = false
        enemy4.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy4.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy4.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        enemy4.physicsBody?.isDynamic = true
        enemy4.run(rotate, withKey: "rotateg4")
        self.addChild(enemy4)
        
        
        
        
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        let endPoint2 = CGPoint(x: randomXEnd + (enemy1.size.width * 1.5), y: -self.size.height * 0.2)
        let endPoint3 = CGPoint(x: randomXEnd + (enemy1.size.width * 3), y: -self.size.height * 0.2)
        let endPoint4 = CGPoint(x: randomXEnd + (enemy1.size.width * 4.5), y: -self.size.height * 0.2)
        
        // Calculate vector components x and y
        var dx = player.position.x - enemy3.position.x
        var dy = enemy3.position.y - player.position.y
        
        // Normalize the components
        let magnitude = sqrt(dx*dx+dy*dy)
        dx /= magnitude
        dy /= magnitude
        
        // Create a vector in the direction of the bird
        let strength = CGFloat(3)
        let vector = CGVector(dx:strength*dx, dy:strength*dy)
        
        // Apply impulse
        enemy1.physicsBody?.applyImpulse(vector)
        enemy2.physicsBody?.applyImpulse(vector)
        enemy3.physicsBody?.applyImpulse(vector)
        enemy4.physicsBody?.applyImpulse(vector)
        
        //moves the bullet
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let moveEnemy2 = SKAction.move(to: endPoint2, duration: 1.5)
        let moveEnemy3 = SKAction.move(to: endPoint3, duration: 1.5)
        let moveEnemy4 = SKAction.move(to: endPoint4, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        let enemySequence2 = SKAction.sequence([moveEnemy2, deleteEnemy])
        let enemySequence3 = SKAction.sequence([moveEnemy3, deleteEnemy])
        let enemySequence4 = SKAction.sequence([moveEnemy4, deleteEnemy])
        enemy1.run(enemySequence, withKey: "moveE1")
        enemy2.run(enemySequence2, withKey: "moveE2")
        enemy3.run(enemySequence3, withKey: "moveE3")
        enemy4.run(enemySequence4, withKey: "moveE4")
        
    }
    
    func spawnEnemy() {
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 0.9)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "no3")
        enemy.setScale(0.4)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.name = "Enemy"
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(enemy)
        
        //moves the bullet
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        
        //rotating bullet
        let rotate = SKAction.rotate(byAngle: 50000, duration: 1.5)
        
        let group = SKAction.group([moveEnemy, rotate])
        
        let enemySequence = SKAction.sequence([group, deleteEnemy])
        enemy.run(enemySequence, withKey: "moveEnemy")
        
        
        
        
        //code for rotating new spawned items (i.e. later in game large missiles boss dad
        //let dx = endPoint.x - startPoint.x
        //let dy = endPoint.y - startPoint.y
        //let amountToRotate = atan2(dy, dx)
        
    }
    
    func moveBoss() {
        let newX = random(min: self.size.width * 0.2, max: self.size.width * 0.8)
        let newY = random(min: self.size.height * 0.5, max: self.size.height * 0.8)
        let newPoint = CGPoint(x: newX, y: newY)

        if bossHealth < 1000 && bossHealth > 700 && movementDone {
            bossx = newPoint.x
            let moveBoss = SKAction.move(to: newPoint, duration: 5)
            heart.run(moveBoss, withKey: "moveBoss")
            movementDone = false
            
            
        }
        else if bossHealth < 700 && bossHealth > 300 && movementDone  {
            bossx = newPoint.x
            let moveBoss = SKAction.move(to: newPoint, duration: 2)
            heart.run(moveBoss, withKey: "moveBoss")
            movementDone = false
        }
        else if bossHealth < 300 && bossHealth > 0 && movementDone  {
            bossx = newPoint.x
            let moveBoss = SKAction.move(to: newPoint, duration: 0.8)
            heart.run(moveBoss, withKey: "moveBoss")
            movementDone = false
        }
        
       
        
        if heart.position.x < bossx + 1 && heart.position.x > bossx - 1 {
            movementDone = true
            
        }        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDraggedX = pointOfTouch.x - previousPointOfTouch.x //distance between touch and player
            
            if (!pauseBool) {
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
        let spawningAction = action(forKey: "spawningEnemies")
        let spawningActionT2 = action(forKey: "spawningGhost")
        let spawningActionT3 = action(forKey: "spawningShip")
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            //button to return home is clicked
            if inPauseButton.contains(pointOfTouch) && pauseBool {
                let x = MainMenu(size: self.size)
                changeScene(nextScene: x)
            }
            
            if pauseButton.contains(pointOfTouch){
                
                if (pauseBool){
                    pauseBool = false
                    
                    //remove pause menu things
                    pauseBackground.removeFromParent()
                    inPauseButton.removeFromParent()
                    
                    //unpause enemy spawning
                    spawningAction?.speed = 1
                    spawningActionT2?.speed = 1
                    spawningActionT3?.speed = 1
                    
                    //unpause enemy movement
                    enumerateChildNodes(withName: "Enemy") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveEnemy")
                        movingAction?.speed = 1
                        
                        
                    }
                    enumerateChildNodes(withName: "Heart") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "begin")
                        movingAction?.speed = 1
                    
                    }
                    enumerateChildNodes(withName: "E1") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE1")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "E2") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE2")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "E3") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE3")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "E4") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE4")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "E1") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "rotateg4")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "E2") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "rotateg4")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "E3") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "rotateg4")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "E4") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "rotateg4")
                        movingAction?.speed = 1
                        
                    }
                    
                    enumerateChildNodes(withName: "Heart") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveBoss")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "Bullet") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveBullet")
                        movingAction?.speed = 1
                        
                    }
                    
                
                    enumerateChildNodes(withName: "Ship") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveBattleship")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "Ship") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "rotateShip")
                        movingAction?.speed = 1
                        
                    }
                    enumerateChildNodes(withName: "Player") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "spawning")
                        movingAction?.speed = 1
                    }
                    
                    
                    
                }
                else{
                    pauseBool = true
                    
                    pauseBackground.size = self.size
                    pauseBackground.position = CGPoint(x: self.size.width/2,
                                                       y: self.size.height/2)
                    pauseBackground.zPosition = 105
                    pauseBackground.name = "pauseBackground"
                    pauseBackground.alpha = 0.8
                    self.addChild(pauseBackground)
                    
                    inPauseButton.position = CGPoint(x: self.size.width/2,
                                                     y: self.size.height/2)
                    inPauseButton.zPosition = 106
                    inPauseButton.size.width = 700
                    inPauseButton.size.height = 100
                    self.addChild(inPauseButton)
                    
                    
                    //pause enemy spawning
                    spawningAction?.speed = 0
                    spawningActionT2?.speed = 0
                    spawningActionT3?.speed = 0
                    
                    
                    //PAUSE ENEMIES
                    enumerateChildNodes(withName: "Enemy") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveEnemy")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "Heart") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "begin")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "E1") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE1")
                        movingAction?.speed = 0
                    
                    }
                
                    enumerateChildNodes(withName: "E2") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE2")
                        movingAction?.speed = 0
                        
                    }
                
                    enumerateChildNodes(withName: "E3") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE3")
                        movingAction?.speed = 0
                        
                    }
                
                    enumerateChildNodes(withName: "E4") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveE4")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "E1") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "rotateg4")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "E2") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "rotateg4")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "E3") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "rotateg4")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "E4") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "rotateg4")
                        movingAction?.speed = 0
                        
                    }
                    
                    enumerateChildNodes(withName: "Heart") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveBoss")
                        movingAction?.speed = 0
                        
                    }
                    
          
                    enumerateChildNodes(withName: "Bullet") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveBullet")
                        movingAction?.speed = 0
                        
                    }
        
                    enumerateChildNodes(withName: "Ship") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "moveBattleship")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "Ship") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "rotateShip")
                        movingAction?.speed = 0
                        
                    }
                    enumerateChildNodes(withName: "Player") {
                        enemy, stop in
                        let movingAction = enemy.action(forKey: "spawning")
                        movingAction?.speed = 0
                    }
                }
                    
                    
            }
                
        }
            
    }
        
        
    


    var bossstart = false
    var didwin = true
    
    override func update(_ currentTime: TimeInterval) {
        if (!pauseBool) {
            if alive {
                if shoot && didwin && bossstart {
                    fireBullet()
                }
                
                if heart.position.y <= self.size.height * 0.7 {
                    bossstart = true
                }
                //updatePattern()
                
                if bossstart {
                    moveBoss()
                }
                
            
                if  playerLife < 0 {
                    
                    alive = false
                    dead = true
                    playerLife = 0
                    lifeLabel.text = "Life: \(playerLife)"
                    let printfail = SKAction.run(printFail)
                    //let waitToChange = SKAction.wait(forDuration: 3)
                    //let sceneChange = SKAction.run(changeScene)
                    
                    
                    //let changeSequence = SKAction.sequence([printfail, waitToChange, sceneChange])
                    
                    self.run(printfail)
                }
            }
            
            if bossHealth < 1 && didwin {
                win()
                self.removeAction(forKey: "spawningEnemies")
                self.removeAction(forKey: "spawningGhost")
                self.removeAction(forKey: "spawningShip")
                didwin = false
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
        
        
        
    }
    
    /*
    func changeScene() {
        
        let sceneToMoveTo = DatingSim(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
        
        
    }
    */
    
}
