class Button {
  float x, y, w, h;
  String label;

  // Speichert die ursprünglichen Werte für den Reset
  final float originalX, originalY, originalW, originalH;
  final String originalLabel;

  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;

    // Ursprüngliche Werte speichern
    this.originalX = x;
    this.originalY = y;
    this.originalW = w;
    this.originalH = h;
    this.originalLabel = label;
  }
  void display() {
    stroke(255);
    strokeWeight(1);
    fill(mouseOver() ? color(0, 255, 150) : color(50));

    // Stelle sicher, dass das Rechteck vom Mittelpunkt aus gezeichnet wird
    rectMode(CENTER);
    rect(x + w / 2, y + h / 2, w, h, 10);

    fill(mouseOver() ? color(0, 0, 0) : color(255));
    textAlign(CENTER, CENTER);
    textSize(20);
    text(label, x + w / 2, y + h / 2);
  }


  boolean isClicked() {
    return mouseOver() && mousePressed;
  }

  boolean mouseOver() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }

  // Reset-Methode, um den ursprünglichen Zustand des Buttons wiederherzustellen
  void reset() {
    this.x = originalX;
    this.y = originalY;
    this.w = originalW;
    this.h = originalH;
    this.label = originalLabel;
  }
}
