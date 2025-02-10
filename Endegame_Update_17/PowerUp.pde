class PowerUp {
  float x, y;
  int type;
  float size = 30;
  float oscillationAngle = 0;
  float rotationAngle = 0;
  int duration = 500;
  int timer = 0;
  float pulseFactor = 1.0;
  boolean isPulsing = true;
  boolean isCollected = false;
  ArrayList<Particle> particles;
  ArrayList<TrailParticle> trails;
  color currentColor;

  PowerUp(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
    particles = new ArrayList<Particle>();
    trails = new ArrayList<TrailParticle>();
    currentColor = color(0, 150, 255);
  }

  void display() {
    oscillationAngle += 0.1;
    y += sin(oscillationAngle) * 2;

    if (isPulsing) {
      pulseFactor = 1 + 0.1 * sin(frameCount * 0.1);
    }
    rotationAngle += 0.05;
    changeColorOverTime();
    addTrailEffect();

    pushMatrix();
    translate(x, y);
    rotate(rotationAngle);

    glowEffect();
    fill(currentColor, 180);
    noStroke();
    ellipse(0, 0, size * pulseFactor, size * pulseFactor);
    holographicOverlay();
    addParticleEffect();

    fill(255);
    textSize(16);
    textAlign(CENTER, CENTER);
    text(type == 1 ? "S" : "M", 0, 0);

    popMatrix();

    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      p.display();
      if (!p.isAlive()) {
        particles.remove(i);
      }
    }

    for (int i = trails.size() - 1; i >= 0; i--) {
      TrailParticle t = trails.get(i);
      t.update();
      t.display();
      if (!t.isAlive()) {
        trails.remove(i);
      }
    }
  }

  void changeColorOverTime() {
    int r = int(128 + 127 * sin(frameCount * 0.02));
    int g = int(128 + 127 * sin(frameCount * 0.02 + PI / 3));
    int b = int(128 + 127 * sin(frameCount * 0.02 + 2 * PI / 3));
    currentColor = color(r, g, b);
  }

  void glowEffect() {
    for (int i = 0; i < 4; i++) {
      fill(currentColor, 100 - (i * 25));
      ellipse(0, 0, size * pulseFactor + (i * 8), size * pulseFactor + (i * 8));
    }
  }

  void holographicOverlay() {
    stroke(255, 255, 255, 100);
    strokeWeight(2);
    noFill();
    // Zeichne die Ellipse
    ellipse(0, 0, size * pulseFactor * 1.2, size * pulseFactor * 1.2);

    // Iteriere mit Ganzzahlen
    for (float i = -size / 2; i <= size / 2; i += 5) {
      line(i, -size / 2, i, size / 2);
    }
  }

void addParticleEffect() {
  if (frameCount % 3 == 0 && !isCollected) {
    for (int i = 0; i < 5; i++) {
      float angle = random(TWO_PI);
      float radius = random(size / 2);
      float particleX = x + cos(angle) * radius;
      float particleY = y + sin(angle) * radius;
      float speedX = cos(angle) * random(1, 3);
      float speedY = sin(angle) * random(1, 3);
      int red = int(200 + 55 * sin(frameCount * 0.1));
      int green = int(100 + 100 * cos(frameCount * 0.1));
      int blue = int(150 + 105 * sin(frameCount * 0.1 + PI / 3));
      Particle p = new Particle(particleX, particleY, speedX, speedY, red, green, blue);
      particles.add(p);
    }
  }
  
  // Entferne Partikel, die nicht mehr leben
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    if (!p.isAlive()) {
      particles.remove(i);
    }
  }
}

  void addTrailEffect() {
    if (!isCollected) {
      trails.add(new TrailParticle(x, y));
    }
  }

  boolean isCollected(float playerX, float playerY) {
    return dist(playerX, playerY, x, y) < size / 2 * pulseFactor;
  }

  void update() {
    if (timer < duration) {
      timer++;
    } else {
      isCollected = true;
    }
  }

  boolean isExpired() {
    return timer >= duration;
  }
}

class TrailParticle {
  float x, y;
  float alpha;

  TrailParticle(float x, float y) {
    this.x = x;
    this.y = y;
    this.alpha = 255;
  }

  void update() {
    alpha -= 5;
  }

  void display() {
    fill(0, 150, 255, alpha);
    noStroke();
    ellipse(x, y, 8, 8);
  }

  boolean isAlive() {
    return alpha > 0;
  }
}
