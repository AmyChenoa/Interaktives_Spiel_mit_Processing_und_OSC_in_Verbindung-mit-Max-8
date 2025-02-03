class Game {
  int screen = 0; // 0 = Start, 1 = Level, 2 = Help, 3 = Game, 4 = Game Over, 5 = Win, 6 = Intro
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
  IntroScreen introScreen;  // IntroScreen Objekt

  float transitionProgress = 0; // Fortschritt des Übergangs
  boolean isTransitioning = false; // Flag für den Übergang
  int nextScreen = 0; // Nächster Bildschirm

  Game() {
    enemies = new ArrayList<>();
    playerBullets = new ArrayList<>();
    enemyBullets = new ArrayList<>();
    powerUps = new ArrayList<>();
    startScreen = new StartScreen(this);
    levelScreen = new LevelScreen(this);
    helpScreen = new HelpScreen(this);
    gameOverScreen = new GameOverScreen();
    winScreen = new WinScreen(this);
    introScreen = new IntroScreen(this);  // Initialisiere IntroScreen
    player = new Player();
  }

  void setup() {
    ImageBackground_1 = loadImage("./data./Weltall-1.png");
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

  void renderTransition() {
    transitionProgress += 0.05; // Übergangsfortschritt
    if (transitionProgress >= 1) {
      isTransitioning = false; // Übergang abgeschlossen
      screen = nextScreen; // Bildschirm wechseln
      transitionProgress = 0;
    }

    // Render den aktuellen und nächsten Screen übereinander mit Fade-Effekt
    float fadeOutAlpha = map(transitionProgress, 0, 1, 255, 0);
    float fadeInAlpha = map(transitionProgress, 0, 1, 0, 255);

    pushStyle();

    // Aktuellen Bildschirm zeichnen
    tint(255, fadeOutAlpha);
    renderScreenContent(screen);

    // Nächsten Bildschirm zeichnen
    tint(255, fadeInAlpha);
    renderScreenContent(nextScreen);

    popStyle();

    // Zusätzliche Spirale für den Übergangseffekt
    renderSpiralEffect();
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
      introScreen.update();  // Intro aktualisieren und anzeigen
      break;
    }
  }

  void renderSpiralEffect() {
    pushMatrix();
    translate(width / 2, height / 2); // Mitte des Bildschirms

    float spiralStrength = map(transitionProgress, 0, 1, 10, 0); // Spirale kleiner werden lassen
    float radius = dist(0, 0, width / 2, height / 2);
    float angleOffset = frameCount * 0.1; // Spirale rotiert

    noFill();
    stroke(0, 100, 255, map(transitionProgress, 0, 1, 255, 0));
    strokeWeight(2);

    for (float angle = 0; angle < TWO_PI * 4; angle += 0.1) {
      float r = radius * (1 - angle / (TWO_PI * 4));
      float x = r * cos(angle + angleOffset) * spiralStrength;
      float y = r * sin(angle + angleOffset) * spiralStrength;
      point(x, y);
    }

    popMatrix();
  }

  void mousePressed() {
    if (screen == 0) startScreen.mousePressed();
    else if (screen == 1) levelScreen.mousePressed();
    else if (screen == 2) helpScreen.mousePressed();
    else if (screen == 6) introScreen.keyPressed();  // Intro-Reaktion bei Tastendruck
  }

  void keyPressed() {
    if (screen == 0 && key == ENTER) {
      triggerTransition(6); // Übergang zum Intro-Bildschirm
    }
    if (screen == 6 && key == ENTER) {
      triggerTransition(3); // Übergang zum Spiel nach dem Intro
    }
    if ((screen == 4 || screen == 5) && key == ENTER) {
      resetGame(); // Zurück zum Startbildschirm nach dem Ende
      triggerTransition(0);
    }
  }

  void triggerTransition(int newScreen) {
    isTransitioning = true; // Übergang aktivieren
    nextScreen = newScreen; // Nächsten Bildschirm festlegen
  }

  void resetGame() {
    player.reset();
    enemies.clear();
    playerBullets.clear();
    enemyBullets.clear();
    powerUps.clear();
    screen = 0; // Zurück zum Startbildschirm
  }

  void playGame() {
    image(ImageBackground_1, 0, 0);
    player.update();
    player.display();
    drawHUD();

    // Erstelle Feinde und Power-ups
    if (frameCount % 60 == 0) enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
    if (frameCount % (60 * 30) == 0) enemies.add(new Boss(width / 2, 80, 50));

    if (frameCount % 500 == 0) powerUps.add(new PowerUp(random(50, width - 50), random(50, height - 200), (int) random(1, 3)));

    // Power-ups abarbeiten
    for (int i = powerUps.size() - 1; i >= 0; i--) {
      PowerUp p = powerUps.get(i);
      p.display();
      if (p.isCollected(player.x, player.y)) {
        player.collectPowerUp(p);
        powerUps.remove(i);
      }
    }

    // Feinde abarbeiten
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
          screen = 5; // Gewonnen
        }
      }
    }

    // Spieler-Schüsse abarbeiten
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

    // Feind-Schüsse abarbeiten
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      Bullet b = enemyBullets.get(i);
      b.update();
      b.display();
      if (dist(b.x, b.y, player.x, player.y) < 15 && !player.shieldActive) {
        player.lives--; // Leben verringern
        enemyBullets.remove(i);
        if (player.lives <= 0) {
          screen = 4; // Game Over
        }
      }
      if (b.y > height) enemyBullets.remove(i);
    }
  }

  void drawHUD() {
    // Hintergrund der HUD
    fill(40, 40, 40, 200); // Dunkelgrau mit etwas Transparenz
    noStroke();
    rect(10, 10, 270, 120, 20); // Einheitlicher Hintergrund mit abgerundeten Ecken

    // Score anzeigen, mittig im Hintergrund
    fill(0, 255, 255); // Türkis für den Score
    textSize(24); // Größere Schrift
    textAlign(CENTER, TOP);
    text("Punkte: " + player.score, 145, 20); // Score mittig

    // Leben (Herzen), mittig
    float heartWidth = 22; // Breite der Herzen
    float heartsTotalWidth = heartWidth * player.lives + 8 * (player.lives - 1); // Gesamtbreite für alle Herzen
    float heartsStartX = 145 - heartsTotalWidth / 2; // Berechne den Startpunkt, damit die Herzen mittig sind
    drawLives(heartsStartX, 50, heartWidth, player.lives);

    // Power-Up-Timer nur anzeigen, wenn aktiv
    if (player.shieldTimer > frameCount) {
      drawPowerUpTimer(20, 80, 230, 12, player.shieldTimer - frameCount, player.maxShieldTimer, color(100, 180, 255)); // Blau für Schild
    }
    if (player.multiShotTimer > frameCount) {
      drawPowerUpTimer(20, 100, 230, 12, player.multiShotTimer - frameCount, player.maxMultiShotTimer, color(150, 255, 100)); // Grün für Multi-Shot
    }
  }

  void drawLives(float x, float y, float size, int lives) {
    for (int i = 0; i < lives; i++) {
      drawHeart(x + i * (size + 8), y, size);
    }
  }

  void drawHeart(float x, float y, float size) {
    fill(255, 100, 100); // Sanftes Rot für die Herzen
    noStroke();
    beginShape();
    vertex(x, y + size / 4);
    bezierVertex(x - size / 2, y - size / 2, x - size, y + size / 3, x, y + size);
    bezierVertex(x + size, y + size / 3, x + size / 2, y - size / 2, x, y + size / 4);
    endShape(CLOSE);
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
