// --- STAR (HINTERGRUND) ---
class Star {
  float x, y, speed;

  Star() {
    x = random(width);
    y = random(height);
    speed = random(1, 3);
  }

  void update() {
    y += speed;
    if (y > height) {
      y = 0;
      x = random(width);
    }
  }

  void show() {
    fill(255, 255, 255, 150);
    noStroke();
    ellipse(x, y, 2, 2);
  }
}
