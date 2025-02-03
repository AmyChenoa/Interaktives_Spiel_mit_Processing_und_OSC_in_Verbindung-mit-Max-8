int screen = 0;  // 0 = Start, 1 = Level, 2 = Hilfe, 3 = Spiel, 4 = Game Over

PImage ImageBackground_1;
ArrayList<Enemy> enemies;
ArrayList<Bullet> playerBullets;
ArrayList<Bullet> enemyBullets;
ArrayList<PowerUp> powerUps;

float playerX, playerY;
int playerLives = 3;
int score = 0;
boolean shieldActive = false;
int shieldTimer = 0;
boolean multiShotActive = false;
int multiShotTimer = 0;
int bossHealth = 0;
boolean bossActive = false;

StartScreen startScreen;
LevelScreen levelScreen;
HelpScreen helpScreen;
GameOverScreen gameOverScreen;

void setup() {
  size(1000, 600);  // Stellt sicher, dass die Fenstergröße immer korrekt ist
  ImageBackground_1 = loadImage("./data./Weltall-1.png");
  ImageBackground_1.resize(width, height);
  resetGame();
  frameRate(60);

  startScreen = new StartScreen();
  levelScreen = new LevelScreen();
  helpScreen = new HelpScreen();
  gameOverScreen = new GameOverScreen();
}

void draw() {
  // Bildschirm-Logik basierend auf dem aktuellen Zustand
  if (screen == 0) {
    startScreen.display();  // Startbildschirm
  } else if (screen == 1) {
    levelScreen.display();  // Levelauswahl
  } else if (screen == 2) {
    helpScreen.display();  // Hilfeseite
  } else if (screen == 3) {
    if (playerLives > 0) {
      playGame();  // Das eigentliche Spiel
    } else {
      screen = 4;  // Game Over, wenn der Spieler keine Leben mehr hat
    }
  } else if (screen == 4) {
    gameOverScreen.display(score);  // Game Over Bildschirm mit Score
  }
}

void mousePressed() {
  if (screen == 0) {
    startScreen.mousePressed();  // Klick auf den Startbildschirm
  } else if (screen == 1) {
    levelScreen.mousePressed();  // Klick auf den Levelbildschirm
  } else if (screen == 2) {
    helpScreen.mousePressed();  // Klick auf die Hilfeseite
  }
}

void playGame() {
  image(ImageBackground_1, 0, 0);

  // Spieleranzeige (mit Schutzschild, falls aktiv)
  fill(shieldActive ? color(0, 150, 255) : color(0, 255, 0));
  rect(playerX - 15, playerY - 15, 30, 30);

  // Steuerung des Spielers
  if (keyPressed) {
    if (key == 'a' || keyCode == LEFT) playerX -= 5;
    if (key == 'd' || keyCode == RIGHT) playerX += 5;
    if (key == 'w' || keyCode == UP) playerY -= 5;
    if (key == 's' || keyCode == DOWN) playerY += 5;
  }
  playerX = constrain(playerX, 15, width - 15);
  playerY = constrain(playerY, 15, height - 15);

  // Schießen des Spielers (mit Multi-Shot, wenn aktiv)
  if (keyPressed && key == ' ') {
    if (frameCount % 10 == 0) {
      if (multiShotActive) {
        playerBullets.add(new Bullet(playerX - 10, playerY - 20, 0, -5, color(0, 255, 0)));
        playerBullets.add(new Bullet(playerX, playerY - 20, 0, -5, color(0, 255, 0)));
        playerBullets.add(new Bullet(playerX + 10, playerY - 20, 0, -5, color(0, 255, 0)));
      } else {
        playerBullets.add(new Bullet(playerX, playerY - 20, 0, -5, color(0, 255, 0)));
      }
    }
  }

  // Gegner-Spawns
  if (frameCount % 60 == 0 && !bossActive) {
    enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
  }

  // Boss erscheint nach 30 Sekunden
  if (frameCount % (60 * 30) == 0 && !bossActive) {
    bossActive = true;
    bossHealth = 50;
    enemies.add(new Boss(width / 2, 80, bossHealth));
  }

  // PowerUps erscheinen alle 500 Frames
  if (frameCount % 500 == 0) {
    powerUps.add(new PowerUp(random(50, width - 50), random(50, height - 200), (int) random(1, 3)));
  }

  // PowerUps anzeigen und überprüfen, ob sie eingesammelt werden
  for (int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp p = powerUps.get(i);
    p.display();

    if (p.isCollected(playerX, playerY)) {
      // Power-Up-Effekt aktivieren
      if (p.type == 1) {  // Schild aktivieren
        shieldActive = true;
        shieldTimer = frameCount + 300;  // Schild für 5 Sekunden
      } else if (p.type == 2) {  // Multi-Shot aktivieren
        multiShotActive = true;
        multiShotTimer = frameCount + 300;  // Multi-Shot für 5 Sekunden
      }
      powerUps.remove(i);  // Power-Up wird eingesammelt und aus der Liste entfernt
    }
  }

  // Timer für das Schild und MultiShot
  if (shieldActive && frameCount > shieldTimer) shieldActive = false;
  if (multiShotActive && frameCount > multiShotTimer) multiShotActive = false;

  // Anzeige der verbleibenden Zeit für PowerUps
  if (shieldActive) {
    int remainingShieldTime = shieldTimer - frameCount;
    fill(255);
    textSize(18);
    text("Shield Time: " + remainingShieldTime / 60 + "s", 20, 80);  // Sekunden anzeigen
  }

  if (multiShotActive) {
    int remainingMultiShotTime = multiShotTimer - frameCount;
    fill(255);
    textSize(18);
    text("Multi-Shot Time: " + remainingMultiShotTime / 60 + "s", 20, 100);  // Sekunden anzeigen
  }

  // Gegner-Logik
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
    e.display();
    if (frameCount % 30 == 0) e.shoot(enemyBullets);
    if (e.y > height) enemies.remove(i);

    // Überprüfung, ob der Boss getroffen wurde
    if (e instanceof Boss && dist(playerX, playerY, e.x, e.y) < 60) {
      Boss boss = (Boss) e;
      boss.takeDamage();
      if (boss.isDead()) {
        enemies.remove(i);
        bossActive = false;
        score += 500; // Bonus für das Besiegen des Bosses
      }
    }
  }

  // Überprüfung der Spielerprojektil-Treffer
  for (int i = playerBullets.size() - 1; i >= 0; i--) {
    Bullet b = playerBullets.get(i);
    b.update();
    b.display();
    for (int j = enemies.size() - 1; j >= 0; j--) {
      Enemy e = enemies.get(j);
      if (dist(b.x, b.y, e.x, e.y) < e.size / 2) {
        if (e instanceof Boss) {
          Boss boss = (Boss) e;
          boss.takeDamage();
          if (boss.isDead()) {
            enemies.remove(j);
            bossActive = false;
            score += 500;
          }
        } else {
          enemies.remove(j);
        }
        score += 10;
        playerBullets.remove(i);
        break;
      }
    }
    if (b.y < 0) playerBullets.remove(i);
  }

  // Überprüfung der feindlichen Kugeln
  for (int i = enemyBullets.size() - 1; i >= 0; i--) {
    Bullet b = enemyBullets.get(i);
    b.update();
    b.display();

    if (dist(b.x, b.y, playerX, playerY) < 15 && !shieldActive) {
      playerLives--;
      enemyBullets.remove(i);
    }

    if (b.y > height) {
      enemyBullets.remove(i);
    }
  }

  // Anzeige des Scores und der Leben
  fill(0, 150);  // Transparente schwarze Farbe
  noStroke();
  rect(0, 0, width, 70, 20);  // Hintergrund mit abgerundeten Ecken

  fill(255);  // Weiße Schriftfarbe
  textSize(24);
  textAlign(LEFT, TOP);
  text("Score: " + score, 20, 20);
  text("Lives: " + playerLives, 20, 50);

  // Boss Health Anzeige für alle Boss-Gegner in der Liste
  for (Enemy e : enemies) {
    if (e instanceof Boss) {
      Boss boss = (Boss) e;  // Cast nur, wenn es sich um einen Boss handelt
      boss.displayHealth();
    }
  }
}

void keyPressed() {
  if (screen == 0 && key == ENTER) {
    screen = 3;  // Wenn ENTER gedrückt wird, gehe ins Spiel
  }
  if (screen == 4 && key == ENTER) {
    resetGame();  // Wenn ENTER nach Game Over gedrückt wird, starte das Spiel neu
  }
}

void resetGame() {
  playerX = width / 2;
  playerY = height - 50;
  playerLives = 3;
  score = 0;
  shieldActive = false;
  multiShotActive = false;
  bossHealth = 0;
  bossActive = false;

  enemies = new ArrayList<>();
  playerBullets = new ArrayList<>();
  enemyBullets = new ArrayList<>();
  powerUps = new ArrayList<>();

  screen = 0;  // Zurück zum Startbildschirm

  // Startbildschirm neu initialisieren, um sicherzustellen, dass er korrekt gezeichnet wird
  startScreen = new StartScreen();  // Neu instanziieren, damit der Startscreen richtig zurückgesetzt wird
}
