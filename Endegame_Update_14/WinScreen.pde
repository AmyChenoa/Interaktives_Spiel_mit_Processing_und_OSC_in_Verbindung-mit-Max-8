class WinScreen {
  Star[] stars = new Star[150];  // Hintergrundsterne für die Animation
  float alpha = 0;  // Transparenz für pulsierende Texteffekte
  Game game;  // Referenz auf das Game-Objekt, um Übergänge zu verwalten
  PImage WinImage;

  // Konstruktor: Initialisiert den Gewinnbildschirm und erstellt die Sterne im Hintergrund
  WinScreen(Game game) {
    this.game = game;  // Speichert die Referenz auf das Game-Objekt
    WinImage = loadImage("./data./WinScreen.png");

    // Erstelle die Sterne im Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();  // Jedes Sternobjekt wird in das Array eingefügt
    }
  }

  // Anzeige-Methode für den Gewinnbildschirm
  void display(int score) {
    // Hintergrundanimation (Sterne bewegen sich)
    drawBackground();

    // Titel "You Win!" mit pulsierenden Effekten
    drawTitle();

    // Zeigt den finalen Punktestand an
    drawScore(score);

    // Zeigt den Neustart-Hinweis an
    drawRestartText();
  }

  // Zeichnet den Hintergrund mit den bewegenden Sternen
  void drawBackground() {
    image(WinImage, 0, 0, width, height); // Hintergrundbild einmal zeichnen

    for (Star s : stars) {
      s.update();  // Aktualisiert die Position der Sterne
      s.show();    // Zeichnet die Sterne
    }
  }

  // Zeichnet den Titel "You Win!" mit mehreren Effekten (wie im Beispiel)
  void drawTitle() {
    textAlign(CENTER);  // Textzentrierung
    textSize(130);  // Sehr große Schrift für den Titel

    alpha = 150 + 105 * sin(millis() * 0.005);  // Sinusfunktion für das Pulsieren

    // Titel weiter nach oben
    float titleY = height / 4;

    // Titel mit mehreren Schatteneffekten
    fill(0, 0, 0, alpha);
    text("YOU WIN!", width / 2 + 5, titleY + 5);
    fill(0, 0, 0, alpha - 50);
    text("YOU WIN!", width / 2 + 8, titleY + 8);
    fill(0, 0, 0, alpha - 100);
    text("YOU WIN!", width / 2 + 12, titleY + 12);

    // Umrandung dicker
    fill(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(16);
    text("YOU WIN!", width / 2, titleY);

    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(10);
    text("YOU WIN!", width / 2, titleY);

    // Leuchtender Haupttext
    fill(0, 255, 255, alpha);
    noStroke();
    text("YOU WIN!", width / 2, titleY);
  }

  // Zeichnet den finalen Punktestand des Spiels
  void drawScore(int score) {
    textAlign(CENTER);  // Textzentrierung
    textSize(80);  // Noch größere Schriftgröße für den Punktestand

    // Punktestand ohne Schatten und niedriger positioniert
    fill(255);
    text("Final Score: " + score, width / 2, height * 2 / 3);  // Noch tiefer positioniert
  }

  // Zeichnet den Neustart-Hinweis
  void drawRestartText() {
    textAlign(CENTER);  // Textzentrierung
    textSize(30);  // Kleinere Schriftgröße für den Neustart-Hinweis

    // Weißer Text für den Neustart-Hinweis
    fill(255);  // Weißer Text ohne Schatten
    text("Press ENTER to Restart", width / 2, height * 2 / 3 + 140);  // Noch tiefer positioniert
  }
}
