// Definition der Klasse Button
class Button {
  // Position und Größe des Buttons
  float x, y, w, h;

  // Beschriftung des Buttons
  String label;

  // Speichert die ursprünglichen Werte für einen späteren Reset
  final float originalX, originalY, originalW, originalH;
  final String originalLabel;

  // Konstruktor zum Erstellen eines Buttons mit bestimmten Eigenschaften
  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;

    // Speichert die ursprünglichen Werte für das Zurücksetzen
    this.originalX = x;
    this.originalY = y;
    this.originalW = w;
    this.originalH = h;
    this.originalLabel = label;
  }

  // Methode zur Darstellung des Buttons auf dem Bildschirm
  void display() {
    stroke(255); // Weißer Rahmen
    strokeWeight(1); // Dünne Rahmenlinie

    // Farbe ändern, wenn sich die Maus über dem Button befindet
    fill(mouseOver() ? color(0, 255, 150) : color(50));

    // Rechteck wird vom Mittelpunkt aus gezeichnet
    rectMode(CENTER);
    rect(x + w / 2, y + h / 2, w, h, 10); // Zeichnet den Button mit abgerundeten Ecken

    // Textfarbe je nach Mausposition ändern
    fill(mouseOver() ? color(0, 0, 0) : color(255));
    textAlign(CENTER, CENTER);
    textSize(20);
    text(label, x + w / 2, y + h / 2); // Zentriert den Text innerhalb des Buttons
  }

  // Prüft, ob der Button geklickt wurde
  boolean isClicked() {
    return mouseOver() && mousePressed;
  }

  // Prüft, ob sich die Maus über dem Button befindet
  boolean mouseOver() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }

  // Setzt den Button auf seine ursprünglichen Werte zurück
  void reset() {
    this.x = originalX;
    this.y = originalY;
    this.w = originalW;
    this.h = originalH;
    this.label = originalLabel;
  }
}
