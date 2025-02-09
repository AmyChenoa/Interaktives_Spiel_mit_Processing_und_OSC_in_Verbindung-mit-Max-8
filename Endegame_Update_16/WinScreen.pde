class WinScreen {
  Star[] stars = new Star[150];
  float alpha = 0;
  Game game;
  PImage WinImage;
  int highScore = 0;
  int currentScore = 0;



  WinScreen(Game game) {
    this.game = game;
    WinImage = loadImage("data./WinScreen.png");

    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
  }

  void display(int score) {
    currentScore = score;
    drawBackground();
    drawTitle();
    drawScore();
    drawHighScoreText();
    drawRestartText();
    updateHighScore();
  }

  void updateHighScore() {
    if (currentScore > game.highScore) {
      game.highScore = currentScore;
      game.saveHighScore();
    }
  }

  void drawBackground() {
    tint(255);  // Wichtig: Zurücksetzen der Transparenz!
    image(WinImage, 0, 0, width, height);
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  void drawTitle() {
    textAlign(CENTER);
    textSize(130);
    alpha = 150 + 105 * sin(millis() * 0.005);

    // Schwarzer Schatten für Tiefe
    fill(0, 0, 0, 200);
    text("YOU WIN!", width / 2 + 6, height / 4 + 6);

    // Leuchtender Farbeffekt (Rot + Orange Glow)
    fill(255, 50, 50);
    stroke(255, 150, 50);
    strokeWeight(12);
    text("YOU WIN!", width / 2, height / 4);

    // Animierter Cyan-Glow
    fill(0, 255, 255, alpha);
    noStroke();
    text("YOU WIN!", width / 2, height / 4);
  }



  void drawScore() {
    textSize(30);
    String scoreText = "Your Score: " + currentScore;
    float textWidthValue = textWidth(scoreText);
    float boxPadding = 20;

    // Hintergrund-Kästchen zeichnen
    fill(0, 0, 0, 150); // Schwarzer Hintergrund mit Transparenz
    rectMode(CENTER);
    rect(width / 2, height / 2, textWidthValue + boxPadding, 50, 10);

    // Text zeichnen
    fill(255);
    textAlign(CENTER, CENTER);
    text(scoreText, width / 2, height / 2);
  }


  void drawHighScoreText() {
    textSize(30);
    String highScoreText = "Highscore: " + highScore;
    float textWidthValue = textWidth(highScoreText);
    float boxPadding = 20;

    // Hintergrund-Kästchen zeichnen
    fill(0, 0, 0, 150);
    rectMode(CENTER);
    rect(width / 2, height / 2 + 50, textWidthValue + boxPadding, 50, 10);

    // Text zeichnen
    fill(255);
    textAlign(CENTER, CENTER);
    text(highScoreText, width / 2, height / 2 + 50);
  }

  void drawRestartText() {
    textAlign(CENTER);
    textSize(30);

    float restartAlpha = 150 + 80 * sin(millis() * 0.008);

    // Schwarzer Schatten
    fill(0, 0, 0, 180);
    text("Press ENTER to Restart", width / 2 + 3, height * 2 / 3 + 143);

    // Animierter Neon-Glow
    fill(0, 180, 255, restartAlpha);
    text("Press ENTER to Restart", width / 2, height * 2 / 3 + 140);
  }
}
