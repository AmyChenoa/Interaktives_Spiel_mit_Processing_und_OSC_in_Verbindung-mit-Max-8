// Klasse für Power-Ups, die vom Spieler eingesammelt werden können
class PowerUp {
  float x, y;  // Position des Power-Ups
  int type;  // Art des Power-Ups (z. B. "S" für Schild, "M" für Munition)
  float size = 30;  // Grundgröße des Power-Ups
  float oscillationAngle = 0;  // Winkel für die vertikale Schwingbewegung
  float rotationAngle = 0;  // Rotationswinkel für die Drehbewegung
  int duration = 500;  // Dauer, bevor das Power-Up verschwindet
  int timer = 0;  // Zählt die Zeit, die das Power-Up existiert
  float pulseFactor = 1.0;  // Faktor für den pulsierenden Effekt (Größenänderung)
  boolean isPulsing = true;  // Steuert, ob das Power-Up pulsiert
  boolean isCollected = false;  // Gibt an, ob das Power-Up eingesammelt wurde
  ArrayList<Particle> particles;  // Liste für Partikel-Effekte
  ArrayList<TrailParticle> trails;  // Liste für Nachzieh-Effekte
  color currentColor;  // Variable für die aktuelle Farbe des Power-Ups

  // Konstruktor: Initialisiert das Power-Up mit Position und Typ
  PowerUp(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;

    // Erstellt neue ArrayLists für Partikel und Trails
    particles = new ArrayList<Particle>();
    trails = new ArrayList<TrailParticle>();

    // Startfarbe des Power-Ups (Blau)
    currentColor = color(0, 150, 255);
  }

  // Methode zum Anzeigen des Power-Ups
  void display() {
    // Erhöht den Winkel für die vertikale Schwingbewegung
    oscillationAngle += 0.1;
    y += sin(oscillationAngle) * 2;  // Lässt das Power-Up sanft auf- und abwippen

    // Pulsierender Effekt: Das Power-Up vergrößert und verkleinert sich leicht
    if (isPulsing) {
      pulseFactor = 1 + 0.1 * sin(frameCount * 0.1);
    }

    // Lässt das Power-Up rotieren
    rotationAngle += 0.05;

    // Ändert die Farbe im Laufe der Zeit für einen schillernden Effekt
    changeColorOverTime();

    // Fügt einen Nachzieh-Effekt hinzu
    addTrailEffect();

    // Setzt die Transformationen für das Zeichnen
    pushMatrix();
    translate(x, y);
    rotate(rotationAngle);

    // Zeichnet den leuchtenden Schein um das Power-Up
    glowEffect();

    // Zeichnet das Hauptobjekt des Power-Ups
    fill(currentColor, 180);  // Hauptfarbe mit leichter Transparenz
    noStroke();
    ellipse(0, 0, size * pulseFactor, size * pulseFactor);

    // Fügt eine holographische Überlagerung hinzu
    holographicOverlay();

    // Fügt Partikel-Effekte hinzu
    addParticleEffect();

    // Zeichnet den Buchstaben je nach Typ des Power-Ups ("S" für Schild, "M" für Munition)
    fill(255);
    textSize(16);
    textAlign(CENTER, CENTER);
    text(type == 1 ? "S" : "M", 0, 0);

    // Schließt die Transformationen ab
    popMatrix();

    // Aktualisiert und zeichnet Partikel
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      p.display();
      if (!p.isAlive()) {
        particles.remove(i);  // Entfernt Partikel, wenn sie abgelaufen sind
      }
    }

    // Aktualisiert und zeichnet Trail-Partikel
    for (int i = trails.size() - 1; i >= 0; i--) {
      TrailParticle t = trails.get(i);
      t.update();
      t.display();
      if (!t.isAlive()) {
        trails.remove(i);  // Entfernt Trail-Partikel, wenn sie nicht mehr sichtbar sind
      }
    }
  }

  // Ändert die Farbe des Power-Ups dynamisch über die Zeit
  void changeColorOverTime() {
    int r = int(128 + 127 * sin(frameCount * 0.02));
    int g = int(128 + 127 * sin(frameCount * 0.02 + PI / 3));
    int b = int(128 + 127 * sin(frameCount * 0.02 + 2 * PI / 3));
    currentColor = color(r, g, b);
  }

  // Erstellt einen leuchtenden Effekt um das Power-Up
  void glowEffect() {
    for (int i = 0; i < 4; i++) {
      fill(currentColor, 100 - (i * 25));
      ellipse(0, 0, size * pulseFactor + (i * 8), size * pulseFactor + (i * 8));
    }
  }

  // Zeichnet eine holographische Überlagerung mit Linien
  void holographicOverlay() {
    stroke(255, 255, 255, 100);
    strokeWeight(2);
    noFill();

    // Äußere holographische Ellipse
    ellipse(0, 0, size * pulseFactor * 1.2, size * pulseFactor * 1.2);

    // Senkrechte Linien als holographischer Effekt
    for (float i = -size / 2; i <= size / 2; i += 5) {
      line(i, -size / 2, i, size / 2);
    }
  }

  // Fügt Partikel-Effekte um das Power-Up hinzu
  void addParticleEffect() {
    if (frameCount % 3 == 0 && !isCollected) {
      for (int i = 0; i < 5; i++) {
        float angle = random(TWO_PI);
        float radius = random(size / 2);
        float particleX = x + cos(angle) * radius;
        float particleY = y + sin(angle) * radius;
        float speedX = cos(angle) * random(1, 3);
        float speedY = sin(angle) * random(1, 3);
        int red = int(200 + 55 * sin(frameCount * 0.1));
        int green = int(100 + 100 * cos(frameCount * 0.1));
        int blue = int(150 + 105 * sin(frameCount * 0.1 + PI / 3));
        Particle p = new Particle(particleX, particleY, speedX, speedY, red, green, blue);
        particles.add(p);
      }
    }

    // Entfernt abgelaufene Partikel
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (!p.isAlive()) {
        particles.remove(i);
      }
    }
  }

  // Fügt eine Spur zum Power-Up hinzu, solange es nicht eingesammelt wurde
  void addTrailEffect() {
    if (!isCollected) {
      trails.add(new TrailParticle(x, y));
    }
  }

  // Prüft, ob das Power-Up vom Spieler eingesammelt wurde
  boolean isCollected(float playerX, float playerY) {
    return dist(playerX, playerY, x, y) < size / 2 * pulseFactor;
  }

  // Aktualisiert den Timer des Power-Ups und markiert es als "eingesammelt" nach Ablauf der Zeit
  void update() {
    if (timer < duration) {
      timer++;
    } else {
      isCollected = true;
    }
  }

  // Gibt zurück, ob das Power-Up abgelaufen ist
  boolean isExpired() {
    return timer >= duration;
  }
}

// Klasse für die leuchtende Spur hinter dem Power-Up
class TrailParticle {
  float x, y;  // Position des Partikels
  float alpha;  // Transparenzwert für das Verblassen

  // Konstruktor: Initialisiert ein Trail-Partikel mit voller Sichtbarkeit
  TrailParticle(float x, float y) {
    this.x = x;
    this.y = y;
    this.alpha = 255;
  }

  // Lässt das Partikel langsam verblassen
  void update() {
    alpha -= 5;
  }

  // Zeichnet das Partikel mit einem sanften blauen Farbton
  void display() {
    fill(0, 150, 255, alpha);
    noStroke();
    ellipse(x, y, 8, 8);
  }

  // Gibt zurück, ob das Partikel noch sichtbar ist
  boolean isAlive() {
    return alpha > 0;
  }
}
