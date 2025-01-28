class PowerUp {
  float x, y;
  int type; // 1 = Schild, 2 = Multi-Schuss, 3 = Leben

  PowerUp(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
  }

  void display() {
    if (type == 1) fill(0, 150, 255); // Schild
    else if (type == 2) fill(255, 255, 0); // Multi-Schuss
    else if (type == 3) fill(0, 255, 0); // Leben
    rect(x - 10, y - 10, 20, 20);
  }
}
