class LevelScreen {
  Game game;
  Star[] stars = new Star[150];
  Button backButton;
  Button[] levels = new Button[9];
  float alpha = 0;
  PImage levelImage;

  LevelScreen(Game g) {
    this.game = g;
    levelImage = loadImage("./data./Weltall-4.png"); // Pfad korrigiert

    // Sterne erzeugen
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    // Zurück-Button
    backButton = new Button(20, 20, 100, 40, "BACK");

    // Level-Buttons dynamisch platzieren
    int buttonWidth = 200, buttonHeight = 50, gap = 20;
    int startY = height / 2;

    for (int i = 0; i < levels.length; i++) {
      int row = i / 3, col = i % 3;
      int x = (int) (width / 2 - (buttonWidth * 1.5) + col * (buttonWidth + gap));
      int y = startY + row * (buttonHeight + gap);
      levels[i] = new Button(x, y, buttonWidth, buttonHeight, "Level " + (i + 1));
    }
  }

  void display() {
    drawBackground();
    drawTitle();
    for (Button level : levels) level.display();
    backButton.display();
  }

  void drawBackground() {
    image(levelImage, 0, 0, width, height); // Hintergrund zeichnen
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  void drawTitle() {
    textAlign(CENTER);
    textSize(95);
    alpha = 150 + 105 * sin(millis() * 0.005);

    // Titel mit Umrandung
    fill(255, 255, 255, 180);
    stroke(10);
    strokeWeight(5);
    text("CHOOSE A LEVEL", width / 2, height / 3);

    // Leuchtender Effekt
    fill(0, 255, 255, alpha);
    text("CHOOSE A LEVEL", width / 2, height / 3);
  }

  void mousePressed() {
    if (backButton.isClicked()) {
      game.triggerTransition(0);
      return;
    }

    for (int i = 0; i < levels.length; i++) {
      if (levels[i].isClicked()) {
        println("Level " + (i + 1) + " Start!");
        Level currentLevel = new Level(i + 1);
        currentLevel.initializeLevel(game);
        game.triggerTransition(3);
        break;
      }
    }
  }
}
