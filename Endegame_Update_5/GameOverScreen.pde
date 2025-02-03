class GameOverScreen {
  float alpha = 0;
  Star[] stars = new Star[150];
  int highScore = 0;  // Variable für den Highscore
  int currentScore = 0; // Aktueller Score
  Game game;

  // Konstruktor: Sterne initialisieren und Highscore laden
  GameOverScreen() {
    // this.game = game;  // Initialisiere die Referenz auf das Game-Objekt

    // Erstelle die Sterne im Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
    loadHighScore();  // Highscore laden
  }

  // Hintergrund zeichnen und Sterne bewegen
  void drawBackground() {
    background(0);
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  // Display des Game Over Screens
  void display(int finalScore) {
    currentScore = finalScore;  // Setzt den aktuellen Score

    // Hintergrund und Sterne
    drawBackground();

    // Game Over Text
    drawGameOverText();

    // Score Text (im separaten Kästchen)
    drawScoreBox();

    // Highscore Text
    drawHighScoreText();

    // Restart Text
    drawRestartText();

    // Highscore aktualisieren, wenn der aktuelle Score höher ist
    if (currentScore > highScore) {
      highScore = currentScore;
      saveHighScore();  // Speichert den neuen Highscore
    }
  }

  // Game Over Text
  void drawGameOverText() {
    textAlign(CENTER);
    textSize(80);

    alpha = 150 + 105 * sin(millis() * 0.005);

    fill(0, 0, 0, alpha);
    text("GAME OVER", width / 2 + 5, height / 3 + 5);
    fill(0, 0, 0, alpha - 50);
    text("GAME OVER", width / 2 + 8, height / 3 + 8);
    fill(0, 0, 0, alpha - 100);
    text("GAME OVER", width / 2 + 12, height / 3 + 12);

    fill(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(10);
    text("GAME OVER", width / 2, height / 3);

    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(5);
    text("GAME OVER", width / 2, height / 3);

    fill(0, 255, 255, alpha);
    noStroke();
    text("GAME OVER", width / 2, height / 3);
  }

  // Score Box für den aktuellen Score
  void drawScoreBox() {
    // Transparentes Rechteck für den Score
    fill(0, 0, 0, 150);  // Halbtransparentes Schwarz
    noStroke();
    rectMode(CENTER);
    rect(width / 2, height / 2, 300, 70);  // Box für den Score

    // Score Text
    textSize(30);
    float scoreTextAlpha = 150 + 105 * sin(millis() * 0.005);
    fill(255, 0, 0, scoreTextAlpha);
    text("Score: " + currentScore, width / 2, height / 2);
  }

  // Highscore Text
  void drawHighScoreText() {
    textSize(30);
    float highScoreTextAlpha = 150 + 105 * sin(millis() * 0.005);
    fill(0, 0, 0, highScoreTextAlpha); // Schatten
    text("Highscore: " + highScore, width / 2, height / 2 - 50);
    fill(255, 0, 0, highScoreTextAlpha); // Rote Umrandung
    stroke(255, 0, 0);
    strokeWeight(4);
    text("Highscore: " + highScore, width / 2, height / 2 - 50);

    fill(255, 255, 255, highScoreTextAlpha); // Weißer Text
    noStroke();
    text("Highscore: " + highScore, width / 2, height / 2 - 50);
  }

  // Restart Text
  void drawRestartText() {
    textSize(30);
    float restartTextAlpha = 150 + 105 * sin(millis() * 0.005);
    fill(0, 0, 0, restartTextAlpha); // Schatten
    text("Press ENTER to Restart", width / 2 + 3, height / 2 + 50 + 3);
    fill(255, 0, 0, restartTextAlpha); // Rote Umrandung
    stroke(255, 0, 0);
    strokeWeight(4);
    text("Press ENTER to Restart", width / 2, height / 2 + 50);

    fill(255, 255, 255, restartTextAlpha); // Weißer Text
    noStroke();
    text("Press ENTER to Restart", width / 2, height / 2 + 50);
  }

  // Highscore laden
  void loadHighScore() {
    String[] data = loadStrings("highscore.txt");  // Versucht, die Highscore-Datei zu laden
    if (data != null && data.length > 0) {
      highScore = Integer.parseInt(data[0]);  // Falls vorhanden, Highscore laden
    }
  }

  // Highscore speichern
  void saveHighScore() {
    String[] data = {str(highScore)};
    saveStrings("highscore.txt", data);  // Speichert den Highscore in der Datei
  }

  // Spiel zurücksetzen (z. B. bei einem Neustart)
  void resetGame() {
    currentScore = 0;  // Setzt den Score zurück
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();  // Setzt alle Sterne zurück
    }
  }

  // Überprüft, ob die ENTER-Taste gedrückt wurde
  void keyPressed() {
    if (key == ENTER) {
      resetGame();  // Spiel zurücksetzen
    }
  }
}
