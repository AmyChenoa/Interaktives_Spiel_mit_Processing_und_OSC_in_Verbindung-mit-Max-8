// Definition der Klasse PowerUp

class PowerUp {
  float x, y;                      // Position des Power-Ups
  int type;                         // 1 = Shield, 2 = Multi-Shot
  float size = 30;                  // Grundgröße des Power-Ups
  float oscillationAngle = 0;       // Schwebende Animation
  float rotationAngle = 0;          // Rotation des Power-Ups
  int duration = 500;               // Dauer des Power-Ups (in Frames)
  int timer = 0;                    // Timer für die Dauer des Power-Ups
  float pulseFactor = 1.0;          // Pulsationsfaktor für die Größe des Power-Ups
  boolean isPulsing = true;         // Bestimmt, ob das Power-Up pulsiert
  boolean isCollected = false;      // Ob das Power-Up bereits eingesammelt wurde
  ArrayList<Particle> particles;    // Liste von Partikeln

  PowerUp(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
    particles = new ArrayList<Particle>();  // Initialisiere die Partikel-Liste
  }

  void display() {
    // Schwebende Bewegung (wie eine sanfte Auf- und Abbewegung)
    oscillationAngle += 0.1;
    y += sin(oscillationAngle) * 2; // Schwebende Bewegung in y-Richtung

    // Pulsierende Animation (Power-Up wächst und schrumpft)
    if (isPulsing) {
      pulseFactor = 1 + 0.1 * sin(frameCount * 0.1);  // Pulsieren durch Sinus
    }

    // Rotationseffekt für das Power-Up
    rotationAngle += 0.05;

    pushMatrix();
    translate(x, y);        // Verschiebung auf die Power-Up-Position
    rotate(rotationAngle);  // Rotation des Power-Ups

    // Power-Up Darstellung mit spektakulären visuellen Effekten
    if (type == 1) {
      // Schild Power-Up - pulsierend, leuchtend und transparent
      glowEffect(0, 150, 255);  // Leuchtender Effekt für das Schild
      fill(0, 150, 255, 180);  // Schimmernde blaue Farbe für das Schild
      noStroke();
      ellipse(0, 0, size * pulseFactor, size * pulseFactor);  // Kreis mit pulsierender Größe
      addParticleEffect(); // Partikel-Effekte hinzufügen

      // Symbol für das Shield Power-Up
      fill(255);
      textSize(16);
      textAlign(CENTER, CENTER);
      text("S", 0, 0);
    } else if (type == 2) {
      // Multi-Shot Power-Up - pulsierend, mit Farben und Glühen
      glowEffect(255, 255, 0);  // Glühender Effekt für Multi-Shot
      fill(255, 255, 0, 180);  // Leuchtendes Gelb für Multi-Shot
      noStroke();
      rect(-size * pulseFactor / 2, -size * pulseFactor / 2, size * pulseFactor, size * pulseFactor);  // Pulsierendes Quadrat
      addParticleEffect(); // Partikel-Effekte hinzufügen

      // Symbol für das Multi-Shot Power-Up
      fill(0);
      textSize(16);
      textAlign(CENTER, CENTER);
      text("M", 0, 0);
    }

    popMatrix();

    // Anzeige des verbleibenden Power-Up-Timers mit Fortschrittsbalken
    if (timer > 0) {
      float progress = (float) timer / duration;  // Fortschritt des Timers
      noFill();
      stroke(255, 0, 0);  // Rote Farbe für den Timer
      strokeWeight(3);
      arc(x, y + size / 2 + 10, size + 10, size + 10, -HALF_PI, -HALF_PI + progress * TWO_PI);  // Fortschrittsbalken um das Power-Up
    }

    // Partikel anzeigen und aktualisieren
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      p.display();
      if (!p.isAlive()) {
        particles.remove(i); // Entferne Partikel, die ihre Lebensdauer überschritten haben
      }
    }
  }

  // Glow-Effekt, der das Power-Up zum Leuchten bringt
  void glowEffect(int r, int g, int b) {
    // Mehrere Schichten von leicht transparenten Farben für den Glüheffekt
    for (int i = 0; i < 3; i++) {
      fill(r, g, b, 100 - (i * 30));
      ellipse(0, 0, size * pulseFactor + (i * 8), size * pulseFactor + (i * 8));  // Glühen mit zunehmender Größe
    }
  }

  // Partikel-Effekt hinzufügen
  void addParticleEffect() {
    if (frameCount % 5 == 0 && !isCollected) {
      // Erzeuge zufällige Partikel um das Power-Up
      float particleX = x + random(-size / 2, size / 2);  // Zufällige Position für Partikel
      float particleY = y + random(-size / 2, size / 2);
      float speedX = random(-2, 2);
      float speedY = random(-2, 2);
      Particle p = new Particle(particleX, particleY, speedX, speedY, 255, 0, 0);
      particles.add(p);  // Füge das Partikel zur Partikel-Liste hinzu
    }
  }

  // Überprüft, ob der Spieler das Power-Up aufnimmt
  boolean isCollected(float playerX, float playerY) {
    return dist(playerX, playerY, x, y) < size / 2 * pulseFactor;  // Kollisionsabfrage mit pulsierender Größe
  }

  // Aktualisiert den Timer und deaktiviert das Power-Up nach Ablauf
  void update() {
    if (timer < duration) {
      timer++;
    } else {
      isCollected = true;  // Power-Up deaktivieren
    }
  }

  // Überprüft, ob das Power-Up abgelaufen ist
  boolean isExpired() {
    return timer >= duration;  // Power-Up abgelaufen
  }
}
