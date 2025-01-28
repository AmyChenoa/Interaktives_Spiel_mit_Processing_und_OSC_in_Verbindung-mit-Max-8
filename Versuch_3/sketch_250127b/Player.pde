class Player {
  float x, y;
  int lives = 3;
  boolean shieldActive = false;
  int shieldTimer = 0;
  boolean multiShotActive = false;
  int multiShotTimer = 0;

  Player(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    if (keyPressed) {
      if (key == 'a' || keyCode == LEFT) x -= 5;
      if (key == 'd' || keyCode == RIGHT) x += 5;
      if (key == 'w' || keyCode == UP) y -= 5;
      if (key == 's' || keyCode == DOWN) y += 5;
    }
    x = constrain(x, 15, width - 15);
    y = constrain(y, 15, height - 15);

    // Power-Up Timer aktualisieren
    if (shieldActive && frameCount > shieldTimer) shieldActive = false;
    if (multiShotActive && frameCount > multiShotTimer) multiShotActive = false;

    // Schießen
    if (keyPressed && key == ' ') {
      if (frameCount % 10 == 0) {
        if (multiShotActive) {
          playerBullets.add(new Bullet(x - 10, y - 20, 0, -5, color(0, 255, 0)));
          playerBullets.add(new Bullet(x, y - 20, 0, -5, color(0, 255, 0)));
          playerBullets.add(new Bullet(x + 10, y - 20, 0, -5, color(0, 255, 0)));
        } else {
          playerBullets.add(new Bullet(x, y - 20, 0, -5, color(0, 255, 0)));
        }
      }
    }
  }

  void display() {
    fill(shieldActive ? color(0, 150, 255) : color(0, 255, 0));
    rect(x - 15, y - 15, 30, 30);
  }

  boolean collidesWith(PowerUp p) {
    return dist(x, y, p.x, p.y) < 20;
  }

  void collectPowerUp(PowerUp p) {
    if (p.type == 1) { // Schild
      shieldActive = true;
      shieldTimer = frameCount + 300;
    } else if (p.type == 2) { // Multi-Schuss
      multiShotActive = true;
      multiShotTimer = frameCount + 300;
    } else if (p.type == 3) { // Leben
      lives = min(lives + 1, 5); // Leben begrenzen auf maximal 5
    }
  }
