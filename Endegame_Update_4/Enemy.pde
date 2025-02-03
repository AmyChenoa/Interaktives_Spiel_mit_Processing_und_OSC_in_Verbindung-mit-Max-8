class Enemy {
  float x, y;
  float size = 30;

  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    y += 2; // Gegner bewegen
  }

  void display() {
    fill(255, 100, 100);
    ellipse(x, y, size, size);
  }

  void shoot(ArrayList<Bullet> bullets) {
    bullets.add(new Bullet(x, y, random(-1, 1), 3, color(255, 0, 0)));
  }
}

class Boss extends Enemy {
  int health;
  
  Boss(float x, float y, int health) {
    super(x, y);
    this.size = 60;
    this.health = health;
  }

  @Override
  void update() {
    x += sin(frameCount * 0.05) * 5; // Seitliche Bewegung
    y += 1; // Langsame Vertikalbewegung
  }

  @Override
  void shoot(ArrayList<Bullet> bullets) {
    // Boss schießt 6 Kugeln in verschiedenen Richtungen
    for (float angle = 0; angle < TWO_PI; angle += PI / 6) {
      bullets.add(new Bullet(x, y, cos(angle) * 3, sin(angle) * 3, color(255, 150, 0)));
    }
  }

  void takeDamage() {
    health--;
  }

  boolean isDead() {
    return health <= 0;
  }

  void displayHealth() {
    // Boss Health Anzeige
    fill(50, 50, 50);
    rect(width / 2 - 150, 20, 300, 20, 10); // Fortschrittsbalken Hintergrund

    float healthBarWidth = map(health, 0, 50, 0, 300); // Berechnet die Breite der Lebensanzeige
    fill(255, 0, 0); // Rote Farbe für den Balken
    rect(width / 2 - 150, 20, healthBarWidth, 20, 10); // Gesundheitsbalken

    // Boss Health Text
    fill(255);
    textSize(20);
    text("Boss Health: " + health, width / 2 - 130, 15);
  }
}
