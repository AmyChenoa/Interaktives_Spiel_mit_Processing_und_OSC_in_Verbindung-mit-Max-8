class LevelScreen {
  Game game;
  Star[] stars = new Star[150];
  Button backButton;
  Button[] levels = new Button[9];
  float alpha = 0;
  PImage StartImage; // Hintergrundbild für die Levelauswahl

  LevelScreen(Game g) {
    this.game = g;

    // Standard Hintergrundbild
    StartImage = loadImage("./data./Weltall-4.png");

    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    backButton = new Button(20, 20, 100, 40, "BACK");

    int buttonWidth = 200;
    int buttonHeight = 50;
    int gap = 20;
    int startY = height / 2;

    for (int i = 0; i < 9; i++) {
      int row = i / 3;
      int col = i % 3;
      int x = (int)(width / 2 - (buttonWidth * 1.5) + col * (buttonWidth + gap));
      int y = startY + row * (buttonHeight + gap);
      levels[i] = new Button(x, y, buttonWidth, buttonHeight, "Level " + (i + 1));
    }
  }

  void display() {
    drawBackground();
    drawTitle();
    for (Button level : levels) {
      level.display();
    }
    backButton.display();
  }

  void drawBackground() {
    // Hintergrundbild immer neu zeichnen
    image(StartImage, 0, 0, width, height); // Hintergrundbild einmal zeichnen
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  void drawTitle() {
    textAlign(CENTER);
    textSize(95);
    alpha = 150 + 105 * sin(millis() * 0.005);

    // Fettere Überschrift mit einer dünnen schwarzen Umrandung
    fill(255, 255, 255, 180); // Hellerer Weißton
    stroke(10); // Schwarze Umrandung
    strokeWeight(5); // Dünne Umrandung
    text("CHOOSE A LEVEL", width / 2, height / 3);

    // Leuchtender Titel
    fill(0, 255, 255, alpha);
    stroke(10); // Schwarze Umrandung
    text("CHOOSE A LEVEL", width / 2, height / 3);
  }

  void mousePressed() {
    if (backButton.isClicked()) {
      game.triggerTransition(0);
    }

    for (int i = 0; i < 9; i++) {
      if (levels[i].isClicked()) {
        println("Level " + (i + 1) + " Start!");

        // Setze das Hintergrundbild für das gewählte Level in der Game-Klasse
        game.backgroundImage = loadImage("./data./background" + (i + 1) + ".png");
        game.backgroundImage.resize(width, height);

        Level currentLevel = new Level(i + 1);
        currentLevel.initializeLevel(game);

        game.triggerTransition(3);  // Wechsel zu Spielansicht (Level)
      }
    }
  }
}
