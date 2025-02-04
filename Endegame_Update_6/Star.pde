// Definition der Star-Klasse (Sterne für den Hintergrund)

class Star {
  float x, y, speed;  // Position und Geschwindigkeit des Sterns

  // Konstruktor: Initialisiert den Stern mit zufälligen Werten
  Star() {
    x = random(width);   // Zufällige x-Position innerhalb des Bildschirmbereichs
    y = random(height);  // Zufällige y-Position innerhalb des Bildschirmbereichs
    speed = random(1, 3);  // Zufällige Geschwindigkeit des Sterns zwischen 1 und 3
  }

  // Update-Methode: Wird in jedem Frame aufgerufen, um die Position des Sterns zu aktualisieren
  void update() {
    y += speed;  // Bewegt den Stern in Richtung der unteren Bildschirmkante
    if (y > height) {  // Wenn der Stern das untere Ende des Bildschirms erreicht hat
      y = 0;           // Setzt den Stern an den oberen Bildschirmrand zurück
      x = random(width); // Setzt die x-Position des Sterns auf eine neue zufällige Position
    }
  }

  // Methode zum Zeichnen des Sterns auf dem Bildschirm
  void show() {
    fill(255, 255, 255, 150);  // Weiße Farbe mit Transparenz für den Stern
    noStroke();  // Kein Rand für den Stern
    ellipse(x, y, 2, 2);  // Zeichnet den Stern als kleinen Kreis
  }
}
