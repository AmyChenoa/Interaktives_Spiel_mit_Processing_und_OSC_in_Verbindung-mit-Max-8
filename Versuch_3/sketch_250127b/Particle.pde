class Particle {
  float x, y, speedX, speedY, lifespan;
  color c;

  Particle(float x, float y, float speedX, float speedY, color c) {
    this.x = x;
    this.y = y;
    this.speedX = speedX;
    this.speedY = speedY;
    this.c = c;
    this.lifespan = 255;
  }

  void update() {
    x += speedX;
    y += speedY;
    lifespan -= 5;
  }

  void display() {
    fill(c, lifespan);
    ellipse(x, y, 5, 5);
  }

  boolean isDead() {
    return lifespan <= 0;
  }
}
