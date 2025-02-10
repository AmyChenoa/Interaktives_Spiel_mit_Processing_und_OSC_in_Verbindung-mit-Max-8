class IntroScreen {
  Star[] stars = new Star[150];
  Game game;
  float alpha = 0;
  float backgroundShift = 0;
  float introProgress = 0;
  boolean introFinished = false;
  PImage backgroundImage;  // NEU: Hintergrundbild

  // Konstruktor
  IntroScreen(Game game) {
    this.game = game;
    
    // Sterne initialisieren
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    // Hintergrundbild laden
    backgroundImage = loadImage("data./intro_background.png");  // **Ersetze mit deinem Dateinamen**
  }

  void showIntro() {
    drawBackground();
    drawTitle();
    drawStartText();

    // Ladebalken aktualisieren
    if (introProgress < 1) {
      introProgress += 0.005;
      drawLoadingBar();
    } else {
      if (!introFinished) {
        introFinished = true;
        delay(500);
        game.triggerTransition(3);
      }
    }
  }

  void drawBackground() {
    if (backgroundImage != null) {
      image(backgroundImage, 0, 0, width, height);  // Skaliert auf Bildschirmgröße
    } else {
      // Fallback-Farbverlauf
      float r = 20 + 30 * sin(backgroundShift * 0.003);
      float g = 20 + 30 * cos(backgroundShift * 0.003);
      float b = 40 + 20 * sin(backgroundShift * 0.005);
      background(r, g, b);
    }

    // Sterne zeichnen
    for (Star s : stars) {
      s.update();
      s.show();
    }

    backgroundShift += 0.1;
  }

  void drawTitle() {
    textAlign(CENTER);
    textSize(80);
    alpha = 150 + 105 * sin(millis() * 0.003);

    fill(0, 0, 0, alpha);
    text("WELTRAUM-ABENTEUER", width / 2 + 5, height / 4 + 5);

    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(5);
    text("WELTRAUM-ABENTEUER", width / 2, height / 4);

    fill(0, 255, 255, alpha);
    noStroke();
    text("WELTRAUM-ABENTEUER", width / 2, height / 4);
  }

  void drawStartText() {
    textSize(30);
    float startTextAlpha = 150 + 105 * sin(millis() * 0.003);

    fill(0, 0, 0, startTextAlpha);
    text("Das Spiel beginnt bald...", width / 2 + 3, height / 2 + 3);

    fill(255, 0, 0, startTextAlpha);
    stroke(255, 0, 0);
    strokeWeight(4);
    text("Das Spiel beginnt bald...", width / 2, height / 2);

    fill(255, 255, 255, startTextAlpha);
    noStroke();
    text("Das Spiel beginnt bald...", width / 2, height / 2);
  }

  // **NEU: Verbesserter Ladebalken**
  void drawLoadingBar() {
    float barWidth = 300;
    float barHeight = 20;
    float x = width / 2 - barWidth / 2;  // Mittig ausrichten
    float y = height * 3 / 4;  // Unteres Drittel des Bildschirms

    // Hintergrund des Balkens (mit abgerundeten Ecken)
    fill(50, 50, 50, 180);
    stroke(0);
    strokeWeight(2);
    rect(x, y, barWidth, barHeight, 10);

    // Ladefortschritt (grüner Balken mit Farbverlauf)
    noStroke();
    for (int i = 0; i < barWidth * introProgress; i++) {
      float colorFactor = map(i, 0, barWidth, 50, 255);
      fill(0, colorFactor, 0);
      rect(x + i, y, 1, barHeight, 10);
    }
  }

  void update() {
    showIntro();
  }

  void keyPressed() {
    if (key == ENTER) {
      introFinished = true;
      delay(500);
      game.triggerTransition(3);
    }
  }
}
