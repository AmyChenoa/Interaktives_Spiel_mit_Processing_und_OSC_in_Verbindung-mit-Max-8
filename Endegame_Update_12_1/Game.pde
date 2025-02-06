class Game {
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

    level = new Level(1, 6, 90, false); // Anfangslevel
  }

  void setup() {
    backgroundImage = loadImage("./data./Weltall-1.png");
    backgroundImage.resize(width, height);
    resetGame();
    frameRate(60);
  }

  void draw() {
    if (isTransitioning) {
      renderTransition();
    } else {
      renderScreen();
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

  void mousePressed() {
    if (screen == 0) startScreen.mousePressed();
    else if (screen == 1) levelScreen.mousePressed();
    else if (screen == 2) helpScreen.mousePressed();
    else if (screen == 6) introScreen.keyPressed();
  }

  void keyPressed() {
    if (screen == 0 && key == ENTER) {
      triggerTransition(6);
    }
    if (screen == 6 && key == ENTER) {
      triggerTransition(3);
    }
    if ((screen == 4 || screen == 5) && key == ENTER) {
      resetGame();
      triggerTransition(0);
    }
    if (screen == 3 && key == ' ') {
      player.shoot(playerBullets);
    }
  }

  void triggerTransition(int newScreen) {
    isTransitioning = true;
    nextScreen = newScreen;
  }

  void resetGame() {
    player.reset();
    enemies.clear();
    playerBullets.clear();
    enemyBullets.clear();
    powerUps.clear();
    screen = 0;
  }

  void playGame() {
    image(backgroundImage, 0, 0);
    player.update();
    player.display();
    drawHUD();

    if (frameCount % level.spawnRate == 0) {
      for (int i = 0; i < level.enemyCount; i++) {
        enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
      }
    }

    if (level.hasBoss) {
      for (int i = enemies.size() - 1; i >= 0; i--) {
        if (enemies.get(i) instanceof Boss) {
          Boss boss = (Boss) enemies.get(i);
          boss.takeDamage();
          if (boss.isDead()) {
            player.score += 500;
            enemies.remove(i);
            triggerTransition(5);
            break;
          }
        }
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
