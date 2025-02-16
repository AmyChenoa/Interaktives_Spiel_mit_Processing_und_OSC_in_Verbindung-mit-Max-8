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
    pushStyle(); // Speichert aktuellen Zeichenstil

    // Standardfarbe: Grün, falls kein Power-Up aktiv ist
    color playerColor = color(0, 255, 0);

    if (multiShotActive) {
      playerColor = color(255, 100, 0); // Orange, wenn Multi-Schuss aktiv ist
    } else if (shieldActive) {
      playerColor = color(0, 150, 255); // Blau, wenn Schild aktiv ist
    }

    fill(playerColor);
    rect(x - 15, y - 15, 30, 30); // Spieler als Quadrat

    // Schild-Effekt: Pulsierende Aura
    if (shieldActive) {
      float glowSize = 50 + sin(frameCount * 0.2) * 5; // Pulsierender Effekt
      noFill();
      stroke(0, 150, 255, 150);
      strokeWeight(3);
      ellipse(x, y, glowSize, glowSize);
    }

    // Multi-Schuss-Effekt: Glühender Rand
    if (multiShotActive) {
      stroke(255, 150, 0, 200);
      strokeWeight(3);
      rect(x - 16, y - 16, 32, 32);
    }

    popStyle(); // Stellt alten Zeichenstil wieder her
  }

  // Methode zum Sammeln eines Power-Ups
  void collectPowerUp(PowerUp p) {
    if (p.type == 1) {
      shieldActive = true;
      shieldTimer = frameCount + maxShieldTimer;
    } else if (p.type == 2) {
      multiShotActive = true;
      multiShotTimer = frameCount + maxMultiShotTimer;
      println("Multi-Schuss aktiviert! Läuft bis Frame: " + multiShotTimer);
    }
  }

  // Methode zum Schießen der Kugeln (Schüsse) des Spielers
  void shoot(ArrayList<Bullet> playerBullets) {
    float randomSize = random(5, 20); // Zufällige Größe zwischen 5 und 20

    if (multiShotActive) {
      // Multi-Schuss: Drei Schüsse mit leichter Streuung
      playerBullets.add(new Bullet(x - 15, y - 20, -2, -10, color(255, 150, 0), randomSize)); // Linker Schuss
      playerBullets.add(new Bullet(x, y - 20, 0, -10, color(255, 150, 0), randomSize)); // Mittlerer Schuss
      playerBullets.add(new Bullet(x + 15, y - 20, 2, -10, color(255, 150, 0), randomSize)); // Rechter Schuss
      sound.sendSound("Multishot");
    } else {
      // Einzelner Schuss, wenn Multi-Schuss nicht aktiv ist
      playerBullets.add(new Bullet(x, y - 20, 0, -10, color(255, 255, 0), randomSize));
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
