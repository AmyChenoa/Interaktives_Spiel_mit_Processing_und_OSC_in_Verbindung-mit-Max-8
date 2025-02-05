class StartScreen {
  PImage StartImage;
  Star[] stars = new Star[150];  // Array für die Sterne im Hintergrund
  Button levelButton, helpButton;  // Buttons für die Level-Auswahl und Hilfe
  float alpha = 0;  // Transparenz für den Titeltext
  Game game;  // Referenz auf das Game-Objekt, um Übergänge zu verwalten

  // Konstruktor: Initialisiert den Startbildschirm und die Buttons
  StartScreen(Game game) {
    this.game = game;

    StartImage = loadImage("./data./StartScreen.png");
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    // Buttons weiter nach links verschieben
    levelButton = new Button(width / 2 - 420, height / 2 + 150, 200, 50, "LEVELS"); // Weiter nach links verschoben
    helpButton = new Button(width / 2 - 20, height / 2 + 150, 200, 50, "HELP");  // Position des Hilfe-Buttons bleibt unverändert
  }

  // Anzeige-Methode für den Startbildschirm
  void display() {
    drawBackground();
    drawTitle();
    drawStartText();
    levelButton.display();
    helpButton.display();
  }

  // Zeichnet den Hintergrund mit den bewegenden Sternen
  void drawBackground() {
    image(StartImage, 0, 0, width, height); // Hintergrundbild einmal zeichnen

    // Zeichne Sterne über das Bild
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  // Zeichnet den Titel des Spiels mit verschiedenen Effekten
  void drawTitle() {
    textAlign(CENTER);
    textSize(100);  // Noch größerer, fetterer Titel
    alpha = 150 + 105 * sin(millis() * 0.005);

    // Titel weiter nach oben
    float titleY = height / 4;

    // Titel mit mehreren Schatteneffekten
    fill(0, 0, 0, alpha);
    text("SPACE SHOOTER", width / 2 + 5, titleY + 5);
    fill(0, 0, 0, alpha - 50);
    text("SPACE SHOOTER", width / 2 + 8, titleY + 8);
    fill(0, 0, 0, alpha - 100);
    text("SPACE SHOOTER", width / 2 + 12, titleY + 12);

    // Umrandung dicker
    fill(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(16);
    text("SPACE SHOOTER", width / 2, titleY);

    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(10);
    text("SPACE SHOOTER", width / 2, titleY);

    // Leuchtender Haupttext
    fill(0, 255, 255, alpha);
    noStroke();
    text("SPACE SHOOTER", width / 2, titleY);
  }

  void drawStartText() {
    textSize(35);  // Größere Schriftgröße für mehr Sichtbarkeit
    float startTextAlpha = 150 + 105 * sin(millis() * 0.005);

    fill(0, 0, 0, startTextAlpha);
    textAlign(CENTER);
    
    // Text fetter und nach rechts verschoben
    strokeWeight(8);  // Text dicker machen
    text("Press ENTER to Start", width / 2 + 100, height / 2 + 3);  // Weiter nach rechts verschoben

    fill(255, 0, 0, startTextAlpha);
    stroke(255, 0, 0);
    strokeWeight(10);  // Fetterer Rand
    text("Press ENTER to Start", width / 2 + 100, height / 2);

    fill(255, 255, 255, startTextAlpha);
    strokeWeight(5);  // Dickerer weißer Text
    text("Press ENTER to Start", width / 2 + 100, height / 2);
  }

  // Überprüft, ob einer der Buttons geklickt wurde
  void mousePressed() {
    if (levelButton.isClicked()) {
      game.triggerTransition(1);  // Übergang zum Level-Auswahl-Bildschirm
    }
    if (helpButton.isClicked()) {
      game.triggerTransition(2);  // Übergang zum Hilfe-Bildschirm
    }
  }
}
