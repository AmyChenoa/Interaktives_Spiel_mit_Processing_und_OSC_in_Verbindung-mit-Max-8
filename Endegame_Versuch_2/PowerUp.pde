class PowerUp {
  float x, y;
  int type; // 1 = Schild, 2 = Multischuss

  PowerUp(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
  }

  void display() {
    fill(type == 1 ? color(0, 150, 255) : color(255, 255, 0));
    rect(x - 10, y - 10, 20, 20);
  }
}
