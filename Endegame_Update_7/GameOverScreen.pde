// Definition der verbesserten GameOverScreen-Klasse

class GameOverScreen {
  Star[] stars = new Star[150]; // Array von Sternen für den animierten Hintergrund
  Game game; // Referenz auf das Game-Objekt für Übergänge
  float alpha = 0; // Transparenzwert für Animationen
  float backgroundShift = 0; // Wert für den Hintergrund-Effekt
  float introProgress = 0; // Fortschritt der Ladeanimation
  boolean introFinished = false; // Status des GameOver-Screens
  int currentScore; // Aktueller Punktestand

  GameOverScreen(Game game, int score) {
    this.game = game;
    this.currentScore = score;

    // Initialisiert die Sterne für den Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
  }

  void showGameOver() {
    drawBackground();
    drawGameOverText();
    drawScoreBox();
    drawHighScoreText();
    drawRestartText();

    // Ladebalken-Animation mit sanftem Übergang
    if (introProgress < 1) {
      introProgress += 0.005;
    } else if (!introFinished) {
      introFinished = true;
      delay(500); // Sanfte Verzögerung
      game.triggerTransition(3); // Übergang zum nächsten Bildschirm
    }
  }

  void drawBackground() {
    // Farbverlauf für einen sanften animierten Hintergrund
    float r = 30 + 40 * sin(backgroundShift * 0.003);
    float g = 30 + 40 * cos(backgroundShift * 0.003);
    float b = 50 + 30 * sin(backgroundShift * 0.005);
    background(r, g, b);

    for (Star s : stars) {
      s.update();
      s.show();
    }
    backgroundShift += 0.1;
  }

  void drawGameOverText() {
    textAlign(CENTER);
    textSize(90);

    // Pulsierende Transparenz für den Titel
    alpha = 150 + 105 * sin(millis() * 0.003);

    // Schatten-Effekt für den Game Over Text
    fill(0, 0, 0, alpha - 100);
    text("GAME OVER", width / 2 + 12, height / 4 + 12);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(5);
    text("GAME OVER", width / 2, height / 4);
    fill(0, 255, 255, alpha);
    noStroke();
    text("GAME OVER", width / 2, height / 4);
  }

  void drawScoreBox() {
    fill(0, 0, 0, 180);
    noStroke();
    rectMode(CENTER);
    rect(width / 2, height / 2 + 80, 330, 90, 25);

    textSize(50);
    float scoreTextAlpha = 150 + 105 * sin(millis() * 0.005);
    fill(255, 255, 255, scoreTextAlpha);
    text("Score: " + currentScore, width / 2, height / 2 + 80);
  }

  void drawHighScoreText() {
    int highScore = Math.max(currentScore, loadHighScore());
    textSize(45);
    float highScoreTextAlpha = 150 + 105 * sin(millis() * 0.005);

    fill(255, 255, 255, highScoreTextAlpha);
    stroke(0, 255, 255);
    strokeWeight(4);
    text("Highscore: " + highScore, width / 2, height / 2 - 50);
    noStroke();
  }

  void drawRestartText() {
    textSize(45);
    float restartTextAlpha = 150 + 105 * sin(millis() * 0.005);

    fill(0, 255, 255, restartTextAlpha);
    text("Press ENTER to Restart", width / 2 + 3, height / 2 + 200 + 3);
    fill(255, 255, 255, restartTextAlpha);
    stroke(255, 255, 255);
    strokeWeight(4);
    text("Press ENTER to Restart", width / 2, height / 2 + 200);
    noStroke();
  }



  void saveHighScore(int highScore) {
    String filename = "highscore.txt";
    saveStrings(filename, new String[]{Integer.toString(highScore)});
  }

  int loadHighScore() {
    String filename = "highscore.txt";
    String[] lines = loadStrings(filename);
    return (lines != null && lines.length > 0) ? Integer.parseInt(lines[0]) : 0;
  }

  // Spiel zurücksetzen (z. B. bei einem Neustart)
  void resetGame() {
    currentScore = 0;  // Setzt den Score zurück
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();  // Setzt alle Sterne zurück
    }
  }

  void update() {
    showGameOver();
  }

  void keyPressed() {
    if (key == ENTER) {
      introFinished = true;
      delay(500);
      game.triggerTransition(3);
    }
  }
}
