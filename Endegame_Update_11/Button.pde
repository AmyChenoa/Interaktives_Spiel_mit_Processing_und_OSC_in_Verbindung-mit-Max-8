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

  void display() {
    // Setze die weiße Umrandung für den Button
    stroke(255); // Weiße Umrandung
    strokeWeight(1); // Dünne Umrandung
    fill(mouseOver() ? color(0, 255, 150) : color(50)); // Füllfarbe ändern
    rect(x, y, w, h, 10); // Rechteck mit abgerundeten Ecken zeichnen

    // Text auf dem Button
    fill(255); // Textfarbe Weiß
    textAlign(CENTER, CENTER);
    textSize(20);
    text(label, x + w / 2, y + h / 2); // Text zentrieren
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
