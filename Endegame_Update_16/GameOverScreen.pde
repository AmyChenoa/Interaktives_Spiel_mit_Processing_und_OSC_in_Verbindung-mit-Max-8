class GameOverScreen {
  Star[] stars = new Star[150];
  float alpha = 0;
  Game game;
  PImage gameOverImage;
  int highScore = 0;
  int currentScore = 0;

  GameOverScreen(Game game) {
    this.game = game;
    gameOverImage = loadImage("data./GameOverScreen.png");

    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
    loadHighScore();
  }

  void display(int finalScore) {
    currentScore = finalScore;
    drawBackground();
    drawTitle();
    drawScore();
    drawHighScoreText();
    drawRestartText();
    updateHighScore();

    if (game.screen != 6) game.screen = 6;
  }

  void updateHighScore() {
    if (currentScore > game.highScore) {
      game.highScore = currentScore;
      game.saveHighScore();
    }
  }

  void drawBackground() {
    tint(255);  // Wichtig für transparente Elemente
    image(gameOverImage, 0, 0, width, height);
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  void drawTitle() {
    textAlign(CENTER);
    textSize(110);
    alpha = 150 + 105 * sin(millis() * 0.005);

    // Schwarzer Schatten für Tiefe
    fill(0, 0, 0, 200);
    text("GAME OVER", width / 2 + 6, height / 4 + 6);

    // Roter Glow-Effekt für dramatische Wirkung
    fill(255, 50, 50);
    stroke(255, 150, 50);
    strokeWeight(12);
    text("GAME OVER", width / 2, height / 4);

    // Animierter Cyan-Glow
    fill(0, 255, 255, alpha);
    noStroke();
    text("GAME OVER", width / 2, height / 4);
  }

  void drawScore() {
    textSize(30);
    String scoreText = "Your Score: " + currentScore;
    float textWidthValue = textWidth(scoreText);
    float boxPadding = 20;

    // Hintergrund-Box für bessere Lesbarkeit
    fill(0, 0, 0, 150);
    rectMode(CENTER);
    rect(width / 2, height / 2, textWidthValue + boxPadding, 50, 10);

    // Punktzahl anzeigen
    fill(255);
    textAlign(CENTER, CENTER);
    text(scoreText, width / 2, height / 2);
  }

  void drawHighScoreText() {
    textSize(30);
    String highScoreText = "Highscore: " + game.highScore;
    float textWidthValue = textWidth(highScoreText);
    float boxPadding = 20;

    // Hintergrund-Box
    fill(0, 0, 0, 150);
    rectMode(CENTER);
    rect(width / 2, height / 2 + 50, textWidthValue + boxPadding, 50, 10);

    // Highscore anzeigen
    fill(255);
    textAlign(CENTER, CENTER);
    text(highScoreText, width / 2, height / 2 + 50);
  }

  void drawRestartText() {
    textAlign(CENTER);
    textSize(30);
    float restartAlpha = 150 + 80 * sin(millis() * 0.008);

    // Schwarzer Schatten für besseren Kontrast
    fill(0, 0, 0, 180);
    text("Press ENTER to Restart", width / 2 + 3, height * 2 / 3 + 143);

    // Animierter Neon-Glow
    fill(0, 180, 255, restartAlpha);
    text("Press ENTER to Restart", width / 2, height * 2 / 3 + 140);
  }

  void loadHighScore() {
    try {
      String[] data = loadStrings("highscore.txt");
      if (data != null && data.length > 0) {
        highScore = Integer.parseInt(data[0].trim());
      }
    } catch (Exception e) {
      println("Fehler beim Laden des Highscores: " + e.getMessage());
      highScore = 0;
    }
  }
}
