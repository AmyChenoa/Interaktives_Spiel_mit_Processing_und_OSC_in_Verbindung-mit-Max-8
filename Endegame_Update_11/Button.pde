class Button {
  // Deklaration der Positions- und Größenvariablen
  float x, y, w, h;

  // Text, der auf dem Button angezeigt wird
  String label;

  // Konstruktor der Button-Klasse zur Initialisierung eines Buttons
  Button(float x, float y, float w, float h, String label) {
    // Speichert die X-Position des Buttons
    this.x = x;

    // Speichert die Y-Position des Buttons
    this.y = y;

    // Speichert die Breite des Buttons
    this.w = w;

    // Speichert die Höhe des Buttons
    this.h = h;

    // Speichert den Text, der auf dem Button angezeigt wird
    this.label = label;
  }

  // Methode zum Zeichnen des Buttons auf dem Bildschirm
  void display() {
    // Entferne die Umrandung des Buttons
    noStroke();

    // Setzt die Füllfarbe je nachdem, ob sich die Maus über dem Button befindet
    fill(mouseOver() ? color(0, 255, 150) : color(50));

    // Zeichnet den Button als Rechteck mit abgerundeten Ecken (Radius 10)
    rect(x, y, w, h, 10);

    // Setzt die Textfarbe auf Weiß
    fill(255);

    // Zentriert den Text sowohl horizontal als auch vertikal
    textAlign(CENTER, CENTER);

    // Setzt die Schriftgröße auf 20 Pixel
    textSize(20);

    // Zeichnet den Button-Text in der Mitte des Buttons
    text(label, x + w / 2, y + h / 2);
  }

  // Methode zur Überprüfung, ob der Button angeklickt wurde
  boolean isClicked() {
    // Gibt true zurück, wenn sich die Maus über dem Button befindet und eine Maustaste gedrückt ist
    return mouseOver() && mousePressed;
  }

  // Methode zur Überprüfung, ob sich die Maus über dem Button befindet
  boolean mouseOver() {
    // Prüft, ob die Mauskoordinaten innerhalb der Button-Grenzen liegen
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}
