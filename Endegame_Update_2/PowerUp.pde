class PowerUp {
  float x, y;
  int type; // 1 = Shield, 2 = Multi-Shot
  float size = 30;  // Größe des Power-Ups
  float oscillationAngle = 0;  // Schwebende Animation
  float rotationAngle = 0;  // Rotation für den Power-Up-Effekt
  int duration = 500;  // Dauer des Power-Ups (in Frames)
  int timer = 0;  // Timer für die Dauer

  PowerUp(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
  }

  void display() {
    // Schwebende Animation
    oscillationAngle += 0.1;
    y += sin(oscillationAngle) * 2;  // Bewegung in y-Richtung für "schwebenden" Effekt
    
    // Rotationseffekt für das Power-Up
    rotationAngle += 0.05;
    
    pushMatrix();
    translate(x, y);
    rotate(rotationAngle);
    
    // Power-Up Darstellung
    if (type == 1) {
      // Schild Power-Up als Kreis mit einem blauen Schild-Symbol
      fill(0, 150, 255, 200);  // Transparente Farbe für einen schimmernden Effekt
      noStroke();
      ellipse(0, 0, size, size);  // Schild Power-Up als Kreis
      fill(255);
      textSize(16);
      textAlign(CENTER, CENTER);
      text("S", 0, 0);  // Ein "S" für Shield als Symbol
    } else if (type == 2) {
      // Multi-Shot Power-Up als Quadrat mit einem gelben Hintergrund
      fill(255, 255, 0, 200);  // Gelbe Farbe für Multi-Shot
      noStroke();
      rect(-size / 2, -size / 2, size, size);  // Multi-Shot Power-Up als Quadrat
      fill(0);
      textSize(16);
      textAlign(CENTER, CENTER);
      text("M", 0, 0);  // Ein "M" für Multi-Shot als Symbol
    }
    
    popMatrix();
    
    // Anzeige des verbleibenden Power-Up-Timers
    if (timer > 0) {
      float progress = (float) timer / duration;  // Fortschritt des Timers
      noFill();
      stroke(255, 0, 0);  // Rote Farbe für den Timer
      strokeWeight(3);
      arc(x, y + size / 2 + 10, size + 10, size + 10, -HALF_PI, -HALF_PI + progress * TWO_PI);  // Fortschrittsbalken
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
