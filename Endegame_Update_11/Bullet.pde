// Definition der Klasse Bullet (Projektil)
class Bullet {
  // Deklaration der Positionsvariablen
  float x, y;

  // Deklaration der Geschwindigkeitsvariablen für Bewegung in X- und Y-Richtung
  float speedX, speedY;

  // Deklaration der Farbvariable für das Projektil
  color c;

  float size;

  // Konstruktor der Bullet-Klasse, um ein neues Projektil zu erstellen
  Bullet(float x, float y, float speedX, float speedY, color c, float size) {
    // Initialisierung der X-Position mit dem übergebenen Wert
    this.x = x;

    // Initialisierung der Y-Position mit dem übergebenen Wert
    this.y = y;

    // Initialisierung der horizontalen Geschwindigkeit
    this.speedX = speedX;

    // Initialisierung der vertikalen Geschwindigkeit
    this.speedY = speedY;

    // Speichern der Farbe des Projektils
    this.c = c;

    this.size = size;  // Hinzugefügte Variable für die Größe des Projektils
  }

  // Methode zur Aktualisierung der Position des Projektils
  void update() {
    // Bewegen des Projektils entlang der X-Achse entsprechend seiner Geschwindigkeit
    x += speedX;

    // Bewegen des Projektils entlang der Y-Achse entsprechend seiner Geschwindigkeit
    y += speedY;
  }

  // Methode zum Zeichnen des Projektils auf dem Bildschirm
  void display() {
    // Setzt die Füllfarbe auf die gespeicherte Farbe des Projektils
    fill(c);

    // Zeichnet das Projektil als Kreis mit einem Durchmesser, der der Größe des Projektils entspricht
    ellipse(x, y, size, size);
  }

  // Methode zum Überprüfen, ob das Projektil den Bildschirm verlassen hat
  boolean isOutOfScreen() {
    return x < 0 || x > width || y < 0 || y > height;
  }
}
