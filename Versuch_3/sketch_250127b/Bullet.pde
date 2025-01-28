class Bullet {
  float x, y, speedX, speedY;
  color c;

  Bullet(float x, float y, float speedX, float speedY, color c) {
    this.x = x;
    this.y = y;
    this.speedX = speedX;
    this.speedY = speedY;
    this.c = c;
  }

  void update() {
    x += speedX;
    y += speedY;
  }

  void display() {
    fill(c);
    ellipse(x, y, 10, 10);
  }

  boolean collidesWith(Player p) {
    return dist(x, y, p.x, p.y) < 15;
  }

  boolean collidesWith(Enemy e) {
    return dist(x, y, e.x, e.y) < e.size / 2;
  }
}
