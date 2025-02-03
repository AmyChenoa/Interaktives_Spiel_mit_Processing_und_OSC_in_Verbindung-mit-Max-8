class PowerUp {
  float x, y;
  int type; // 1 = Shield, 2 = Multi-Shot
  float size = 30;  // Größe des Power-Ups
  float oscillationAngle = 0;  // Schwebende Animation
  float rotationAngle = 0;  // Rotation für den Power-Up-Effekt
  int duration = 500;  // Dauer des Power-Ups (in Frames)
  int timer = 0;  // Timer für die Dauer
  float pulseSize = 1;  // Pulsierende Größe für den Effekt

  PowerUp(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
  }

  void display() {
    // Schwebende Animation mit langsamen Oscillation
    oscillationAngle += 0.05;
    y += sin(oscillationAngle) * 2;  // Bewegung in y-Richtung für "schwebenden" Effekt

    // Pulsierender Effekt
    pulseSize = 1 + 0.1 * sin(millis() * 0.005 + x);  // Pulsierende Skalierung

    // Rotationseffekt für das Power-Up
    rotationAngle += 0.02 + 0.005 * sin(millis() * 0.01 + x);  // Sanfte Rotation

    // Animiertes Power-Up
    pushMatrix();
    translate(x, y);
    rotate(rotationAngle);
    scale(pulseSize);  // Pulsierende Größe

    // Power-Up Darstellung
    if (type == 1) {
      // Schild Power-Up als Kreis mit einem schimmernden blauen Effekt
      fill(0, 150, 255, 150);  // Sanfter Schimmer in Blau
      noStroke();
      ellipse(0, 0, size, size);  // Schild Power-Up als Kreis
      addGlowEffect(0, 0, size / 2, 5, color(0, 150, 255));  // Glüheffekt für das Schild
      fill(255);
      textSize(18);
      textAlign(CENTER, CENTER);
      text("S", 0, 0);  // Ein "S" für Shield als Symbol
    } else if (type == 2) {
      // Multi-Shot Power-Up als Quadrat mit einem gelben Hintergrund
      fill(255, 255, 0, 180);  // Gelbe Farbe für Multi-Shot mit Transparenz
      noStroke();
      rect(-size / 2, -size / 2, size, size);  // Multi-Shot Power-Up als Quadrat
      addGlowEffect(0, 0, size / 2, 5, color(255, 255, 0));  // Glüheffekt für Multi-Shot
      fill(0);
      textSize(18);
      textAlign(CENTER, CENTER);
      text("M", 0, 0);  // Ein "M" für Multi-Shot als Symbol
    }

    popMatrix();
    
    // Anzeige des verbleibenden Power-Up-Timers als fortlaufender Kreisbalken
    if (timer > 0) {
      float progress = (float) timer / duration;  // Fortschritt des Timers
      noFill();
      stroke(255, 0, 0, 150);  // Rote Farbe für den Timer
      strokeWeight(5);
      // Fortschrittsbalken als Kreis
      arc(x, y + size / 2 + 10, size + 15, size + 15, -HALF_PI, -HALF_PI + progress * TWO_PI);
    }
  }

  // Schimmernder Glüheffekt um das Power-Up
  void addGlowEffect(float centerX, float centerY, float radius, int layers, color glowColor) {
    noFill();
    for (int i = 0; i < layers; i++) {
      float alpha = map(i, 0, layers, 50, 0);  // Decreasing opacity for glow layers
      stroke(glowColor, alpha);
      strokeWeight(2);
      ellipse(centerX, centerY, radius + i * 5, radius + i * 5);
    }
  }

  // Überprüft, ob der Spieler das Power-Up aufnimmt
  boolean isCollected(float playerX, float playerY) {
    return dist(playerX, playerY, x, y) < size / 2;
  }

  // Timer für das Power-Up, um es nach einer bestimmten Zeit zu deaktivieren
  void update() {
    if (timer < duration) {
      timer++;
    }
  }

  // Überprüft, ob das Power-Up abgelaufen ist
  boolean isExpired() {
    return timer >= duration;
  }
}
