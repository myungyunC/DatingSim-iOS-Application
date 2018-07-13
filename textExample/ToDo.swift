//To Do:
//
//2: configure pause menu for games
//1: add most updated version of games
//5: say the beginning of the day each day
//6: BUG WITH PAUSE MENU. If you quit with the pause menu in dating sim part. Then when you load up a day, it will act as if the pause menu is still up.
// TEXT GROUP BEFORE MAKING CHANGE




///////////////////////////////////////////////////////// pre boss pause config
//
////button to return home is clicked
//if inPauseButton.contains(pointOfTouch) {
//    let x = MainMenu(size: self.size)
//    changeScene(nextScene: x)
//}
//
////button to save is clicked
//if inSaveButton.contains(pointOfTouch) {
//    Day1Save = true
//    Day2Save = true
//    Day3Save = false
//    Day4SaveUnder100 = false
//    Day4SaveOver100 = false
//}
//
//
////pause/resume button clicked
//if pauseButton.contains(pointOfTouch){
//    
//    if (pauseBool){
//        pauseBool = false
//        
//        //remove pause menu things so as to not Monstrously fuck up dis SHIIIIIITTTTTT mothafuckaaaaa PICKKLEEE RICKKKKKKK
//        removePauseMenu(scene: self)
//        
//        //unpause enemy spawning
//        spawningAction?.speed = 1
//        spawningActionT2?.speed = 1
//        spawningActionT3?.speed = 1
//        
//        enumerateChildNodes(withName: "Player") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "won")
//            movingAction?.speed = 1
//        }
//        
//        //unpause enemy movement
//        enumerateChildNodes(withName: "Enemy") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "moveE1")
//            movingAction?.speed = 1
//            
//            
//        }
//        enumerateChildNodes(withName: "EnemyT2") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "moveE2")
//            movingAction?.speed = 1
//            
//        }
//        enumerateChildNodes(withName: "EnemyT3") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "moveE3")
//            movingAction?.speed = 1
//            
//        }
//        
//        //unpause bullets
//        enumerateChildNodes(withName: "ShotType1") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "fireEnemyBullet1")
//            movingAction?.speed = 1
//            
//        }
//        enumerateChildNodes(withName: "Bullet") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "firePlayerBullet")
//            movingAction?.speed = 1
//            
//        }
//        enumerateChildNodes(withName: "ShotType2") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "FireT2Right")
//            movingAction?.speed = 1
//            
//        }
//        enumerateChildNodes(withName: "ShotType2l") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "FireT2Left")
//            movingAction?.speed = 1
//            
//        }
//        enumerateChildNodes(withName: "plasmaShot") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "fireT3")
//            movingAction?.speed = 1
//            
//        }
//        enumerateChildNodes(withName: "plasmaShot") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "shot3")
//            movingAction?.speed = 1
//            
//        }
//        
//        
//        
//        
//    }
//    else{
//        spawnPauseMenu(scene: self)
//        
//        
//        //pause enemy spawning
//        spawningAction?.speed = 0
//        spawningActionT2?.speed = 0
//        spawningActionT3?.speed = 0
//        
//        enumerateChildNodes(withName: "Player") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "won")
//            movingAction?.speed = 0
//        }
//        
//        //PAUSE ENEMIES
//        enumerateChildNodes(withName: "Enemy") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "moveE1")
//            movingAction?.speed = 0
//            
//            
//        }
//        enumerateChildNodes(withName: "EnemyT2") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "moveE2")
//            movingAction?.speed = 0
//            
//        }
//        enumerateChildNodes(withName: "EnemyT3") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "moveE3")
//            movingAction?.speed = 0
//            
//        }
//        
//        //PAUSE BULLETS
//        enumerateChildNodes(withName: "ShotType1") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "fireEnemyBullet1")
//            movingAction?.speed = 0
//            
//        }
//        enumerateChildNodes(withName: "Bullet") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "firePlayerBullet")
//            movingAction?.speed = 0
//            
//        }
//        enumerateChildNodes(withName: "ShotType2") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "FireT2Right")
//            movingAction?.speed = 0
//            
//        }
//        enumerateChildNodes(withName: "ShotType2l") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "FireT2Left")
//            movingAction?.speed = 0
//            
//        }
//        enumerateChildNodes(withName: "plasmaShot") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "fireT3")
//            movingAction?.speed = 0
//            
//        }
//        enumerateChildNodes(withName: "plasmaShot") {
//            enemy, stop in
//            let movingAction = enemy.action(forKey: "shot3")
//            movingAction?.speed = 0
//            
//        }
//        
//        
//    }
//    
//}
