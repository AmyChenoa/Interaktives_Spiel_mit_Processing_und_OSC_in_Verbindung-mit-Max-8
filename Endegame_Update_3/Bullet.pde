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
}
