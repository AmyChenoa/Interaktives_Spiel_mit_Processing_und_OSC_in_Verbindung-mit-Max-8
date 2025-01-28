class Explosion {
  ArrayList<Particle> particles;

  Explosion(float x, float y) {
    particles = new ArrayList<>();
    for (int i = 0; i < 20; i++) {
      particles.add(new Particle(
        x, y,
        random(-2, 2), random(-2, 2),
        color(255, random(150, 255), 0)
        ));
    }
  }

  void update() {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (p.isDead()) particles.remove(i);
    }
  }

  void display() {
    for (Particle p : particles) {
      p.display();
    }
  }
}
