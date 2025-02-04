// Definition der Klasse Particle

class Particle {
  float x, y;           // Position des Partikels
  float speedX, speedY; // Geschwindigkeit des Partikels in X- und Y-Richtung
  int r, g, b;          // Farbe des Partikels
  int lifespan;         // Lebensdauer des Partikels
  int age;              // Alter des Partikels (wie lange es schon lebt)

  // Konstruktor für das Partikel
  Particle(float x, float y, float speedX, float speedY, int r, int g, int b) {
    this.x = x;
    this.y = y;
    this.speedX = speedX;
    this.speedY = speedY;
    this.r = r;
    this.g = g;
    this.b = b;
    this.lifespan = 255;  // Anfangslebensdauer (maximal 255)
    this.age = 0;
  }

  // Methode, um das Partikel zu aktualisieren (Position und Lebensdauer)
  void update() {
    x += speedX;  // Partikel bewegt sich in X-Richtung
    y += speedY;  // Partikel bewegt sich in Y-Richtung
    speedY += 0.05;  // Schwerkraft-Effekt (kann angepasst werden)
    lifespan -= 2;  // Partikel verliert Lebensdauer im Laufe der Zeit
    age++;  // Alter des Partikels erhöhen
  }

  // Methode, um das Partikel zu zeichnen
  void display() {
    fill(r, g, b, lifespan);  // Farbe des Partikels, abhängig von der Lebensdauer
    noStroke();
    ellipse(x, y, 5, 5);  // Zeichne das Partikel als kleinen Kreis
  }

  // Überprüfen, ob das Partikel noch lebt
  boolean isAlive() {
    return lifespan > 0;  // Wenn die Lebensdauer größer als 0 ist, lebt das Partikel noch
  }
}
