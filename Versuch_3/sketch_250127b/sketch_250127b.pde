// Alle Klassen müssen später in eigenen Dateien oder direkt darunter definiert sein

import java.util.ArrayList;

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
boolean bossActive = false;
int bossHealth = 0;

void setup() {
  size(800, 600);
  playerX = width / 2;
  playerY = height - 50;

  // Initialisierung der ArrayLists
  enemies = new ArrayList<>();
  playerBullets = new ArrayList<>();
  enemyBullets = new ArrayList<>();
  powerUps = new ArrayList<>();
  frameRate(60);
}

void draw() {
  background(20);

  // Spieler zeichnen
  fill(shieldActive ? color(0, 150, 255) : color(0, 255, 0)); // Farbe ändert sich bei aktivem Schild
  rect(playerX - 15, playerY - 15, 30, 30);

  // Spieler bewegen
  if (keyPressed) {
    if (key == 'a' || keyCode == LEFT) playerX -= 5;
    if (key == 'd' || keyCode == RIGHT) playerX += 5;
    if (key == 'w' || keyCode == UP) playerY -= 5;
    if (key == 's' || keyCode == DOWN) playerY += 5;
  }

  // Begrenzung des Spielers
  playerX = constrain(playerX, 15, width - 15);
  playerY = constrain(playerY, 15, height - 15);

  // Spieler schießen
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

  // Gegner spawnen
  if (frameCount % 60 == 0 && !bossActive) {
    enemies.add(new Enemy(random(30, width - 30), -20));
  }

  // Boss spawnen
  if (frameCount % (60 * 30) == 0 && !bossActive) {
    bossActive = true;
    bossHealth = 50;
    enemies.add(new Boss(width / 2, 50));
  }

  // Power-Ups spawnen
  if (frameCount % 500 == 0) {
    powerUps.add(new PowerUp(random(50, width - 50), random(50, height - 200), (int) random(1, 3)));
  }

  // Aktualisierung der Power-Up-Timer
  if (shieldActive && frameCount > shieldTimer) shieldActive = false;
  if (multiShotActive && frameCount > multiShotTimer) multiShotActive = false;

  // Gegner, Geschosse, Power-Ups verwalten
  updateEnemies();
  updatePlayerBullets();
  updateEnemyBullets();
  updatePowerUps();

  // Punkte und Leben anzeigen
  displayHUD();

  // Spielende prüfen
  if (playerLives <= 0) {
    gameOver();
  }
}

void updateEnemies() {
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
    e.display();

    // Gegner schießen
    if (frameCount % 30 == 0) {
      e.shoot(enemyBullets);
    }

    // Gegner entfernen, wenn außerhalb des Bildschirms
    if (e.y > height) {
      enemies.remove(i);
    }
  }
}

void updatePlayerBullets() {
  for (int i = playerBullets.size() - 1; i >= 0; i--) {
    Bullet b = playerBullets.get(i);
    b.update();
    b.display();

    // Treffer auf Gegner prüfen
    for (int j = enemies.size() - 1; j >= 0; j--) {
      Enemy e = enemies.get(j);
      if (dist(b.x, b.y, e.x, e.y) < e.size / 2) {
        if (e instanceof Boss) {
          bossHealth--;
          if (bossHealth <= 0) {
            enemies.remove(j);
            bossActive = false;
          }
        } else {
          enemies.remove(j);
        }
        score += 10;
        playerBullets.remove(i);
        break;
      }
    }

    // Entfernen, wenn außerhalb des Bildschirms
    if (b.y < 0) {
      playerBullets.remove(i);
    }
  }
}

void updateEnemyBullets() {
  for (int i = enemyBullets.size() - 1; i >= 0; i--) {
    Bullet b = enemyBullets.get(i);
    b.update();
    b.display();

    // Treffer auf Spieler prüfen
    if (dist(b.x, b.y, playerX, playerY) < 15 && !shieldActive) {
      playerLives--;
      enemyBullets.remove(i);
    }

    // Entfernen, wenn außerhalb des Bildschirms
    if (b.y > height) {
      enemyBullets.remove(i);
    }
  }
}

void updatePowerUps() {
  for (int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp p = powerUps.get(i);
    p.display();
    if (dist(playerX, playerY, p.x, p.y) < 20) {
      if (p.type == 1) {
        shieldActive = true;
        shieldTimer = frameCount + 300; // Schild für 5 Sekunden
      } else if (p.type == 2) {
        multiShotActive = true;
        multiShotTimer = frameCount + 300; // Multischuss für 5 Sekunden
      }
      powerUps.remove(i);
    }
  }
}

void displayHUD() {
  fill(255);
  textSize(20);
  text("Score: " + score, 10, 20);
  text("Lives: " + playerLives, 10, 40);
  if (bossActive) {
    text("Boss Health: " + bossHealth, width / 2 - 50, 20);
  }
}

void gameOver() {
  fill(255, 0, 0);
  textSize(50);
  textAlign(CENTER);
  text("GAME OVER", width / 2, height / 2);
  noLoop();
}
