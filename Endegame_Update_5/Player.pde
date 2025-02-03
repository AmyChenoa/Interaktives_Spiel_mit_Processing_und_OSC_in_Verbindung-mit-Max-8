class Player {
  float x, y; // Position des Spielers
  int lives = 3;
  int score = 0;
  boolean shieldActive = false;
  boolean multiShotActive = false;
  int shieldTimer = 0;
  int multiShotTimer = 0;
  final int maxShieldTimer = 300;
  final int maxMultiShotTimer = 300;

  Player() {
    reset();
  }

  void reset() {
    x = width / 2; // Startposition in der Mitte
    y = height - 50; // Startposition unten
    lives = 3;
    score = 0;
    shieldActive = false;
    multiShotActive = false;
    shieldTimer = 0;
    multiShotTimer = 0;
  }

  void update() {
    // Bewegung der Spielfigur
    if (keyPressed) {
      if (key == 'a' || keyCode == LEFT) x -= 5;
      if (key == 'd' || keyCode == RIGHT) x += 5;
      if (key == 'w' || keyCode == UP) y -= 5;
      if (key == 's' || keyCode == DOWN) y += 5;
    }
    x = constrain(x, 15, width - 15); // Spielfeldgrenzen beachten
    y = constrain(y, 15, height - 15);

    // Timer für Power-Ups aktualisieren
    if (shieldActive && frameCount > shieldTimer) {
      shieldActive = false; // Schild deaktivieren, wenn Zeit abgelaufen
    }
    if (multiShotActive && frameCount > multiShotTimer) {
      multiShotActive = false; // Multi-Schuss deaktivieren, wenn Zeit abgelaufen
    }
  }

  void display() {
    // Spieler anzeigen
    fill(shieldActive ? color(0, 150, 255) : color(0, 255, 0)); // Schild: Blau, sonst: Grün
    rect(x - 15, y - 15, 30, 30); // Spielerrechteck zeichnen

    // Schildanzeige
    if (shieldActive) {
      noFill();
      stroke(0, 150, 255);
      strokeWeight(3);
      ellipse(x, y, 50, 50); // Schild-Kreis
    }
  }

  // Power-Up-Status
  boolean hasPowerUp(String powerUpType) {
    if (powerUpType.equals("shield") && shieldActive) {
      return true;
    } else if (powerUpType.equals("multiShot") && multiShotActive) {
      return true;
    }
    return false;
  }


  void collectPowerUp(PowerUp p) {
    if (p.type == 1) {
      shieldActive = true;
      shieldTimer = frameCount + maxShieldTimer;
    } else if (p.type == 2) {
      multiShotActive = true;
      multiShotTimer = frameCount + maxMultiShotTimer;
    }
  }



  void shoot(ArrayList<Bullet> playerBullets) {
    // Normalschuss
    playerBullets.add(new Bullet(x, y - 20, 0, -10, color(255, 255, 0))); // Gelber Schuss nach oben

    // Multi-Schuss (falls aktiviert)
    if (multiShotActive) {
      playerBullets.add(new Bullet(x - 15, y - 20, -2, -10, color(255, 150, 0))); // Linksschuss
      playerBullets.add(new Bullet(x + 15, y - 20, 2, -10, color(255, 150, 0)));  // Rechtsschuss
    }
  }

  void drawPowerUpTimers(int barX, int shieldBarY, int multiShotBarY, int barWidth, int barHeight) {
    // Schild-Timer zeichnen
    if (shieldActive) {
      int remainingShieldTime = shieldTimer - frameCount;
      float shieldPercentage = constrain(remainingShieldTime / (float) maxShieldTimer, 0, 1);
      fill(0, 150, 255);
      rect(barX, shieldBarY, barWidth * shieldPercentage, barHeight, 5);
      noFill();
      stroke(255);
      rect(barX, shieldBarY, barWidth, barHeight, 5);
    }

    // Multi-Schuss-Timer zeichnen
    if (multiShotActive) {
      int remainingMultiShotTime = multiShotTimer - frameCount;
      float multiShotPercentage = constrain(remainingMultiShotTime / (float) maxMultiShotTimer, 0, 1);
      fill(0, 255, 0);
      rect(barX, multiShotBarY, barWidth * multiShotPercentage, barHeight, 5);
      noFill();
      stroke(255);
      rect(barX, multiShotBarY, barWidth, barHeight, 5);
    }
  }
}
