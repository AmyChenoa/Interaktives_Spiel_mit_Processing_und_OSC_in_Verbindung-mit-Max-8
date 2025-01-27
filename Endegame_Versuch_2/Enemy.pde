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
