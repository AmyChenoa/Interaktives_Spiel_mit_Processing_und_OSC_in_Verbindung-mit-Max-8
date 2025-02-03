// Main Klasse
Game game;

void setup() {
  size(1000, 600);
  game = new Game();
  game.setup();
}

void draw() {
  game.draw();
}

void mousePressed() {
  game.mousePressed();
}

void keyPressed() {
  game.keyPressed();
}
