// Deklaration der Hauptklasse des Spiels als globale Variable
Game game;

void setup() {
  // Festlegen der Fenstergröße auf 1000 x 600 Pixel
  size(1000, 600);

  // Erstellen eines neuen Game-Objekts (Initialisierung des Spiels)
  game = new Game();

  // Aufruf der setup-Methode des Game-Objekts, um das Spiel vorzubereiten
  game.setup();
}

void draw() {
  // Zeichnet das Spiel in jeder Frame-Aktualisierung
  game.draw();
}

void mousePressed() {
  // Reagiert auf Mausklicks, indem die entsprechende Methode im Game-Objekt aufgerufen wird
  game.mousePressed();
}

void keyPressed() {
  // Reagiert auf Tastatureingaben, indem die entsprechende Methode im Game-Objekt aufgerufen wird
  game.keyPressed();
}
