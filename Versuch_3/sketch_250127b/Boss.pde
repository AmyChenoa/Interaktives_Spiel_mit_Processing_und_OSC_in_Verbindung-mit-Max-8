class Boss extends Enemy {
  int phase = 1;

  Boss(float x, float y) {
    super(x, y);
    this.size = 60;
  }

  @Override
    void update() {
    if (phase == 1) {
      x += sin(frameCount * 0.05) * 5; // Phase 1: Horizontal schwingen
    } else if (phase == 2) {
      x += cos(frameCount * 0.05) * 5; // Phase 2: Schärferes Schwingen
    }

    // Phase wechseln
    if (bossHealth < 30 && phase == 1) phase = 2;
    if (bossHealth < 10 && phase == 2) phase = 3;
  }

  @Override
    void shoot(ArrayList<Bullet> bullets) {
    if (phase == 1) {
      for (float angle = 0; angle < TWO_PI; angle += PI / 6) {
        bullets.add(new Bullet(x, y, cos(angle) * 3, sin(angle) * 3, color(255, 150, 0)));
      }
    } else if (phase == 2) {
      for (int i = -2; i <= 2; i++) {
        bullets.add(new Bullet(x + i * 20, y, 0, 3, color(255, 0, 0))); // Gerade Linien
      }
    } else if (phase == 3) {
      enemies.add(new Enemy(x + random(-50, 50), y + 50)); // Minions spawnen
    }
  }
}
