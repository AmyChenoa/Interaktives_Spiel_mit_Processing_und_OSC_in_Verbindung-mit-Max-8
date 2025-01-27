class Boss extends Enemy {
  Boss(float x, float y) {
    super(x, y);
    this.size = 60;
  }

  @Override
  void update() {
    x += sin(frameCount * 0.05) * 5; // Seitliche Bewegung
  }

  @Override
  void shoot(ArrayList<Bullet> bullets) {
    for (float angle = 0; angle < TWO_PI; angle += PI / 6) {
      bullets.add(new Bullet(x, y, cos(angle) * 3, sin(angle) * 3, color(255, 150, 0)));
    }
  }
}
