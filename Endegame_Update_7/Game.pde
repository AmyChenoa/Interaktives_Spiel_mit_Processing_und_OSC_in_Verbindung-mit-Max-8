import java.util.ArrayList;

class Game {
  int screen = 0;
  PImage ImageBackground_1;
  ArrayList<Enemy> enemies;
  ArrayList<Bullet> playerBullets;
  ArrayList<Bullet> enemyBullets;
  ArrayList<PowerUp> powerUps;

  LevelManager levelManager;
  Level currentLevel;
  Player player;
  StartScreen startScreen;
  LevelScreen levelScreen;
  HelpScreen helpScreen;
  GameOverScreen gameOverScreen;
  WinScreen winScreen;
  IntroScreen introScreen;

  float transitionProgress = 0;
  boolean isTransitioning = false;
  int nextScreen = 0;

  Game() {
    // Initialisiere alle notwendigen Objekte und Listen
    enemies = new ArrayList<>();
    playerBullets = new ArrayList<>();
    enemyBullets = new ArrayList<>();
    powerUps = new ArrayList<>();

    startScreen = new StartScreen(this);
    levelScreen = new LevelScreen(this);
    helpScreen = new HelpScreen(this);
    gameOverScreen = new GameOverScreen(this, 0);  // Anfangspunkte = 0
    winScreen = new WinScreen(this);
    introScreen = new IntroScreen(this);
    levelManager = new LevelManager();

    player = new Player();  // Initialisiere den Spieler hier
  }

  void setup() {
  ImageBackground_1 = loadImage("./data./Weltall-1.png");
    // Sicherstellen, dass das Bild korrekt geladen wurde
    if (ImageBackground_1 == null) {
      println("Error: Background image could not be loaded!");
    } else {
      println("Background image loaded successfully.");
    }
    ImageBackground_1.resize(width, height);
    resetGame();  // Spiel zurücksetzen
    frameRate(60);
  }

  void draw() {
    if (isTransitioning) {
      renderTransition();
    } else {
      renderScreen();
    }
  }

  void startLevel(int levelNumber) {
    currentLevel = levelManager.getLevel(levelNumber);
    if (currentLevel == null) {
      println("Error: Level could not be loaded!");
      return;
    }
    setupLevel();
  }

  void setupLevel() {
    background(loadImage(currentLevel.backgroundImagePath));
    enemies.clear();
    for (int i = 0; i < currentLevel.enemyCount; i++) {
      enemies.add(new Enemy(random(30, width - 30), random(20, 100), currentLevel.enemySpeed));
    }
    if (currentLevel.bossHealth > 0) {
      enemies.add(new Boss(width / 2, 80, currentLevel.bossHealth));
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
      gameOverScreen.update();
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
      playerShoot();
    }
  }

  void triggerTransition(int newScreen) {
  isTransitioning = true;
  nextScreen = newScreen;
}

  void resetGame() {
    if (player == null) {
      player = new Player();  // Sicherstellen, dass der Spieler existiert
    }
    player.reset();  // Reset für Spieler
    enemies.clear();
    playerBullets.clear();
    enemyBullets.clear();
    powerUps.clear();
    screen = 0;
  }

  void playerShoot() {
    Bullet b = new Bullet(player.x, player.y, 0, -10, color(255, 0, 0));
    playerBullets.add(b);
  }

  void playGame() {
    image(ImageBackground_1, 0, 0);
    player.update();
    player.display();
    drawHUD();

    if (frameCount % 60 == 0) {
      enemies.add(new Enemy(random(30, width - 30), random(20, 100), currentLevel.enemySpeed));
    }

    if (frameCount % (60 * 30) == 0) {
      enemies.add(new Boss(width / 2, 80, 50));
    }

    if (frameCount % 500 == 0) {
      powerUps.add(new PowerUp(random(50, width - 50), random(50, height - 200), (int) random(1, 3)));
    }

    // PowerUps anzeigen und sammeln
    for (int i = powerUps.size() - 1; i >= 0; i--) {
      PowerUp p = powerUps.get(i);
      p.display();
      if (p.isCollected(player.x, player.y)) {
        player.collectPowerUp(p);
        powerUps.remove(i);
      }
    }

    // Gegner bewegen und schießen
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      e.update();
      e.display();
      if (frameCount % 30 == 0) e.shoot(enemyBullets);
      if (e.y > height) enemies.remove(i);

      if (e instanceof Boss) {
        Boss boss = (Boss) e;
        boss.takeDamage();
        if (boss.isDead()) {
          enemies.remove(i);
          player.score += 500;
          triggerTransition(5);
        }
      }
    }

    // Spielerprojektile bewegen und Kollisionen überprüfen
    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      Bullet b = playerBullets.get(i);
      b.update();
      b.display();
      for (int j = enemies.size() - 1; j >= 0; j--) {
        Enemy e = enemies.get(j);
        if (dist(b.x, b.y, e.x, e.y) < e.size / 2) {
          enemies.remove(j);
          player.score += 10;
          playerBullets.remove(i);
          break;
        }
      }
      if (b.y < 0) playerBullets.remove(i);
    }

    // Gegnerprojektile bewegen und Kollisionen mit dem Spieler überprüfen
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
      if (b.y > height) enemyBullets.remove(i);
    }
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
}
