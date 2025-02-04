// Verbesserte Enemy-Klasse mit Farbverlaufseffekt, Explosion und leicht schwankender Bewegung

class Enemy {
  float x, y; // Position des Gegners
  float size = 30; // Standardgröße
  color enemyColor; // Farbe des Gegners
  boolean isExploding = false; // Status, ob der Gegner explodiert
  int explosionFrames = 0; // Zähler für die Explosionsanimation
  float speed;

  // Konstruktor für den Gegner
  Enemy(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.enemyColor = color(255, 100, 100); // Standardfarbe Rot
  }

  // Aktualisierungsmethode für die Bewegung
  void update() {
    if (!isExploding) {
      y += speed + sin(frameCount * 0.1) * 1.5; // Bewegt sich leicht schwankend nach unten
    }
  }

  // Zeichnet den Gegner oder die Explosion
  void display() {
    if (isExploding) {
      fill(255, random(100, 255), 0, 255 - explosionFrames * 10);
      ellipse(x, y, size + explosionFrames * 5, size + explosionFrames * 5);
      explosionFrames++;
      if (explosionFrames > 10) isExploding = false;
    } else {
      enemyColor = color(255, random(50, 150), random(50, 150));
      fill(enemyColor);
      ellipse(x, y, size, size);
    }
  }

  // Setzt den Gegner in den Explosionsmodus
  void explode() {
    isExploding = true;
    explosionFrames = 0;
  }

  // Der Gegner schießt ein Projektil mit zufälliger horizontaler Abweichung
  void shoot(ArrayList<Bullet> bullets) {
    bullets.add(new Bullet(x, y, random(-1, 1), 3, color(255, 0, 0))); // Rotes Projektil
  }
}


// Verbesserte Boss-Klasse mit dynamischer Bewegung, komplexen Angriffsmustern und Lebensanzeige
class Boss extends Enemy {
  int health; // Lebenspunkte des Bosses
  float oscillationSpeed = 0.05; // Geschwindigkeit der horizontalen Schwingbewegung
  float shootingAngle = 0; // Startwinkel für rotierendes Schussmuster

  // Konstruktor für den Boss
  Boss(float x, float y, int health) {
    super(x, y, 1.5); // Ruft den Konstruktor der Enemy-Klasse auf
    this.size = 80; // Größere Größe für den Boss
    this.health = health; // Setzt die Lebenspunkte
  }

  // Aktualisiert die Bewegung des Bosses mit sanften, unvorhersehbaren Mustern
  @Override
  void update() {
    x += sin(frameCount * oscillationSpeed) * 8; // Seitliches Schwingen
    y += 0.8 + sin(frameCount * 0.03) * 1.5; // Langsame, unregelmäßige Bewegung nach unten
    oscillationSpeed += 0.0002; // Langsame Beschleunigung der horizontalen Bewegung
  }

  // Boss erleidet Schaden und wird aggressiver
  void takeDamage() {
    health--; // Reduziert Lebenspunkte
    if (health % 5 == 0) oscillationSpeed += 0.01; // Beschleunigt seine Bewegung alle 5 Treffer
  }

  // Prüft, ob der Boss besiegt wurde
  boolean isDead() {
    return health <= 0;
  }

  // Zeigt die Lebensanzeige des Bosses mit Farbverlauf an
  void displayHealth() {
    fill(50); // Dunkler Hintergrund für den Lebensbalken
    rect(width / 2 - 150, 20, 300, 20, 10); // Hintergrundbalken (grau)

    // Berechnung der Breite des roten Gesundheitsbalkens basierend auf den Lebenspunkten
    float healthBarWidth = map(health, 0, 50, 0, 300);

    // Farbverlauf von Rot (niedriges Leben) zu Grün (volles Leben)
    color barColor = lerpColor(color(255, 0, 0), color(0, 255, 0), health / 50.0);

    // Zeichnet den Gesundheitsbalken
    fill(barColor);
    rect(width / 2 - 150, 20, healthBarWidth, 20, 10);

    // Zeigt die aktuelle Anzahl der Lebenspunkte als Text an
    fill(255);
    textSize(20);
    text("Boss Health: " + health, width / 2 - 130, 15);
  }
}
