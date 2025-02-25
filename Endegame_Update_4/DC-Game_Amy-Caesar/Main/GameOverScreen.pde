// Klasse für den Game-Over-Bildschirm
class GameOverScreen {
  Star[] stars = new Star[150]; // Array für Sterne als Hintergrundeffekt
  float alpha = 0; // Transparenzwert für das "GAME OVER"-Blitzen
  Game game; // Referenz auf das Hauptspielobjekt
  PImage gameOverImage; // Bild für den Game-Over-Bildschirm
  int highScore = 0; // Gespeicherter Highscore
  int currentScore = 0; // Spielerpunktzahl aus dem letzten Spiel
  boolean canRestart = false; // Steuerung für den Neustart (wird erst nach Anzeige erlaubt)

  // Konstruktor: Initialisiert den Game-Over-Bildschirm
  GameOverScreen(Game game) {
    this.game = game;
    gameOverImage = loadImage("data./GameOverScreen.png"); // Lädt das Game-Over-Bild

    // Erzeugt Sternobjekte für den animierten Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
    loadHighScore(); // Lädt den gespeicherten Highscore aus einer Datei
  }

  // Zeigt den Game-Over-Bildschirm an und aktualisiert den Highscore
  void display(int finalScore) {
    currentScore = finalScore; // Speichert die aktuelle Punktzahl
    drawBackground(); // Zeichnet den Hintergrund mit Sternen
    drawTitle(); // Zeichnet den "GAME OVER"-Text mit Effekten
    drawScore(); // Zeigt die aktuelle Punktzahl an
    drawHighScoreText(); // Zeigt den bisherigen Highscore an
    drawRestartText(); // Zeigt den Hinweis zum Neustarten des Spiels
    updateHighScore(); // Aktualisiert den Highscore, falls der Spieler ihn übertroffen hat

    // WICHTIG: Hier wird der Spielstatus **nicht** automatisch geändert!
    canRestart = true;  // Erst jetzt kann das Spiel per ENTER neu gestartet werden
  }

  // Überprüft, ob ENTER gedrückt wurde, um das Spiel zurückzusetzen
  void keyPressed() {
    if (canRestart && key == ENTER) {
      game.resetGame();  // Setzt das Spiel in den Startzustand zurück
      game.triggerTransition(0);  // Wechselt zurück zum Startbildschirm
    }
  }

  // Aktualisiert den Highscore, falls die aktuelle Punktzahl höher ist
  void updateHighScore() {
    if (currentScore > game.highScore) {
      game.highScore = currentScore; // Speichert den neuen Highscore
      game.saveHighScore(); // Speichert den Highscore dauerhaft
    }
  }

  // Zeichnet den Hintergrund mit Sternanimation
  void drawBackground() {
    tint(255); // Stellt sicher, dass das Bild nicht übermäßig transparent ist
    image(gameOverImage, 0, 0, width, height); // Zeichnet das Game-Over-Bild

    // Aktualisiert und zeigt alle Sterne aus dem Stern-Array
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  // Zeichnet den "GAME OVER"-Titel mit mehrschichtigen Effekten
  void drawTitle() {
    textAlign(CENTER); // Zentrierte Ausrichtung
    textSize(110); // Große Schrift für die Aufmerksamkeit
    alpha = 150 + 105 * sin(millis() * 0.005); // Blinke-Effekt durch Sinus

    // Schwarzer Schatten hinter dem Haupttext
    fill(0, 0, 0, 200);
    text("GAME OVER", width / 2 + 6, height / 4 + 6);

    // Haupttext in Rot mit orangefarbener Umrandung
    fill(255, 50, 50);
    stroke(255, 150, 50);
    strokeWeight(12);
    text("GAME OVER", width / 2, height / 4);

    // Leicht durchscheinender blauer Effekt für Leuchten
    fill(0, 255, 255, alpha);
    noStroke();
    text("GAME OVER", width / 2, height / 4);
  }

  // Zeigt die aktuelle Punktzahl mit einer Hintergrundbox an
  void drawScore() {
    textSize(30);
    String scoreText = "Your Score: " + currentScore;
    float textWidthValue = textWidth(scoreText); // Berechnet die Breite des Texts
    float boxPadding = 20; // Zusätzlicher Platz für die Hintergrundbox

    // Dunkler transparenter Hintergrund für bessere Lesbarkeit
    fill(0, 0, 0, 150);
    rectMode(CENTER);
    rect(width / 2, height / 2, textWidthValue + boxPadding, 50, 10);

    // Weißer Text mit zentrierter Ausrichtung
    fill(255);
    textAlign(CENTER, CENTER);
    text(scoreText, width / 2, height / 2);
  }

  // Zeigt den gespeicherten Highscore an
  void drawHighScoreText() {
    textSize(30);
    String highScoreText = "Highscore: " + game.highScore;
    float textWidthValue = textWidth(highScoreText);
    float boxPadding = 20;

    // Transparente Box als Hintergrund
    fill(0, 0, 0, 150);
    rectMode(CENTER);
    rect(width / 2, height / 2 + 50, textWidthValue + boxPadding, 50, 10);

    // Weißer Text mit zentrierter Ausrichtung
    fill(255);
    textAlign(CENTER, CENTER);
    text(highScoreText, width / 2, height / 2 + 50);
  }

  // Zeichnet den blinkenden "Press ENTER to Restart"-Text
  void drawRestartText() {
    textAlign(CENTER);
    textSize(30);
    float restartAlpha = 150 + 80 * sin(millis() * 0.008); // Blinke-Effekt durch Sinus

    // Schwarzer Schatten für bessere Lesbarkeit
    fill(0, 0, 0, 180);
    text("Press ENTER to Restart", width / 2 + 3, height * 2 / 3 + 143);

    // Blauer blinkender Haupttext
    fill(0, 180, 255, restartAlpha);
    text("Press ENTER to Restart", width / 2, height * 2 / 3 + 140);
  }

  // Lädt den gespeicherten Highscore aus einer Datei
  void loadHighScore() {
    try {
      String[] data = loadStrings("highscore.txt"); // Lädt die Datei mit dem Highscore
      if (data != null && data.length > 0) {
        highScore = Integer.parseInt(data[0].trim()); // Konvertiert den gespeicherten String in eine Zahl
      }
    }
    catch (Exception e) {
      println("Fehler beim Laden des Highscores: " + e.getMessage()); // Fehlerbehandlung
      highScore = 0; // Falls ein Fehler auftritt, wird der Highscore auf 0 gesetzt
    }
  }
}
