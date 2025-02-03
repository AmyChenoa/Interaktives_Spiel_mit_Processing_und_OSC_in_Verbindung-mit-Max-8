int screen = 0;  // 0 = Start, 1 = Level, 2 = Hilfe, 3 = Spiel, 4 = Game Over, 5 = Gewonnen

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
WinScreen winScreen;

void setup() {
  size(1000, 600);
  ImageBackground_1 = loadImage("./data./Weltall-1.png");
  ImageBackground_1.resize(width, height);
  resetGame();
  frameRate(60);

  startScreen = new StartScreen();
  levelScreen = new LevelScreen();
  helpScreen = new HelpScreen();
  gameOverScreen = new GameOverScreen();
  winScreen = new WinScreen();
}

void draw() {
  if (screen == 0) {
    startScreen.display();
  } else if (screen == 1) {
    levelScreen.display();
  } else if (screen == 2) {
    helpScreen.display();
  } else if (screen == 3) {
    if (playerLives > 0) {
      playGame();
    } else {
      screen = 4;
    }
  } else if (screen == 4) {
    gameOverScreen.display(score);
  } else if (screen == 5) {
    winScreen.display(score);
  }
}

void mousePressed() {
  if (screen == 0) startScreen.mousePressed();
  else if (screen == 1) levelScreen.mousePressed();
  else if (screen == 2) helpScreen.mousePressed();
}

void drawPowerUpTimers() {
  int barWidth = 200;
  int barHeight = 10;
  int barX = 20;
  int shieldBarY = 80;
  int multiShotBarY = 100;
  
  if (shieldActive) {
    int remainingShieldTime = shieldTimer - frameCount;
    float shieldPercentage = constrain(remainingShieldTime / 300.0, 0, 1);

    fill(0, 150, 255);
    rect(barX, shieldBarY, barWidth * shieldPercentage, barHeight);
    
    noFill();
    stroke(255);
    rect(barX, shieldBarY, barWidth, barHeight);
    
    if (remainingShieldTime <= 0) shieldActive = false;
  }

  if (multiShotActive) {
    int remainingMultiShotTime = multiShotTimer - frameCount;
    float multiShotPercentage = constrain(remainingMultiShotTime / 300.0, 0, 1);

    fill(0, 255, 0);
    rect(barX, multiShotBarY, barWidth * multiShotPercentage, barHeight);
    
    noFill();
    stroke(255);
    rect(barX, multiShotBarY, barWidth, barHeight);
    
    if (remainingMultiShotTime <= 0) multiShotActive = false;
  }
}

void drawHUD() {
  // Hintergrund für das HUD
  fill(0, 150); // Halbtransparentes Schwarz
  noStroke();
  rect(10, 10, 250, 60, 15); // Abgerundeter Kasten für bessere Lesbarkeit
  
  // Score anzeigen
  fill(255, 215, 0); // Goldene Farbe für den Score
  textSize(26);
  textAlign(LEFT, TOP);
  text("Score: " + score, 20, 20);
  
  // Leben als Herzen anzeigen
  int heartSize = 20;
  int heartX = 20;
  int heartY = 50;
  
  for (int i = 0; i < playerLives; i++) {
    drawHeart(heartX + i * (heartSize + 5), heartY, heartSize);
  }
}

// Methode zum Zeichnen eines Herzens
void drawHeart(float x, float y, float size) {
  fill(255, 0, 0); // Rote Herzen
  noStroke();
  
  beginShape();
  vertex(x, y + size / 4);
  bezierVertex(x - size / 2, y - size / 2, x - size, y + size / 3, x, y + size);
  bezierVertex(x + size, y + size / 3, x + size / 2, y - size / 2, x, y + size / 4);
  endShape(CLOSE);
}


void playGame() {
  image(ImageBackground_1, 0, 0);

  fill(shieldActive ? color(0, 150, 255) : color(0, 255, 0));
  rect(playerX - 15, playerY - 15, 30, 30);
  drawHUD();
  drawPowerUpTimers();

  if (keyPressed) {
    if (key == 'a' || keyCode == LEFT) playerX -= 5;
    if (key == 'd' || keyCode == RIGHT) playerX += 5;
    if (key == 'w' || keyCode == UP) playerY -= 5;
    if (key == 's' || keyCode == DOWN) playerY += 5;
  }
  playerX = constrain(playerX, 15, width - 15);
  playerY = constrain(playerY, 15, height - 15);

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

  if (frameCount % 60 == 0 && !bossActive) {
    enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
  }

  if (frameCount % (60 * 30) == 0 && !bossActive) {
    bossActive = true;
    bossHealth = 50;
    enemies.add(new Boss(width / 2, 80, bossHealth));
  }

  if (frameCount % 500 == 0) {
    powerUps.add(new PowerUp(random(50, width - 50), random(50, height - 200), (int) random(1, 3)));
  }

  for (int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp p = powerUps.get(i);
    p.display();
    if (p.isCollected(playerX, playerY)) {
      if (p.type == 1) {
        shieldActive = true;
        shieldTimer = frameCount + 300;
      } else if (p.type == 2) {
        multiShotActive = true;
        multiShotTimer = frameCount + 300;
      }
      powerUps.remove(i);
    }
  }

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
        bossActive = false;
        score += 500;
        screen = 5;
      }
    }
  }

  for (int i = playerBullets.size() - 1; i >= 0; i--) {
    Bullet b = playerBullets.get(i);
    b.update();
    b.display();
    for (int j = enemies.size() - 1; j >= 0; j--) {
      Enemy e = enemies.get(j);
      if (dist(b.x, b.y, e.x, e.y) < e.size / 2) {
        enemies.remove(j);
        score += 10;
        playerBullets.remove(i);
        break;
      }
    }
    if (b.y < 0) playerBullets.remove(i);
  }

  for (int i = enemyBullets.size() - 1; i >= 0; i--) {
    Bullet b = enemyBullets.get(i);
    b.update();
    b.display();

    if (dist(b.x, b.y, playerX, playerY) < 15 && !shieldActive) {
      playerLives--;
      enemyBullets.remove(i);
    }

    if (b.y > height) enemyBullets.remove(i);
  }
}

void keyPressed() {
  if (screen == 0 && key == ENTER) screen = 3;
  if (screen == 4 && key == ENTER) resetGame();
  if (screen == 5 && key == ENTER) resetGame();
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

  // Ensure lists are initialized
  enemies = new ArrayList<>();  
  playerBullets = new ArrayList<>();
  enemyBullets = new ArrayList<>();
  powerUps = new ArrayList<>();

  screen = 0; // Return to the start screen
}
