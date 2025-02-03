class FirstIntroScreen {
  Game game;
  float shipX, shipY; // Position des Raumschiffs
  float starSpeed = 2; // Geschwindigkeit der Sterne
  Star[] stars = new Star[150]; // Hintergrundsterne
  boolean introComplete = false;

  FirstIntroScreen(Game game) {
    this.game = game;
    shipX = -100; // Startposition des Raumschiffs
    shipY = height / 2;

    // Erstelle die Sterne im Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
  }

  void display() { // Diese Methode wurde hinzugefügt
    update();
  }

  void update() {
    drawBackground();
    drawShip();
    drawIntroText();

    // Bewegung des Raumschiffs
    shipX += 4; // Geschwindigkeit des Raumschiffs

    if (shipX > width + 100) {
      introComplete = true;
    }
  }

  void drawBackground() {
    background(0);
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  void drawShip() {
    fill(200, 200, 255);
    noStroke();
    pushMatrix();
    translate(shipX, shipY);
    triangle(-20, 10, -20, -10, 20, 0); // Raumschiff-Körper
    rect(-15, -5, -10, 10);             // Triebwerk
    fill(255, 100, 100);
    ellipse(-25, 0, 10, 10);           // Triebwerk-Flamme
    popMatrix();
  }

  void drawIntroText() {
    textAlign(CENTER);
    textSize(40);
    fill(255);
    text("Mission: Protect the Galaxy", width / 2, height / 4);

    if (introComplete) {
      textSize(30);
      fill(255, 255, 0);
      text("Press ENTER to Start", width / 2, height - 100);
    }
  }

  void keyPressed() {
    if (introComplete && key == ENTER) {
      game.triggerTransition(0); // Wechsel zum Spielbildschirm
    }
  }
}
