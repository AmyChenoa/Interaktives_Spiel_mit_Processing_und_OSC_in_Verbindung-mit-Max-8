class Button {
  float x, y, w, h;
  String label;

  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  void display() {
    fill(mouseOver() ? color(0, 255, 150) : color(50));
    rect(x, y, w, h, 10);
    fill(255);
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
}
