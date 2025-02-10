class Game {
  int highScore;
  boolean campaignMode = false; // Kampagnenmodus deaktiviert (Einzellevel)
  PApplet parent;
  int screen = 0;
  PImage backgroundImage;
  ArrayList<Enemy> enemies;
  ArrayList<Bullet> playerBullets;
  ArrayList<Bullet> enemyBullets;
  ArrayList<PowerUp> powerUps;

  Player player;
  StartScreen startScreen;
  LevelScreen levelScreen;
  HelpScreen helpScreen;
  GameOverScreen gameOverScreen;
  WinScreen winScreen;
  IntroScreen introScreen;

  Level level;
  float transitionProgress = 0;
  boolean isTransitioning = false;
  int nextScreen = 0;

  // Level-spezifische Timer
  HashMap<Integer, Float> levelTimers;
  float timeRemaining;
  boolean levelCompleted = false;
  boolean gameStarted = false;

  // Fortschrittsbalken
  float levelTimeBarWidth = 500;
  float levelTimeBarHeight = 20;
  float levelTimeBarX = 300;
  float levelTimeBarY = 15;

  Game() {
    enemies = new ArrayList<>();
    playerBullets = new ArrayList<>();
    enemyBullets = new ArrayList<>();
    powerUps = new ArrayList<>();
    startScreen = new StartScreen(this);
    levelScreen = new LevelScreen(this);
    helpScreen = new HelpScreen(this);
    gameOverScreen = new GameOverScreen(this);
    winScreen = new WinScreen(this);
    introScreen = new IntroScreen(this);
    player = new Player();
    level = new Level(1);

    loadHighScore();

    // Level-Timer setzen
    levelTimers = new HashMap<>();
    for (int i = 1; i <= 9; i++) {
      levelTimers.put(i, 30.0); // Standardzeit pro Level (kann angepasst werden)
    }
  }

  void loadHighScore() {
    try {
      String[] data = loadStrings("highscore.txt");
      if (data != null && data.length > 0) {
        highScore = Integer.parseInt(data[0].trim());
      }
    }
    catch (Exception e) {
      highScore = 0;
    }
  }

  void saveHighScore() {
    String[] data = {str(highScore)};
    saveStrings("highscore.txt", data);
  }

  void setup() {
    backgroundImage = level.background;
    backgroundImage.resize(width, height);
    resetGame();
    frameRate(60);
    timeRemaining = levelTimers.get(level.levelNumber);
  }

  void draw() {
    if (isTransitioning) {
      renderTransition();
    } else {
      if (backgroundImage != null) {
        backgroundImage.resize(width, height);
        image(backgroundImage, 0, 0, width, height);
      } else {
        println(" Kein Hintergrundbild gesetzt!");
      }
      renderScreen();
    }
  }
  void drawLevelTimerBar(float x, float y, float height) {
    if (screen != 3) return;  // Timer nur im Spiel anzeigen

    float margin = 20;
    float barWidth = width - (x + margin);  // Stelle sicher, dass der Fortschrittsbalken nicht falsch berechnet wird

    y += 20;  // Nach unten verschieben

    fill(255);
    textSize(16);
    textAlign(CENTER, CENTER);  // Jetzt ist der Text mittig über der Leiste
    text("Remaining Time", x + barWidth / 2, y - 15);

    float progressWidth = map(timeRemaining, 0, levelTimers.get(level.levelNumber), barWidth, 0);

    // Hintergrund-Balken
    fill(220, 220, 220, 150);
    noStroke();
    rect(x, y, barWidth, height, 10);

    // Fortschrittsbalken
    fill(255, 165, 0, 220);
    rect(x, y, progressWidth, height, 10);
  }


  void startGame() {
    gameStarted = true;
  }

  void triggerTransition(int newScreen) {
    nextScreen = newScreen;
    isTransitioning = true;
    transitionProgress = 0;
  }

  void renderTransition() {
    transitionProgress = lerp(transitionProgress, 1, 0.1);
    if (transitionProgress > 0.99) {
      isTransitioning = false;
      screen = nextScreen;
      transitionProgress = 0;
      println("Transition beendet! Neuer Screen: " + screen);
    }


    float fadeOutAlpha = map(transitionProgress, 0, 1, 255, 0);
    float fadeInAlpha = map(transitionProgress, 0, 1, 0, 255);

    pushStyle();

    // Nur während der Transition Transparenz anwenden
    if (isTransitioning) {
      tint(255, fadeOutAlpha);
      renderScreenContent(screen);
      tint(255, fadeInAlpha);
      renderScreenContent(nextScreen);
    } else {
      renderScreenContent(screen);
    }

    popStyle();
  }

  void renderScreen() {
    renderScreenContent(screen);
  }

  void renderScreenContent(int currentScreen) {
    println("Aktueller Screen: " + currentScreen);  // Debugging

    switch (currentScreen) {
    case 0:
      startScreen.display();
      break;
    case 1:
      levelScreen.display();
      break;
    case 2:
      helpScreen.display();
      break;
    case 3:
      playGame();
      break;
    case 4:
      gameOverScreen.display(player.score);
      break;
    case 5:
      println("WinScreen wird gezeichnet!");
      winScreen.display(player.score);
      break;
    case 6:
      introScreen.update();
      break;
    }
  }

  void switchLevel(int newLevelNumber) {
    level = new Level(newLevelNumber);
    level.initializeLevel(this);
    backgroundImage = level.background;
    timeRemaining = levelTimers.get(newLevelNumber);
    gameStarted = true;
  }



  void playGame() {
    if (backgroundImage != null) {
      backgroundImage.resize(width, height);
      image(backgroundImage, 0, 0);
    } else {
      println("Kein Hintergrundbild in playGame() gesetzt!");
    }


    if (gameStarted && timeRemaining > 0) {
      timeRemaining -= 1 / frameRate;
    }

    drawLevelTimerBar(levelTimeBarX, levelTimeBarY, levelTimeBarHeight);

    player.update();
    player.display();
    drawHUD();

    if (timeRemaining <= 0) {
      levelCompleted = true;
      if (campaignMode) {
        if (level.levelNumber < 9) {
          switchLevel(level.levelNumber + 1);  // Nächstes Level in der Kampagne
        } else {
          triggerTransition(5);  // Spiel gewonnen
        }
      } else {
        triggerTransition(5);  // Nur ein Level gespielt -> Gewonnen-Bildschirm
      }
    }

    // Feinde spawnen
    if (frameCount % level.spawnRate == 0) {
      for (int i = 0; i < level.enemyCount; i++) {
        enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
      }
    }


    // Feinde und Power-Ups aktualisieren
    for (int i = powerUps.size() - 1; i >= 0; i--) {
      PowerUp p = powerUps.get(i);
      p.display();
      if (p.isCollected(player.x, player.y)) {
        player.collectPowerUp(p);
        powerUps.remove(i);
      }
    }

    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      e.update();
      e.display();
      if (frameCount % 30 == 0) e.shoot(enemyBullets);
      if (e.y > height) enemies.remove(i);
    }

    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      Bullet b = playerBullets.get(i);
      b.update();
      b.display();

      for (int j = enemies.size() - 1; j >= 0; j--) {
        Enemy e = enemies.get(j);
        if (bulletHitsEnemy(b, e)) {
          enemies.remove(j);
          playerBullets.remove(i);
          player.score += 10;
          break;
        }
      }
    }

    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      Bullet b = enemyBullets.get(i);
      b.update();
      b.display();
      if (dist(b.x, b.y, player.x, player.y) < 15 && !player.shieldActive) {
        player.lives--;
        enemyBullets.remove(i);
        if (player.lives <= 0) {
          triggerTransition(4);
        }
      }
    }
  }


  boolean bulletHitsEnemy(Bullet bullet, Enemy enemy) {
    return dist(bullet.x, bullet.y, enemy.x, enemy.y) < enemy.size / 2;
  }


  void mousePressed() {
    if (screen == 0) startScreen.mousePressed();
    else if (screen == 1) levelScreen.mousePressed();
    else if (screen == 2) helpScreen.mousePressed();
    else if (screen == 6) introScreen.keyPressed();
    else if (screen == 4 || screen == 5) {  // Falls GameOverScreen oder WinScreen aktiv ist
      resetGame();
      triggerTransition(0);  // Zurück zum Startbildschirm
    }
  }


  void keyPressed() {
    if (screen == 0 && key == ENTER) {
      campaignMode = true;
      triggerTransition(6);
      startGame();
    }
    if (screen == 6 && key == ENTER) {
      triggerTransition(3);
      startGame();
    }
    if (screen == 4 && key == ENTER || key == '\n') {  // Game Over
      println("ENTER gedrückt! Zurück zum Startbildschirm.");
      resetGame();
      triggerTransition(0);
      redraw();
    }
    println("Taste gedrückt: " + key + " | Screen: " + screen);

    if (screen == 5 && (key == ENTER || key == '\n')) {
      println("ENTER erkannt! Reset wird ausgeführt.");
      resetGame();
      triggerTransition(0);
      redraw();
      println("Taste gedrückt: " + key + " | Screen: " + screen);
    }

    if (screen == 3 && key == ' ') {
      player.shoot(playerBullets);
    }
  }

  void resetGame() {
    println("resetGame() wurde aufgerufen!");

    // Spieler zurücksetzen
    player.reset();

    // Listen leeren
    enemies.clear();
    playerBullets.clear();
    enemyBullets.clear();
    powerUps.clear();

    // Level zurücksetzen
    level = new Level(1);
    timeRemaining = levelTimers.get(1);

    // Spielvariablen zurücksetzen
    levelCompleted = false;
    gameStarted = false;
    transitionProgress = 0;
    isTransitioning = false;

    // Highscore speichern
    saveHighScore();


    // Screen zurücksetzen
    screen = 0;
    println("Spiel zurückgesetzt. Neuer Screen: " + screen);

    // Bildschirm neu zeichnen
    redraw();
  }



  void drawLives(float x, float y, float width, int lives) {
    for (int i = 0; i < lives; i++) {
      float xPos = x + i * (width + 8);
      fill(255, 0, 0);
      noStroke();
      beginShape();
      vertex(xPos, y);
      bezierVertex(xPos - width / 2, y - width / 2, xPos - width, y + width / 2, xPos, y + width);
      bezierVertex(xPos + width, y + width / 2, xPos + width / 2, y - width / 2, xPos, y);
      endShape(CLOSE);
    }
    // Power-Up-Timer nur anzeigen, wenn aktiv
    if (player.shieldTimer > frameCount) {
      drawPowerUpTimer(20, 80, 230, 12, player.shieldTimer - frameCount, player.maxShieldTimer, color(100, 180, 255)); // Blau für Schild
    }
    if (player.multiShotTimer > frameCount) {
      drawPowerUpTimer(20, 100, 230, 12, player.multiShotTimer - frameCount, player.maxMultiShotTimer, color(150, 255, 100)); // Grün für Multi-Shot
    }
  }

  void drawHUD() {
    rectMode(CORNER);  // Wichtig! Stelle sicher, dass `rect()` von der oberen linken Ecke aus gezeichnet wird
    fill(40, 40, 40, 200);
    noStroke();
    rect(10, 10, 270, 120, 20);

    fill(255);
    textSize(24);
    textAlign(CENTER, TOP);
    text("Punkte: " + player.score, 145, 20);

    drawLives(100, 50, 22, player.lives);
  }

  // Power-Up Timer für ein aktives Power-Up
  void drawPowerUpTimer(float x, float y, float barWidth, float barHeight, float timer, float maxTimer, color barColor) {
    float timerProgress = timer / maxTimer; // Berechne den Fortschritt des Timers

    // Timer-Balken (innerer farbiger Bereich)
    fill(barColor);
    rect(x, y, barWidth * timerProgress, barHeight, 6); // Timer-Balken nur mit fortschreitendem Wert

    // Weiße Umrandung
    stroke(255);
    noFill();
    rect(x, y, barWidth, barHeight, 6); // Weiße Umrandung
  }
}
