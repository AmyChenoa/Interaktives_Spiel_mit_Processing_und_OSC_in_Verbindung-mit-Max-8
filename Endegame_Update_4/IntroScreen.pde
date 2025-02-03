class IntroScreen {
  Star[] stars = new Star[150];  // Sterne für den Hintergrund
  Game game;  // Referenz zur Game-Klasse
  float alpha = 0;  // Transparenz für den Text
  float backgroundShift = 0;  // Bewegung des Hintergrunds
  float introProgress = 0;  // Ladebalkenfortschritt
  boolean introFinished = false;  // Flag, um zu erkennen, ob das Intro abgeschlossen ist

  IntroScreen(Game game) {
    this.game = game;  // Weist die Game-Referenz zu

    // Erstelle die Sterne im Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
  }

  void showIntro() {
    // Hintergrundanimation (sanfte Farben und Bewegungen)
    drawBackground();

    // Titeltext-Animation
    drawTitle();

    // Start-Text mit pulsierender Transparenz
    drawStartText();

    // Langsame Ladebalken-Animation (jetzt ohne Pulsieren)
    if (introProgress < 1) {
      introProgress += 0.005; // Langsame Steigerung des Ladebalkens
      drawLoadingBar(width / 2 - 100, height * 3 / 4, 200, 20);
    } else {
      if (!introFinished) {
        introFinished = true;
        delay(500); // Kurze Pause für den Übergang
        game.triggerTransition(3); // Übergang zum Spiel
      }
    }
  }

  void drawBackground() {
    // Sanfter, subtiler Farbverlauf als Hintergrund
    float r = 20 + 30 * sin(backgroundShift * 0.003);
    float g = 20 + 30 * cos(backgroundShift * 0.003);
    float b = 40 + 20 * sin(backgroundShift * 0.005);
    background(r, g, b);  // Sanfte Farbänderung

    // Sanfte Bewegung von Sternen
    for (Star s : stars) {
      s.update();
      s.show();
    }

    // Langsame, subtile Farbverschiebung für das "Nebelfeld"
    backgroundShift += 0.1;  // Langsame Bewegung des Hintergrunds
  }

  void drawTitle() {
    textAlign(CENTER);
    textSize(80);  // Größere Schrift für den Titel

    // Sanft pulsierender Effekt für den Titel
    alpha = 150 + 105 * sin(millis() * 0.003);

    // Text mit weichen Schatteneffekten
    fill(0, 0, 0, alpha);
    text("WELTRAUM-ABENTEUER", width / 2 + 5, height / 4 + 5);
    fill(0, 0, 0, alpha - 50);
    text("WELTRAUM-ABENTEUER", width / 2 + 8, height / 4 + 8);
    fill(0, 0, 0, alpha - 100);
    text("WELTRAUM-ABENTEUER", width / 2 + 12, height / 4 + 12);

    // Sanfte Umrandung mit weichen, leuchtenden Farben
    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(5);
    text("WELTRAUM-ABENTEUER", width / 2, height / 4);

    // Leicht transparentes Türkis für den Titeltext
    fill(0, 255, 255, alpha);
    noStroke();
    text("WELTRAUM-ABENTEUER", width / 2, height / 4);
  }

  void drawStartText() {
    textSize(30);
    float startTextAlpha = 150 + 105 * sin(millis() * 0.003);  // Pulsierender Starttext
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

  void drawLoadingBar(float x, float y, float width, float height) {
    noStroke();
    fill(50, 50, 50);
    rect(x, y, width, height); // Hintergrund des Ladebalkens

    // Ruhiger Ladebalken ohne pulsieren
    fill(0, 255, 0);
    rect(x, y, width * introProgress, height); // Ladefortschritt
  }

  void update() {
    showIntro(); // Intro anzeigen
  }

  void keyPressed() {
    if (key == ENTER) {
      introFinished = true;
      delay(500); // Kurze Pause für den Übergang
      game.triggerTransition(3); // Sofort zum Spiel wechseln
    }
  }
}
