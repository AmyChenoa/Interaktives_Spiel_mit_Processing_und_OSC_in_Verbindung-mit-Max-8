class Game {
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
  float levelTime = 30;  // 30 Sekunden für jedes Level (beispiel)
  float timeRemaining;
  boolean levelCompleted = false;
  boolean gameStarted = false; // Der Timer wird erst nach Spielstart angezeigt

  // Fortschrittsbalken für den Level-Timer
  float levelTimeBarWidth = 500;
  float levelTimeBarHeight = 20;

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
    level = new Level(1); // Anfangslevel
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

    // Timer-Balken wird nur angezeigt, wenn das Level läuft
    if (gameStarted && !levelCompleted) {
      drawLevelTimerBar(20, 10, levelTimeBarWidth, levelTimeBarHeight);
    }
  }

  void drawLevelTimerBar(float x, float y, float width, float height) {
    if (!gameStarted) return; // Der Timer wird nur angezeigt, wenn das Spiel gestartet wurde

    // Hintergrund des Balkens mit Farbverlauf von grün nach rot
    color c1 = color(0, 255, 0); // Grün
    color c2 = color(255, 0, 0); // Rot
    for (float i = 0; i < width; i++) {
      float inter = map(i, 0, width, 0, 1);
      color interColor = lerpColor(c1, c2, inter);
      stroke(interColor);
      line(x + i, y, x + i, y + height);
    }

    // Fortschrittsbalken (gelb) für den verbleibenden Timer
    float progressWidth = map(timeRemaining, 0, levelTime, width, 0);
    fill(255, 204, 0, 180); // Weichere gelbe Farbe mit Transparenz
    noStroke();
    rect(x, y, progressWidth, height, 10); // Abgerundete Ecken für den Balken

    // Umrandung des Balkens
    stroke(255);
    noFill();
    rect(x, y, width, height, 10);
  }

  void startGame() {
    gameStarted = true; // Timer wird erst nach Spielstart sichtbar
  }


  void triggerTransition(int newScreen) {
    nextScreen = newScreen;  // Set the next screen
    isTransitioning = true;  // Start the transition
    transitionProgress = 0;  // Reset the transition progress
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

  void playGame() {
    image(backgroundImage, 0, 0);
    player.update();
    player.display();
    drawHUD();

    // Timer-Balken nur anzeigen, wenn das Level läuft
    if (gameStarted && !levelCompleted) {
      drawLevelTimerBar(20, 10, levelTimeBarWidth, levelTimeBarHeight);
    }

    // Spawne Gegner und handle Gameplay
    if (frameCount % level.spawnRate == 0) {
      for (int i = 0; i < level.enemyCount; i++) {
        enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
      }
    }

    // Timer Countdown
    if (!levelCompleted) {
      timeRemaining -= 1.0 / frameRate;
      if (timeRemaining <= 0) {
        levelCompleted = true;
        triggerTransition(5); // Zum Win-Screen wechseln
      }
    }



    // If the level has a boss, handle boss logic
    if (level.hasBoss) {
      for (int i = enemies.size() - 1; i >= 0; i--) {
        if (enemies.get(i) instanceof Boss) {
          Boss boss = (Boss) enemies.get(i);
          boss.takeDamage();
          if (boss.isDead()) {
            player.score += 500;
            enemies.remove(i);
            // Check for level win after defeating the boss
            levelCompleted = true;  // Mark the level as completed
            triggerTransition(5);  // Transition to win screen
            break;
          }
        }
      }
    }

    // Handle power-ups
    for (int i = powerUps.size() - 1; i >= 0; i--) {
      PowerUp p = powerUps.get(i);
      p.display();
      if (p.isCollected(player.x, player.y)) {
        player.collectPowerUp(p);
        powerUps.remove(i);
      }
    }

    // Handle enemies movement and shooting
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      e.update();
      e.display();
      if (frameCount % 30 == 0) e.shoot(enemyBullets);
      if (e.y > height) enemies.remove(i);
    }

    // Handle player bullets
    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      Bullet b = playerBullets.get(i);
      b.update();
      b.display();

      // Check for collisions between player bullets and enemies
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

    // Handle enemy bullets and check for collisions with the player
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      Bullet b = enemyBullets.get(i);
      b.update();
      b.display();
      if (dist(b.x, b.y, player.x, player.y) < 15 && !player.shieldActive) {
        player.lives--;
        enemyBullets.remove(i);
        if (player.lives <= 0) {
          triggerTransition(4);  // Game over if player runs out of lives
        }
      }
    }

    // Timer countdown logic
    if (!levelCompleted) {
      timeRemaining -= 1.0 / frameRate;  // Decrease the time remaining based on frame rate
      if (timeRemaining <= 0) {
        // Level is completed if time runs out
        levelCompleted = true;
        triggerTransition(5);  // Transition to win screen
      }
    }
  }

  void drawTimerBar() {
    float barWidth = width;
    float barHeight = 10;
    float timerProgress = timeRemaining / levelTime;

    // Balken zeichnen
    fill(255, 0, 0);
    noStroke();
    rect(0, 0, barWidth * timerProgress, barHeight);

    // Optional: Umrandung des Balkens
    stroke(255);
    noFill();
    rect(0, 0, barWidth, barHeight);
  }

  boolean bulletHitsEnemy(Bullet bullet, Enemy enemy) {
    return dist(bullet.x, bullet.y, enemy.x, enemy.y) < enemy.size / 2;
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
    fill(0, 255, 255);
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
