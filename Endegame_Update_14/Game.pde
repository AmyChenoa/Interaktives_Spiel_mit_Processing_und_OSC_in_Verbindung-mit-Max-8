class Game {
  PApplet parent;
  int screen = 0;
  PImage backgroundImage;
  ArrayList<Enemy> enemies;
  ArrayList<Bullet> playerBullets;
  ArrayList<Bullet> enemyBullets;
  ArrayList<PowerUp> powerUps;
  ArrayList<Platform> platforms;

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

  // Timer-Variablen
  float levelTime = 30;
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
    platforms = new ArrayList<>();
    startScreen = new StartScreen(this);
    levelScreen = new LevelScreen(this);
    helpScreen = new HelpScreen(this);
    gameOverScreen = new GameOverScreen(this);
    winScreen = new WinScreen(this);
    introScreen = new IntroScreen(this);
    player = new Player();
    level = new Level(1);
  }

  void setup() {
    backgroundImage = loadImage("./data./Weltall-1.png");
    backgroundImage.resize(width, height);
    resetGame();
    frameRate(60);
    timeRemaining = levelTime;
  }

  void draw() {
    if (isTransitioning) {
      renderTransition();
    } else {
      renderScreen();
    }
  }


  void drawLevelTimerBar(float x, float y, float height) {
    if (!gameStarted || screen != 3) return;  // Timer nur im Spiel anzeigen

    // Set margin to move the bar slightly away from the right edge
    float margin = 20;
    // Berechne die Breite des Balkens, basierend auf der verbleibenden Zeit, mit einem Abstand vom rechten Rand
    float barWidth = width - x - margin;  // Subtract the margin from the right

    // Alles nach unten verschieben
    y += 20;

    // Überschrift über dem Balken
    fill(255);
    textSize(16);
    textAlign(LEFT, CENTER);
    text("Remaining Time", x, y - 15);

    // Berechne die Breite des Fortschrittsbalkens
    float progressWidth = map(timeRemaining, 0, levelTime, barWidth, 0);

    // Hintergrund-Balken (hellgrau, weich)
    fill(220, 220, 220, 150);  // Transparenz auf 150 setzen, damit es sichtbar ist
    noStroke();
    rect(x, y, barWidth, height, 10);

    // Farbverlauf von Hellgrün nach Hellrot
    for (float i = 0; i < barWidth; i++) {
      float inter = map(i, 0, barWidth, 0, 1);
      color interColor = lerpColor(color(144, 238, 144), color(255, 140, 140), inter);
      stroke(interColor);
      line(x + i, y, x + i, y + height);
    }

    // Fortschrittsbalken (kräftiges Gelb-Orange)
    fill(255, 165, 0, 220);  // Diese Farbe ist jetzt mehr sichtbar
    noStroke();
    rect(x, y, progressWidth, height, 10);
  }


  void startGame() {
    gameStarted = true;
  }
  void triggerTransition(int newScreen) {
    nextScreen = newScreen;
    isTransitioning = true;
    transitionProgress = 0;

    // Aktualisiere das Hintergrundbild, wenn der Level gewechselt wird
    if (newScreen == 3) {  // Wenn wir ins Spiel (Level) wechseln
      backgroundImage = loadImage("./data./background" + level.getLevelNumber() + ".png");
      backgroundImage.resize(width, height); // An die Fenstergröße anpassen
    }
  }

  void renderTransition() {
    transitionProgress = lerp(transitionProgress, 1, 0.1);
    if (transitionProgress > 0.99) {
      isTransitioning = false;
      screen = nextScreen;
      transitionProgress = 0;
    }
    float fadeOutAlpha = map(transitionProgress, 0, 1, 255, 0);
    float fadeInAlpha = map(transitionProgress, 0, 1, 0, 255);
    pushStyle();
    tint(255, fadeOutAlpha);
    renderScreenContent(screen);
    tint(255, fadeInAlpha);
    renderScreenContent(nextScreen);
    popStyle();
  }

  void renderScreen() {
    renderScreenContent(screen);
  }

  void renderScreenContent(int currentScreen) {
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
      winScreen.display(player.score);
      break;
    case 6:
      introScreen.update();
      break;
    }
  }

  void playGame() {
    image(backgroundImage, 0, 0);
    player.update();
    player.display();
    drawHUD();

    // Call drawLevelTimerBar with proper arguments
    drawLevelTimerBar(levelTimeBarX, levelTimeBarY, levelTimeBarHeight);

    if (frameCount % level.spawnRate == 0) {
      for (int i = 0; i < level.enemyCount; i++) {
        enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
      }
    }

    if (!levelCompleted) {
      timeRemaining -= 1.0 / frameRate;
      if (timeRemaining <= 0) {
        levelCompleted = true;
        triggerTransition(5);
      }
    }

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
  }

  void keyPressed() {
    if (screen == 0 && key == ENTER) {
      triggerTransition(6); // Transition to intro screen
      startGame();  // Start the game
    }
    if (screen == 6 && key == ENTER) {
      triggerTransition(3);  // Transition to the gameplay screen
      startGame();  // Start the game
    }
    if ((screen == 4 || screen == 5) && key == ENTER) {
      resetGame();
      triggerTransition(0); // Go back to the start screen
    }
    if (screen == 3 && key == ' ') {
      player.shoot(playerBullets);  // Player shooting action
    }
  }

  void resetGame() {
    player.reset();
    enemies.clear();
    playerBullets.clear();
    enemyBullets.clear();
    powerUps.clear();
    platforms.clear();
    levelCompleted = false;
    screen = 0;
    timeRemaining = levelTime;
    gameStarted = false;
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
  }

  void drawHUD() {
    fill(40, 40, 40, 200);
    noStroke();
    rect(10, 10, 270, 120, 20);
    fill(255);
    textSize(24);
    textAlign(CENTER, TOP);
    text("Punkte: " + player.score, 145, 20);
    drawLives(100, 50, 22, player.lives);
  }



  void drawPowerUpTimer(float x, float y, float barWidth, float barHeight, float timer, float maxTimer, color barColor) {
    float timerProgress = timer / maxTimer;
    fill(barColor);
    rect(x, y, barWidth * timerProgress, barHeight, 6);
    stroke(255);
    noFill();
    rect(x, y, barWidth, barHeight, 6);
    // Timer-Balken (innerer farbiger Bereich)
    fill(barColor);
    rect(x, y, barWidth * timerProgress, barHeight, 6); // Timer-Balken nur mit fortschreitendem Wert

    // Weiße Umrandung
    stroke(255);
    noFill();
    rect(x, y, barWidth, barHeight, 6); // Weiße Umrandung
  }
}
