// Definition der Klasse Enemy

class Enemy {
  // Position des Gegners
  float x, y;

  // Größe des Gegners (Standardwert 30)
  float size = 30;

  // Konstruktor zur Initialisierung eines Gegners mit einer Startposition
  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
  }

  // Methode zur Aktualisierung der Position des Gegners (nach unten bewegen)
  void update() {
    y += 2; // Der Gegner bewegt sich mit konstanter Geschwindigkeit nach unten
  }

  // Methode zum Zeichnen des Gegners
  void display() {
    fill(255, 100, 100); // Rote Farbe für den Gegner
    ellipse(x, y, size, size); // Zeichnet einen Kreis als Gegner
  }

  // Methode für das Schießen (ein einzelnes Projektil mit zufälliger horizontaler Abweichung)
  void shoot(ArrayList<Bullet> bullets) {
    // Erstellt ein neues Projektil mit zufälliger horizontaler Abweichung (-1 bis 1)
    float randomSize = random(5, 20); // Beispielgröße zwischen 5 und 20

    bullets.add(new Bullet(x, y, random(-1, 1), 3, color(255, 0, 0), randomSize));
  }
}

// Klasse Boss (erbt von Enemy)
class Boss extends Enemy {
  // Lebenspunkte des Bosses
  int health;

  // Konstruktor für den Boss mit zusätzlicher Lebenspunkte-Variable
  Boss(float x, float y, int health) {
    super(x, y); // Ruft den Konstruktor der Enemy-Klasse auf
    this.size = 60; // Größere Größe für den Boss
    this.health = health; // Setzt die übergebene Lebenspunktezahl
  }

  // Überschreibt die update-Methode für eine spezielle Bewegung
  @Override
    void update() {
    x += sin(frameCount * 0.05) * 5; // Seitliche Schwingbewegung mit Sinus
    y += 1; // Langsame Vertikalbewegung nach unten
  }

  @Override
    void display() {
    fill(0, 255, 0);  // Boss in grüner Farbe
    ellipse(x, y, size, size);  // Zeichnet den Boss
  }

  // Überschreibt die shoot-Methode für den Boss (schießt in mehreren Richtungen)
  @Override
    void shoot(ArrayList<Bullet> bullets) {
    // Der Boss schießt in sechs Richtungen mit einem Winkelabstand von PI/6 (30°)
    for (float angle = 0; angle < TWO_PI; angle += PI / 6) {
      // Erstellt ein Projektil mit einer Geschwindigkeit von 3 in Richtung des Winkels
      float randomSize = random(5, 20); // Beispielgröße zwischen 5 und 20
      bullets.add(new Bullet(x, y, cos(angle) * 3, sin(angle) * 3, color(255, 150, 0), randomSize));
    }
  }

  // Methode zum Reduzieren der Lebenspunkte, wenn der Boss getroffen wird
  void takeDamage() {
    health--; // Verringert die Lebenspunkte um 1
  }

  // Überprüft, ob der Boss besiegt wurde (Lebenspunkte <= 0)
  boolean isDead() {
    return health <= 0;
  }

  // Methode zur Anzeige der Lebenspunkte des Bosses als Fortschrittsbalken
  void displayHealth() {
    // Hintergrund des Lebensbalkens
    fill(50, 50, 50);
    rect(width / 2 - 150, 20, 300, 20, 10); // Grauer Hintergrundbalken

    // Berechnung der Breite des roten Gesundheitsbalkens basierend auf den Lebenspunkten
    float healthBarWidth = map(health, 0, 50, 0, 300);

    // Zeichnet den roten Gesundheitsbalken
    fill(255, 0, 0);
    rect(width / 2 - 150, 20, healthBarWidth, 20, 10);

    // Textanzeige der aktuellen Lebenspunkte
    fill(255); // Weiße Farbe für den Text
    textSize(20); // Schriftgröße auf 20 setzen
    text("Boss Health: " + health, width / 2 - 130, 15); // Zeigt die Lebenspunkte als Text an
  }
}
