// Definition der Player-Klasse

class Player {
  float x, y; // Position des Spielers auf der x- und y-Achse
  int lives = 3;  // Anzahl der Leben des Spielers
  int score = 0;   // Der aktuelle Punktestand des Spielers
  boolean shieldActive = false;  // Flag für das aktive Schild-Power-Up
  boolean multiShotActive = false;  // Flag für das aktive Multi-Schuss-Power-Up
  int shieldTimer = 0;  // Timer für das Schild-Power-Up
  int multiShotTimer = 0;  // Timer für das Multi-Schuss-Power-Up
  final int maxShieldTimer = 300;  // Maximale Dauer des Schilds (in Frames)
  final int maxMultiShotTimer = 300;  // Maximale Dauer des Multi-Schusses (in Frames)

  // Konstruktor der Klasse, der die Werte des Spielers zurücksetzt
  Player() {
    reset();  // Initialisiert den Spieler in seine Ausgangsposition
  }

  // Reset-Methode für den Spieler, wird bei Spielneustart aufgerufen
  void reset() {
    x = width / 2;  // Der Spieler startet in der Mitte des Bildschirms (x-Achse)
    y = height - 50;  // Der Spieler startet unten im Bildschirm (y-Achse)
    lives = 3;  // Der Spieler hat zu Beginn 3 Leben
    score = 0;  // Der Score wird zurückgesetzt
    shieldActive = false;  // Schild ist zu Beginn nicht aktiv
    multiShotActive = false;  // Multi-Schuss ist zu Beginn nicht aktiv
    shieldTimer = 0;  // Schild-Timer wird auf 0 gesetzt
    multiShotTimer = 0;  // Multi-Schuss-Timer wird auf 0 gesetzt
  }

  // Update-Methode für den Spieler, wird in jedem Frame aufgerufen
  void update() {
    // Bewegung der Spielfigur
    if (keyPressed) {
      if (key == 'a' || keyCode == LEFT) x -= 5;  // Bewege den Spieler nach links
      if (key == 'd' || keyCode == RIGHT) x += 5; // Bewege den Spieler nach rechts
      if (key == 'w' || keyCode == UP) y -= 5;    // Bewege den Spieler nach oben
      if (key == 's' || keyCode == DOWN) y += 5;   // Bewege den Spieler nach unten
    }
    // Begrenzung der Spielerbewegung, damit er den Bildschirm nicht verlässt
    x = constrain(x, 15, width - 15);  // Der Spieler kann nicht weiter als 15 Pixel von der linken oder rechten Seite des Bildschirms gehen
    y = constrain(y, 15, height - 15); // Der Spieler kann nicht weiter als 15 Pixel vom oberen oder unteren Rand des Bildschirms gehen

    // Timer für Power-Ups aktualisieren
    if (shieldActive && frameCount > shieldTimer) {
      shieldActive = false;  // Deaktiviert das Schild, wenn die Zeit abgelaufen ist
    }
    if (multiShotActive && frameCount > multiShotTimer) {
      multiShotActive = false;  // Deaktiviert den Multi-Schuss, wenn die Zeit abgelaufen ist
    }
  }

  // Methode zum Zeichnen des Spielers auf dem Bildschirm
  void display() {
    // Spieler anzeigen (grün, wenn kein Schild aktiv ist, blau, wenn das Schild aktiv ist)
    fill(shieldActive ? color(0, 150, 255) : color(0, 255, 0)); // Schild ist blau, sonst grün
    rect(x - 15, y - 15, 30, 30); // Zeichnet den Spieler als Quadrat (rechteck)

    // Wenn das Schild aktiv ist, wird ein Kreis um den Spieler gezeichnet
    if (shieldActive) {
      noFill();  // Kein Füllbereich für den Kreis
      stroke(0, 150, 255);  // Blaues Rand für das Schild
      strokeWeight(3);  // Randdicke des Schildes
      ellipse(x, y, 50, 50);  // Zeichnet einen Kreis um den Spieler (als Schild)
    }
  }

  // Überprüft, ob der Spieler ein bestimmtes Power-Up aktiv hat
  boolean hasPowerUp(String powerUpType) {
    if (powerUpType.equals("shield") && shieldActive) {
      return true;  // Rückgabe von 'true', wenn das Schild aktiv ist
    } else if (powerUpType.equals("multiShot") && multiShotActive) {
      return true;  // Rückgabe von 'true', wenn Multi-Schuss aktiv ist
    }
    return false;  // Rückgabe von 'false', wenn das Power-Up nicht aktiv ist
  }

  // Methode zum Sammeln eines Power-Ups
  void collectPowerUp(PowerUp p) {
    if (p.type == 1) {  // Wenn das Power-Up ein Schild ist
      shieldActive = true;  // Aktiviert das Schild
      shieldTimer = frameCount + maxShieldTimer;  // Setzt den Timer für das Schild
    } else if (p.type == 2) {  // Wenn das Power-Up Multi-Schuss ist
      multiShotActive = true;  // Aktiviert den Multi-Schuss
      multiShotTimer = frameCount + maxMultiShotTimer;  // Setzt den Timer für den Multi-Schuss
    }
  }

  // Methode zum Schießen der Kugeln (Schüsse) des Spielers
  void shoot(ArrayList<Bullet> playerBullets) {
    // Normalschuss (gelber Schuss nach oben)
    playerBullets.add(new Bullet(x, y - 20, 0, -10, color(255, 255, 0)));

    // Multi-Schuss (falls aktiv)
    if (multiShotActive) {
      playerBullets.add(new Bullet(x - 15, y - 20, -2, -10, color(255, 150, 0))); // Linker Schuss
      playerBullets.add(new Bullet(x + 15, y - 20, 2, -10, color(255, 150, 0)));  // Rechter Schuss
    }
  }

  // Methode zum Zeichnen der Power-Up-Timer
  void drawPowerUpTimers(int barX, int shieldBarY, int multiShotBarY, int barWidth, int barHeight) {
    // Schild-Timer zeichnen
    if (shieldActive) {
      int remainingShieldTime = shieldTimer - frameCount;  // Berechnet die verbleibende Zeit des Schilds
      float shieldPercentage = constrain(remainingShieldTime / (float) maxShieldTimer, 0, 1);  // Berechnet den Prozentsatz des verbleibenden Schilds
      fill(0, 150, 255);  // Blaue Füllung für den Schildbalken
      rect(barX, shieldBarY, barWidth * shieldPercentage, barHeight, 5);  // Zeichnet den Schildbalken
      noFill();
      stroke(255);  // Weißer Rand für den Balken
      rect(barX, shieldBarY, barWidth, barHeight, 5);  // Zeichnet den Rand des Balkens
    }

    // Multi-Schuss-Timer zeichnen
    if (multiShotActive) {
      int remainingMultiShotTime = multiShotTimer - frameCount;  // Berechnet die verbleibende Zeit für Multi-Schuss
      float multiShotPercentage = constrain(remainingMultiShotTime / (float) maxMultiShotTimer, 0, 1);  // Berechnet den Prozentsatz des verbleibenden Multi-Schusses
      fill(0, 255, 0);  // Grüne Füllung für den Multi-Schussbalken
      rect(barX, multiShotBarY, barWidth * multiShotPercentage, barHeight, 5);  // Zeichnet den Multi-Schuss-Balken
      noFill();
      stroke(255);  // Weißer Rand für den Balken
      rect(barX, multiShotBarY, barWidth, barHeight, 5);  // Zeichnet den Rand des Balkens
    }
  }
}
