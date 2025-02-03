class Game {
  int screen = -1; // Startet mit dem ersten Intro
  PImage ImageBackground_1;
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
  FirstIntroScreen firstIntroScreen;

  float transitionProgress = 0;
  boolean isTransitioning = false;
  int nextScreen = 0;

  Game() {
    enemies = new ArrayList<>();
    playerBullets = new ArrayList<>();
    enemyBullets = new ArrayList<>();
    powerUps = new ArrayList<>();
    firstIntroScreen = new FirstIntroScreen(this);
    introScreen = new IntroScreen(this);
    startScreen = new StartScreen(this);
    levelScreen = new LevelScreen(this);
    helpScreen = new HelpScreen(this);
    gameOverScreen = new GameOverScreen(this);
    winScreen = new WinScreen(this);
    player = new Player();
  }

  void setup() {
    ImageBackground_1 = loadImage("./data/Weltall-11.png");
    ImageBackground_1.resize(width, height);
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

  void renderScreen() {
    switch (screen) {
    case -1:
      firstIntroScreen.display();
      break;
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

  void keyPressed() {
    if (key == ENTER) {
      switch (screen) {
      case -1:
        triggerTransition(0); // Erstes Intro -> Startbildschirm
        break;
      case 0:
        triggerTransition(6); // Startbildschirm -> Zweites Intro
        break;
      case 6:
        triggerTransition(3); // Zweites Intro -> Spielstart
        break;
      case 4:
      case 5:
        resetGame();
        triggerTransition(0); // Game Over / Win -> Zurück zum Startbildschirm
        break;
      case 2:
        triggerTransition(0); // Hilfebildschirm -> Startbildschirm
        break;
      }
    }

    if (key == ' ') {
      player.shoot(playerBullets);
    }
  }

  void triggerTransition(int newScreen) {
    isTransitioning = true;
    nextScreen = newScreen;
  }

  void resetGame() {
    if (player == null) {
      player = new Player();
    } else {
      player.reset();
    }

    enemies.clear();
    playerBullets.clear();
    enemyBullets.clear();
    powerUps.clear();

    screen = -1; // Zurück zum ersten Intro
    if (gameOverScreen != null) {
      gameOverScreen.resetGame();
    }
  }

  void mousePressed() {
    // Falls sich das Spiel im Startbildschirm befindet
    if (screen == 0) {
      if (startScreen.startButton.isClicked()) {
        triggerTransition(6); // Wechsel zum zweiten Intro
      } else if (startScreen.helpButton.isClicked()) {
        triggerTransition(2); // Wechsel zum Hilfebildschirm
      }
    }

    // Falls sich das Spiel im Hilfebildschirm befindet
    else if (screen == 2) {
      if (helpScreen.backButton.isClicked()) {
        triggerTransition(0); // Zurück zum Startbildschirm
      }
    }

    // Falls sich das Spiel im Game-Over- oder Win-Bildschirm befindet
    else if (screen == 4 || screen == 5) {
      if (gameOverScreen.retryButton.isClicked() || winScreen.retryButton.isClicked()) {
        resetGame();
        triggerTransition(0);
      }
    }

    // Falls sich das Spiel im ersten Intro befindet
    else if (screen == -1) {
      triggerTransition(0);
    }

    // Falls sich das Spiel im zweiten Intro befindet
    else if (screen == 6) {
      triggerTransition(3); // Wechsel ins Spiel
    }
  }


  void playGame() {
    image(ImageBackground_1, 0, 0);
    player.update();
    player.display();
    drawHUD();

    // Gegner spawnen
    if (frameCount % 60 == 0) {
      enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
    }
    if (frameCount % (60 * 30) == 0) {
      enemies.add(new Boss(width / 2, 80, 50));
    }

    if (frameCount % 500 == 0) {
      powerUps.add(new PowerUp(random(50, width - 50), random(50, height - 200), (int) random(1, 3)));
    }

    // PowerUps verwalten
    for (int i = powerUps.size() - 1; i >= 0; i--) {
      PowerUp p = powerUps.get(i);
      p.display();
      if (p.isCollected(player.x, player.y)) {
        player.collectPowerUp(p);
        powerUps.remove(i);
      }
    }

    // Gegner verwalten
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
          triggerTransition(5); // Win Screen
        }
      }
    }

    // Spieler-Schüsse verwalten
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

    // Feind-Schüsse verwalten
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      Bullet b = enemyBullets.get(i);
      b.update();
      b.display();
      if (dist(b.x, b.y, player.x, player.y) < 15 && !player.shieldActive) {
        player.lives--;
        enemyBullets.remove(i);
        if (player.lives <= 0) {
          triggerTransition(4); // Game Over
        }
      }
      if (b.y > height) enemyBullets.remove(i);
    }
  }

  void renderTransition() {
    transitionProgress += 0.05; // Geschwindigkeit der Übergangsanimation

    if (transitionProgress >= 1) {
      isTransitioning = false;
      screen = nextScreen;
      transitionProgress = 0;
    } else {
      // Zeichne eine einfache Überblendung (z. B. schwarzer Fade-Effekt)
      fill(0, transitionProgress * 255);
      rect(0, 0, width, height);
    }
  }


  void drawHUD() {
    fill(40, 40, 40, 150);
    rect(0, 0, width, 50);

    fill(255);
    textSize(18);
    textAlign(LEFT, TOP);
    text("Score: " + player.score, 10, 10);
    text("Lives: " + player.lives, 10, 30);
    text("Shield: " + (player.shieldActive ? "ON" : "OFF"), width - 150, 10);
  }
}
